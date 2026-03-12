class_name GhostsManager
extends Node2D


@export var maze: Maze


var spawned_ghosts: Dictionary[Game.Ghosts, Ghost]
var ghosts := {
	Game.Ghosts.Chaser: {
		"scene": preload("res://scenes/actors/ghosts/chaser/chaser.tscn"),
		"spawn_location": Game.JailCell.Out,
	},
	Game.Ghosts.Ignorant: {
		"scene": preload("res://scenes/actors/ghosts/ignorant/ignorant.tscn"),
		"spawn_location": Game.JailCell.Left,
	},
	Game.Ghosts.Ambusher: {
		"scene": preload("res://scenes/actors/ghosts/ambusher/ambusher.tscn"),
		"spawn_location": Game.JailCell.Center,
	},
	Game.Ghosts.Fickle: {
		"scene": preload("res://scenes/actors/ghosts/fickle/fickle.tscn"),
		"spawn_location": Game.JailCell.Right,
	}
}


func _ready() -> void:
	for ghost_key: Game.Ghosts in ghosts.keys():
		var ghost: Ghost = ghosts[ghost_key]["scene"].instantiate()
		var spawn_location: Game.JailCell = ghosts[ghost_key]["spawn_location"]
		ghost.position = Game.ghost_jail_positions[spawn_location]
		ghost.manager = self
		add_child(ghost)
		spawned_ghosts[ghost_key] = ghost


func get_ghost_position(ghost_name: Game.Ghosts) -> Vector2:
	return spawned_ghosts[ghost_name].position
