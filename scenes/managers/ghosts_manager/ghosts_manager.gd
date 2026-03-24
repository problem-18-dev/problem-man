class_name GhostsManager
extends Node2D


const EATEN_TIMERS: Array[int] = [3, 5, 7]

enum Ghosts { Chaser, Ignorant, Ambusher, Fickle }

@export_group("Debug")
@export var ghost_nav_lines := false
@export_group("Dependencies")
@export var maze: Maze
@export var player: Player


var _spawned_ghosts: Dictionary[Ghosts, Ghost]
var _eaten_ghosts: Array[Ghost]
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
	
	if ghost_nav_lines:
		for ghost: Ghost in _spawned_ghosts.values():
			ghost.draw_nav_lines()


func stop_ghosts() -> void:
	for ghost: Ghost in _spawned_ghosts.values():
		ghost.stop()


func enter_frightened() -> void:
	for ghost: Ghost in _spawned_ghosts.values():
		if not ghost.is_in_state(Ghost.State.Eaten):
			ghost.change_state(Ghost.State.Frightened)
			continue
		
		ghost.change_state(Ghost.State.Eaten)


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
		ghost.position = Ghost.JAIL_COORDINATES[spawn_location]
		ghost.manager = self
		ghost.player = player
		ghost.eaten.connect(_on_ghost_eaten)
		add_child(ghost)
		_spawned_ghosts[ghost_key] = ghost


func _on_ghost_eaten(ghost: Ghost) -> void:
	if ghost is Chaser:
		ghost.change_state(Ghost.State.Eaten)
		return
	
	var respawn_timer := EATEN_TIMERS[_eaten_ghosts.size()]
	ghost.change_state(Ghost.State.Eaten, { "respawn_timer": respawn_timer })
