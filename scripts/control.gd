extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pause_pressed() -> void:
	get_parent().pause()


func _on_branch_mode_pressed() -> void:
	get_parent().change_mode(0)


func _on_leaves_mode_pressed() -> void:
	get_parent().change_mode(1)


func _on_roots_mode_pressed() -> void:
	get_parent().change_mode(2)


func _on_resume_pressed() -> void:
	get_parent().resume()


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tree_level.tscn")


func _on_menu_pressed() -> void:
	print("Not yet developed!")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
