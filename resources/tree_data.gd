extends Resource
class_name TreeInstance

@export var energy : int = 100
@export var GROW_SPEED: float = 5
@export var MAX_ANGLE: float = 0.1
@export var branch_types: Array[PackedScene]
@export var root_types: Array[PackedScene]
@export var leaf_type: PackedScene

func pick_random_branch() -> PackedScene:
	return branch_types[randi() % branch_types.size()] as PackedScene

func pick_random_root() -> PackedScene:
	return root_types[randi() % root_types.size()] as PackedScene
	
func pick_leaf() -> PackedScene:
	return leaf_type as PackedScene
