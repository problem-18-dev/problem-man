extends GhostState


@onready var corner_cell: Vector2 = Ghost.CORNERS[Ghost.Corner.BottomLeft]
@onready var update_timer: Timer = $UpdateTimer


func enter(_data := {}) -> void:
	update_timer.start()
	_find_nav_to_corner()


func exit() -> void:
	update_timer.stop()
	ghost.reset_pathing()


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
	var game_phase := GameManager.get_current_phase()
	if game_phase == GameConfig.Phase.Chase and move_points.size() > 8:
		finished.emit(CHASE)


func _on_update_timer_timeout() -> void:
	if not ghost.player:
		update_timer.stop()
		return
	
	_check_distance_to_player()
