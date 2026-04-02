extends Node


enum LevelType { Classic, Tricat, KeyBricks, INeedToGo, CheeseChasers }
enum Phase { Chase, Scatter }

const PHASES := {
	Phase.Chase: "Chase",
	Phase.Scatter: "Scatter",
}

const PHASE_TO_GHOST_STATE_MAP: Dictionary[Phase, Ghost.State] = {
	Phase.Chase: Ghost.State.Chase,
	Phase.Scatter: Ghost.State.Scatter,
}

const LEVEL_RESOURCES: Dictionary[LevelType, LevelResource] = {
	LevelType.Classic: preload("res://resources/classic.tres"),
	LevelType.Tricat: preload("res://resources/tricat.tres"),
	LevelType.KeyBricks: preload("res://resources/keybricks.tres"),
	LevelType.INeedToGo: preload("res://resources/i_need_to_go.tres"),
	LevelType.CheeseChasers: preload("res://resources/cheese_chasers.tres"),
}


func get_ghost_speed() -> float:
	var current_level := GameManager.get_current_level()
	
	match current_level:
		1:
			return 70
		2, 3, 4:
			return 75
		_:
			return 80


func get_ghost_cruise_elroy_speed() -> float:
	return get_ghost_speed() + 10


func get_player_speed() -> float:
	var current_level := GameManager.get_current_level()
	
	match current_level:
		1:
			return 110
		2, 3, 4:
			return 115
		_:
			return 120


func get_player_cruise_elroy_speed() -> float:
	return get_player_speed() + 10


func get_current_level_resource() -> LevelResource:
	return LEVEL_RESOURCES[GameManager.current_level_type]
