extends GhostState


@onready var timer: Timer = $UpdateTimer


func enter(_data := {}) -> void:
	timer.start()
	_update_nav_to_player()


func exit() -> void:
	ghost.reset_pathing()
	timer.stop()


func physics_update(_delta: float) -> void:
	ghost.navigate()


func _update_nav_to_player() -> void:
	# Update current cell, reset pointer to restart pathing
	var current_cell = NavigationManager.position_to_cell(ghost.position)
	
	# Update target cell, update move points
	var target_cell := NavigationManager.position_to_cell(ghost.player.get_four_steps_ahead())
	var move_points := NavigationManager.get_move_points(current_cell, target_cell)
	ghost.set_pathing(move_points)


func _on_update_timer_timeout() -> void:
	_update_nav_to_player()
