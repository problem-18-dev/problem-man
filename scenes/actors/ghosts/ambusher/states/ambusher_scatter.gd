extends GhostState


const SCATTER_CORNER := Vector2(1, 28)

@onready var update_timer: Timer = $UpdateTimer


func enter(_data := {}) -> void:
	update_timer.start()
	ghost.move_pointer = 0
	ghost.move_points = []
	_find_nav_to_corner()


func exit() -> void:
	update_timer.stop()


func physics_update(_delta: float) -> void:
	ghost.navigate()


func _find_nav_to_corner() -> void:
	var current_cell := NavigationManager.position_to_cell(ghost.position)
	var corner_cell := SCATTER_CORNER
	var move_points := NavigationManager.get_move_points(current_cell, corner_cell)
	ghost.move_points = move_points
	ghost.nav_preview_line.points = move_points


func _check_distance_to_player() -> void:
	var current_cell := NavigationManager.position_to_cell(ghost.position)
	var player_cell := NavigationManager.position_to_cell(ghost.player.get_position())
	var move_points := NavigationManager.get_move_points(current_cell, player_cell)
	
	if move_points.size() > 8:
		finished.emit(CHASE)


func _on_update_timer_timeout() -> void:
	_check_distance_to_player()
