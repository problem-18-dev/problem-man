extends Node


@onready var hud: CanvasLayer = $HUD


func _on_base_maze_score_added(score: int) -> void:
	var new_score := GameManager.add_score(score)
	hud.change_score(new_score)
