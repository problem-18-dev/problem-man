extends Node


var current_score := 0
var current_level := 1
var current_phase := GameConfig.Phase.Scatter
var frightened_mode := false


func add_score(score: int) -> int:
	current_score += score
	return current_score


func next_level() -> void:
	current_level += 1


func get_current_level() -> int:
	return current_level


func change_phase(phase: GameConfig.Phase) -> GameConfig.Phase:
	current_phase = phase
	return get_current_phase()


func get_current_phase() -> GameConfig.Phase:
	return current_phase


func toggle_phase() -> void:
	if get_current_phase() == GameConfig.Phase.Scatter:
		change_phase(GameConfig.Phase.Chase)
	else:
		change_phase(GameConfig.Phase.Scatter)


func enable_frightened_mode() -> void:
	frightened_mode = true


func disable_frightened_mode() -> void:
	frightened_mode = false
