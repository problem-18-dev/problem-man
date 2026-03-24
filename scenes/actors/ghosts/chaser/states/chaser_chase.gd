extends GhostState


@onready var update_timer: Timer = $UpdateTimer


func enter(_data := {}) -> void:
	update_timer.start()
	_update_nav_to_player()


func exit() -> void:
	update_timer.stop()
	ghost.reset_pathing()


func physics_update(_delta: float) -> void:
	ghost.navigate()


func _update_nav_to_player() -> void:
	if not ghost.player:
		update_timer.stop()
		return
	
	var current_cell := NavigationManager.position_to_cell(ghost.position)
	var target_cell := NavigationManager.position_to_cell(ghost.player.position)
	var move_points := NavigationManager.get_move_points(current_cell, target_cell)
	ghost.set_pathing(move_points)


func _on_update_timer_timeout() -> void:
	_update_nav_to_player()
