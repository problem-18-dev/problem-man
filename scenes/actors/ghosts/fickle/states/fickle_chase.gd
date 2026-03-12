extends GhostState


@onready var update_timer: Timer = $UpdateTimer


func enter(_data := {}) -> void:
	update_timer.start()
	_nav_to_player()


func exit() -> void:
	ghost.reset_pathing()
	update_timer.stop()


func physics_update(_delta: float) -> void:
	ghost.navigate()


func _nav_to_player() -> void:
	var current_cell := NavigationManager.position_to_cell(ghost.position)
	
	# Get player two steps ahead
	var player_two_ahead := ghost.player.get_two_steps_ahead()
	var player_two_ahead_cell := NavigationManager.position_to_cell(player_two_ahead)
	
	# Calculate target through chaser
	var chaser_position := ghost.manager.get_ghost_position(Game.Ghosts.Chaser)
	var chaser_position_cell := NavigationManager.position_to_cell(chaser_position)
	var chaser_to_player_two_ahead := player_two_ahead_cell - chaser_position_cell
	var target_cell := chaser_position_cell + (chaser_to_player_two_ahead * 2)
	
	var move_points := NavigationManager.get_move_points(current_cell, target_cell)
	ghost.set_pathing(move_points)


func _on_update_timer_timeout() -> void:
	_nav_to_player()
