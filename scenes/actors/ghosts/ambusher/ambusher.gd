extends Ghost


const CHASE_AHEAD_CELLS := 2


func _update_pathing() -> void:
	_target_cell = _maze.position_to_cell(_player.get_position_ahead(CHASE_AHEAD_CELLS))
	_move_points = _maze.get_move_points(_current_cell, _target_cell)
	nav_preview_line.points = _move_points
