extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade in")
	await(get_tree().create_timer(10)).timeout
	get_tree().change_scene_to_file("res://scenes/tree_level.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
