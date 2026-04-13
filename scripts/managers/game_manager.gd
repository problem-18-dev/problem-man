extends Node


var main: Main

var current_level_type := GameConfig.LevelType.Classic
var current_score := 0
var current_level := 1
var current_lives := 5
var current_phase := GameConfig.Phase.Scatter
var frightened_mode := false
var cruise_elroy := false


func add_score(score: int) -> int:
	current_score += score
	return current_score


func next_level() -> void:
	current_level += 1


func get_current_level() -> int:
	return current_level


func take_life() -> int:
	current_lives -= 1
	return get_current_lives()


func get_current_lives() -> int:
	return current_lives


func reset() -> void:
	current_score = 0
	current_level = 1
	current_lives = 5
	current_phase = GameConfig.Phase.Scatter
	frightened_mode = false
	cruise_elroy = false


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
