extends Node


enum Phase { Chase, Scatter }

const PHASES := {
	Phase.Chase: "Chase",
	Phase.Scatter: "Scatter",
}

const PHASE_TO_GHOST_STATE_MAP: Dictionary[Phase, Ghost.State] = {
	Phase.Chase: Ghost.State.Chase,
	Phase.Scatter: Ghost.State.Scatter,
}


func get_ghost_speed() -> float:
	var current_level := GameManager.get_current_level()
	
	match current_level:
		1:
			return 95
		2, 3, 4:
			return 100
		_:
			return 105


func get_ghost_cruise_elroy_speed() -> float:
	return get_ghost_speed() + 10


func get_player_speed() -> float:
	var current_level := GameManager.get_current_level()
	
	match current_level:
		1:
			return 100
		2, 3, 4:
			return 105
		_:
			return 110


func get_player_cruise_elroy_speed() -> float:
	return get_player_speed() + 10
