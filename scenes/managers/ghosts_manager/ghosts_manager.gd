class_name GhostsManager
extends Node2D


enum Ghosts {Chaser, Ignorant, Ambusher, Fickle}

@export var maze: Maze


var _spawned_ghosts: Dictionary[Ghosts, Ghost]
var _ghosts := {
	Ghosts.Chaser: {
		"scene": preload("res://scenes/actors/ghosts/chaser/chaser.tscn"),
		"spawn_location": Ghost.JailCell.Out,
	},
	Ghosts.Ignorant: {
		"scene": preload("res://scenes/actors/ghosts/ignorant/ignorant.tscn"),
		"spawn_location": Ghost.JailCell.Left,
	},
	Ghosts.Ambusher: {
		"scene": preload("res://scenes/actors/ghosts/ambusher/ambusher.tscn"),
		"spawn_location": Ghost.JailCell.Center,
	},
	Ghosts.Fickle: {
		"scene": preload("res://scenes/actors/ghosts/fickle/fickle.tscn"),
		"spawn_location": Ghost.JailCell.Right,
	}
}


func _ready() -> void:
	_spawn_ghosts()


func enter_frightened() -> void:
	for ghost: Ghost in _spawned_ghosts.values():
		if not ghost.is_in_state(Ghost.State.Eaten):
			ghost.change_state(Ghost.State.Frightened)


func exit_frightened() -> void:
	var game_phase := GameManager.get_current_phase()
	var new_state := GameConfig.PHASE_TO_GHOST_STATE_MAP[game_phase]
	
	for ghost: Ghost in _spawned_ghosts.values():
		if not ghost.is_in_state(Ghost.State.Eaten):
			ghost.change_state(new_state)


func attempt_state(state: Ghost.State) -> void:
	for ghost: Ghost in _spawned_ghosts.values():
		var is_eaten := ghost.is_in_state(Ghost.State.Eaten)
		var is_frightened := ghost.is_in_state(Ghost.State.Frightened)
		if is_eaten or is_frightened:
			continue
		
		ghost.change_state(state)


func get_ghost_position(ghost_name: Ghosts) -> Vector2:
	return _spawned_ghosts[ghost_name].position


func _spawn_ghosts() -> void:
	for ghost_key: Ghosts in _ghosts.keys():
		var ghost: Ghost = _ghosts[ghost_key]["scene"].instantiate()
		var spawn_location: Ghost.JailCell = _ghosts[ghost_key]["spawn_location"]
		ghost.position = maze.map_to_local(Ghost.JAIL[spawn_location])
		ghost.manager = self
		add_child(ghost)
		_spawned_ghosts[ghost_key] = ghost
