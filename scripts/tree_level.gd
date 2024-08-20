extends Node2D

@export var trees: PackedScene = preload("res://scenes/tree.tscn")

var marker: PackedScene = preload("res://scenes/marker.tscn")

var tree: Node2D
var mark: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("UI/UI_area").mouse_entered.connect(_on_mouse_entered_ui)
	get_node("UI/UI_area").mouse_exited.connect(_on_mouse_exited_ui)
	get_node("UI").get_node("pause_overlay").hide()
	tree = trees.instantiate()
	add_child(tree)
	tree.position = get_node("seed_point").get_global_position()
	get_node("UI/Info/Stats/EnergyBar").max_value = tree.data.energy
	
	#await(get_tree().create_timer(13)).timeout
	tree.running = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	get_node("UI/Info/Stats/EnergyBar").set_value(tree.data.energy)
	if mark:
		mark.look_at(get_global_mouse_position())

func _on_mouse_entered_ui():
	print("UI")
	tree.playing_area = false

func _on_mouse_exited_ui():
	print("Exited UI")
	tree.playing_area = true


func print_marker() -> void:
	mark = marker.instantiate()
	get_parent().add_child(mark)
	mark.position = get_local_mouse_position()
	mark.look_at(get_global_mouse_position())

func delete_marker() -> void:
	if mark:
		mark.queue_free()
	mark = null

func change_mode(mode: int) -> void:
	tree.mode = mode

func pause() -> void:
	tree.running = false
	get_node("UI").get_node("pause_overlay").show()
	get_node("music").bus = "underwater"
	
func resume() -> void:
	tree.running = true
	get_node("UI").get_node("pause_overlay").hide()
	get_node("music").bus = "music"
