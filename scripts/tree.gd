extends Node2D

@export var data: TreeInstance
@export var BRANCH_COST: int = 5

var can_grow: bool = false
var check_growth: bool = true
var mother_branch: Node2D
var new_branch: Marker2D = Marker2D.new()
var mark: Node2D
var running: bool = true
var balance: float = 0
var playing_area: bool = true
var mode: int = 0 # 0 is branch, 1 is leaf, 2 is root

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var b1 = data.pick_random_branch().instantiate()
	b1.name = "Seed"
	add_child(b1)
	b1.look_at(Vector2(self.position.x, self.position.y - 10))
	b1.scale = Vector2(0.2,0.2)
	b1.max_growth = data.energy
	mother_branch = b1
	mother_branch.add_to_group("mother_branch")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if running:
		process_input()
		if data.energy > 0 and check_growth:
			grow_all_children()
		check_balance()

func process_input() -> void:
	if playing_area:
		if Input.is_action_just_pressed("spawn"):
			if check_if_touching_branch():
				can_grow = true
				new_branch.position = get_local_mouse_position()
				get_parent().print_marker()
				
		if Input.is_action_just_released("spawn"):
			if can_grow:
				var b: Node2D
				match mode:
					0:
						if data.energy > BRANCH_COST:
							data.energy -= BRANCH_COST
							b = data.pick_random_branch().instantiate()
							b.max_growth = randi() % 400 + 100
							b.scale = Vector2(0.1,0.1)
					1:
						b = data.pick_leaf().instantiate()
						b.get_node("Hoja/hojitas").play()
						b.add_to_group("ignore_grow")
						b.add_to_group("leafs")
					2:
						if data.energy > BRANCH_COST:
							data.energy -= BRANCH_COST
							b = data.pick_random_root().instantiate()
							b.scale = Vector2(0.4,0.4)
				add_child(b)
				b.position = new_branch.position
				b.look_at(get_global_mouse_position())
				can_grow = false
			get_parent().delete_marker()

func check_if_touching_branch() -> bool:
	var pp = PhysicsPointQueryParameters2D.new()
	pp.collide_with_areas = true 
	pp.position = get_global_mouse_position()
	pp.set_exclude([get_node("left").get_rid(), get_node("right").get_rid()])
	var collitions = get_world_2d().direct_space_state.intersect_point(pp, 1)
	if collitions:
		mother_branch = collitions[0].collider.get_parent()
		mother_branch.add_to_group("mother_branch")
		return true
	return false

func check_balance() -> void:
	get_balance()
	if balance < -5 and abs(self.rotation) < data.MAX_ANGLE:
		self.rotation -= 0.001
	if balance > 5 and abs(self.rotation) < data.MAX_ANGLE:
		self.rotation += 0.001

func get_balance() -> void:
	var left = get_node("left").get_overlapping_areas()
	var right = get_node("right").get_overlapping_areas()
	balance = 0.0
	for area in left:
		if data.energy > 0 and check_growth:
			area.get_parent().position.x -= 5
		balance -= 1
	for area in right:
		if data.energy > 0 and check_growth:
			area.get_parent().position.x += 5
		balance += 1

func grow_all_children() -> void:
	data.energy -= 1
	check_growth = false
	for child in get_children():
		#child.rotation
		if not child.is_in_group("ignore_grow"):
			child.grow_branch()
		elif child.is_in_group("leafs"):
			child.position.y -= data.move_rate_leafs
	await get_tree().create_timer(1.0/data.GROW_SPEED).timeout
	check_growth = true
	
