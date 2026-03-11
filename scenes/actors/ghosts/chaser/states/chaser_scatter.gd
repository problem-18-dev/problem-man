extends GhostState


const SCATTER_CORNER := Vector2(26, 1)


func enter(_data := {}) -> void:
	ghost.move_pointer = 0
	ghost.move_points = []
	_find_nav_to_corner()


func physics_update(_delta: float) -> void:
	ghost.navigate()


func _find_nav_to_corner() -> void:
	var current_cell := NavigationManager.position_to_cell(ghost.position)
	var corner_cell := SCATTER_CORNER
	var move_points := NavigationManager.get_move_points(current_cell, corner_cell)
	ghost.move_points = move_points
	ghost.nav_preview_line.points = move_points
