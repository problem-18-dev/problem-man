extends GhostState


const JAIL_CELL := Vector2(14, 11)


func enter(_data := {}) -> void:
	ghost.move_pointer = 0
	ghost.go_to_jail(JAIL_CELL)


func physics_update(_delta: float) -> void:
	ghost.navigate()
