extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade in")
	await(get_tree().create_timer(11)).timeout
	get_node("logo").hide()
	await(get_tree().create_timer(3.5)).timeout
	self.hide()
	#get_tree().change_scene_to_file("res://scenes/tree_level.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
