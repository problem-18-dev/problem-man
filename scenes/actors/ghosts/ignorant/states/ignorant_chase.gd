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
	var current_cell = NavigationManager.position_to_cell(ghost.position)
	var target_cell := NavigationManager.position_to_cell(ghost.player.position)
	var move_points := NavigationManager.get_move_points(current_cell, target_cell)
	
	# If within 8 tiles, go to corner
	#if move_points.size() <= 8:
		#finished.emit(SCATTER)
		#return
	
	ghost.set_pathing(move_points)


func _on_update_timer_timeout() -> void:
	_update_nav_to_player()
