extends GhostState


@onready var corner_cell: Vector2 = Game.ghost_corners[Game.Corner.BottomLeft]
@onready var update_timer: Timer = $UpdateTimer


func enter(_data := {}) -> void:
	update_timer.start()
	_find_nav_to_corner()


func exit() -> void:
	ghost.reset_pathing()
	update_timer.stop()


func physics_update(_delta: float) -> void:
	ghost.navigate()


func _find_nav_to_corner() -> void:
	var current_cell := NavigationManager.position_to_cell(ghost.position)
	var move_points := NavigationManager.get_move_points(current_cell, corner_cell)
	ghost.set_pathing(move_points)


func _check_distance_to_player() -> void:
	var current_cell := NavigationManager.position_to_cell(ghost.position)
	var player_cell := NavigationManager.position_to_cell(ghost.player.position)
	var move_points := NavigationManager.get_move_points(current_cell, player_cell)
	
	# If more than 8 tiles away, chase player
	#if move_points.size() > 8:
		#finished.emit(CHASE)


func _on_update_timer_timeout() -> void:
	_check_distance_to_player()
