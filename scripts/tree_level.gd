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
	
	$tutorial.modulate.a = 0
	$tutorial2.modulate.a = 0
	$tutorial3.modulate.a = 0
	
	if Load.intro:
		Load.skip_intro()
		await(get_tree().create_timer(13)).timeout
	else:
		get_node("intro").hide()
	tree.running = true
	if Load.tutorial == 1:
		await(get_tree().create_timer(1)).timeout
		var tween = create_tween()
		tween.tween_property($tutorial, "modulate:a", 1.0, 1)


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
	var music_bus = AudioServer.get_bus_index("music")
	AudioServer.set_bus_volume_db(music_bus, -12)
	#get_node("music").bus = "underwater"
	
func resume() -> void:
	tree.running = true
	get_node("UI").get_node("pause_overlay").hide()
	var music_bus = AudioServer.get_bus_index("music")
	AudioServer.set_bus_volume_db(music_bus, 0)
	#get_node("music").bus = "music"
	
func pass_tutorial() -> void:
	var tween = create_tween()
	if Load.tutorial == 1:
		tween.tween_property($tutorial, "modulate:a", 0.0, 1)
		tween.tween_property($tutorial2, "modulate:a", 1.0, 1)
		Load.tutorial = 2
	elif Load.tutorial == 2:
		tween.tween_property($tutorial2, "modulate:a", 0.0, 1)
		tween.tween_property($tutorial3, "modulate:a", 1.0, 1)
		tween.tween_property($tutorial3, "modulate:a", 0.0, 1)
		Load.tutorial = 3
	
