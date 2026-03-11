extends GhostState


@onready var timer: Timer = $UpdateTimer


func enter(_data := {}) -> void:
	timer.start()
	_update_nav_to_player()


func exit() -> void:
	timer.stop()


func physics_update(_delta: float) -> void:
	ghost.navigate()


func _update_nav_to_player() -> void:
	# Update current cell, reset pointer to restart pathing
	var current_cell = NavigationManager.position_to_cell(ghost.position)
	ghost.move_pointer = 0
	
	# Update target cell, update move points
	var target_cell := NavigationManager.position_to_cell(ghost.player.get_four_steps_ahead())
	var move_points := NavigationManager.get_move_points(current_cell, target_cell)
	
	if move_points.size() <= 8:
		finished.emit(SCATTER)
	
	ghost.move_points = NavigationManager.get_move_points(current_cell, target_cell)
	ghost.nav_preview_line.points = ghost.move_points


func _on_timer_timeout() -> void:
	_update_nav_to_player()
