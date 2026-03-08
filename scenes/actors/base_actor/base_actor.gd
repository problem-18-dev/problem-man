class_name BaseActor
extends CharacterBody2D


var _maze: Maze


func _ready() -> void:
	_maze = _get_maze()


func _get_maze() -> TileMapLayer:
	return get_tree().get_first_node_in_group("maze")
