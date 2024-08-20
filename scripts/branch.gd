extends Node2D

@export var data: BranchInstance

var can_grow: bool = true
var max_growth: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func grow_branch() -> void:
	if can_grow and max_growth > 0:
		max_growth -= 1
		self.scale += Vector2(data.growth_rate, data.growth_rate/2.0)
		check_collitions()
	if self.name != "Seed":
		self.position.y -= data.move_rate

func check_collitions() -> void:
	var tip = get_node("Tip")
	if tip:
		if not is_in_group("mother_branch"):
			if tip.has_overlapping_areas():
				for collision in tip.get_overlapping_areas():
					if collision.is_in_group("branch_base") or collision.is_in_group("not_branch"):
						continue
					else:
						can_grow = false
						tip.queue_free()
