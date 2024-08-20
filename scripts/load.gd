extends Node

var intro: bool = true
var tutorial: int = 1

func skip_intro() -> void:
	intro = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
