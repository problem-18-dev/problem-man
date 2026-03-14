extends Node


var current_score := 0
var current_state := MazeConfig.States.Chase


func add_score(score: int) -> int:
	current_score += score
	return current_score


func change_state(state: MazeConfig.States) -> void:
	current_state = state
