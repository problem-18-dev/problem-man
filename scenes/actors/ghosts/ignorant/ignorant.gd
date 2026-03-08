extends Ghost


func _update_pathing() -> void:
	super()
	
	
	if _move_points.size() > 8:
		return
	
	var corner_cell := corners[ScatterCorner.BOTTOM_LEFT]
	_move_points = _maze.get_move_points(_current_cell, corner_cell)
	nav_preview_line.points = _move_points
