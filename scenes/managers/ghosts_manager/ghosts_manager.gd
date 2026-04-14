class_name GhostsManager
extends Node2D


const EATEN_TIMERS: Array[int] = [3, 5, 7]

@export_group("Debug")
@export var ghost_nav_lines := false
@export_group("Dependencies")
@export var maze: Maze
@export var player: Player

var _eaten_ghosts := 0
var _score_multiplier := 1

@onready var chaser: Chaser = $Chaser
@onready var ignorant: Ignorant = $Ignorant
@onready var ambusher: Ambusher = $Ambusher
@onready var fickle: Fickle = $Fickle
@onready var ghosts := [chaser, ignorant, ambusher, fickle]


func _ready() -> void:
	_prepare_ghosts()
	
	if ghost_nav_lines:
		for ghost: Ghost in ghosts:
			ghost.draw_nav_lines()


func start_ghosts() -> void:
	for ghost: Ghost in ghosts:
		ghost.start()


func stop_ghosts() -> void:
	for ghost: Ghost in ghosts:
		ghost.stop()


func cruise_elroy() -> void:
	chaser.enter_cruise_elroy()


func enter_frightened() -> void:
	for ghost: Ghost in ghosts:
		if not ghost.is_in_state(Ghost.State.Eaten):
			ghost.change_state(Ghost.State.Frightened)
			continue


func exit_frightened() -> void:
	var game_phase := GameManager.get_current_phase()
	var new_state := GameConfig.PHASE_TO_GHOST_STATE_MAP[game_phase]
	
	for ghost: Ghost in ghosts:
		if not ghost.is_in_state(Ghost.State.Eaten):
			ghost.change_state(new_state)
	
	# Reset score multiplier when frigthened is fully over.
	_score_multiplier = 1


func attempt_state(state: Ghost.State) -> void:
	for ghost: Ghost in ghosts:
		var is_eaten := ghost.is_in_state(Ghost.State.Eaten)
		var is_frightened := ghost.is_in_state(Ghost.State.Frightened)
		if is_eaten or is_frightened:
			continue
		
		ghost.change_state(state)


func get_chaser_position() -> Vector2:
	return chaser.position


func _prepare_ghosts() -> void:
	for ghost: Ghost in ghosts:
		ghost.manager = self
		ghost.player = player
		ghost.eaten.connect(_on_ghost_eaten)
		ghost.respawned.connect(_on_ghost_respawned)


func _process_score(ghost: Ghost) -> int:
	var score := ghost.BASE_SCORE * _score_multiplier
	GameManager.add_score(score)
	_score_multiplier *= 2
	return score


func _on_ghost_eaten(ghost: Ghost) -> void:
	var score := _process_score(ghost)
	if ghost is Chaser:
		ghost.change_state(Ghost.State.Eaten, { "score": score })
	else:
		var respawn_timer := EATEN_TIMERS[_eaten_ghosts]
		ghost.change_state(Ghost.State.Eaten, { "score": score, "respawn_timer": respawn_timer })
		_eaten_ghosts += 1


func _on_ghost_respawned(ghost: Ghost) -> void:
	if ghost is Chaser:
		return
	
	_eaten_ghosts -= 1
