extends GhostState


@onready var jail_cell_position: Vector2 = MazeConfig.ghost_jail_positions[MazeConfig.JailCell.Left]


func enter(_data := {}) -> void:
	var jail_cell := NavigationManager.position_to_cell(jail_cell_position)
	ghost.go_to_jail(jail_cell)


func exit() -> void:
	ghost.reset_pathing()


func physics_update(_delta: float) -> void:
	ghost.navigate()
