extends Ghost


var chaser: Ghost


func _ready() -> void:
	super()
	await owner.ready
	chaser = owner.chaser


#func _update_pathing() -> void:
	## Get two positions from player
	#var player_ahead := player.get_two_steps_ahead()
	#var player_position := NavigationManager.position_to_cell(player_ahead)
	#
	## Get chaser position
	#var chaser_position := chaser.current_cell
	#
	## Calculate distance from chaser position to target position
	#var chaser_to_player_target := player_position - chaser_position 
	#
	## Target is * 2
	#var target_position := chaser_position + (chaser_to_player_target * 2)
	#target_position = target_position.clamp(Vector2.ZERO, Vector2(32, 32))
	#target_cell = target_position
	#move_points = maze.get_move_points(current_cell, target_cell)
	#nav_preview_line.points = move_points
