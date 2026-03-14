class_name GhostsManager
extends Node2D


@export var maze: Maze


var spawned_ghosts: Dictionary[MazeConfig.Ghosts, Ghost]
var ghosts := {
	MazeConfig.Ghosts.Chaser: {
		"scene": preload("res://scenes/actors/ghosts/chaser/chaser.tscn"),
		"spawn_location": MazeConfig.JailCell.Out,
	},
	MazeConfig.Ghosts.Ignorant: {
		"scene": preload("res://scenes/actors/ghosts/ignorant/ignorant.tscn"),
		"spawn_location": MazeConfig.JailCell.Left,
	},
	MazeConfig.Ghosts.Ambusher: {
		"scene": preload("res://scenes/actors/ghosts/ambusher/ambusher.tscn"),
		"spawn_location": MazeConfig.JailCell.Center,
	},
	MazeConfig.Ghosts.Fickle: {
		"scene": preload("res://scenes/actors/ghosts/fickle/fickle.tscn"),
		"spawn_location": MazeConfig.JailCell.Right,
	}
}


func _ready() -> void:
	for ghost_key: MazeConfig.Ghosts in ghosts.keys():
		var ghost: Ghost = ghosts[ghost_key]["scene"].instantiate()
		var spawn_location: MazeConfig.JailCell = ghosts[ghost_key]["spawn_location"]
		ghost.position = MazeConfig.ghost_jail_positions[spawn_location]
		ghost.manager = self
		add_child(ghost)
		spawned_ghosts[ghost_key] = ghost


func get_ghost_position(ghost_name: MazeConfig.Ghosts) -> Vector2:
	return spawned_ghosts[ghost_name].position
