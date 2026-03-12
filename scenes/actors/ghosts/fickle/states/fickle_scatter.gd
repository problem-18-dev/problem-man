extends GhostState


@onready var corner_cell: Vector2 = Game.ghost_corners[Game.Corner.BottomRight]


func enter(_data := {}) -> void:
	_nav_to_corner()


func exit() -> void:
	ghost.reset_pathing()


func physics_update(_delta: float) -> void:
	ghost.navigate()


func _nav_to_corner() -> void:
	var current_cell := NavigationManager.position_to_cell(ghost.position)
	var move_points := NavigationManager.get_move_points(current_cell, corner_cell)
	ghost.set_pathing(move_points)
