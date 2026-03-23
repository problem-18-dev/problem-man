extends GhostState


@export_group("Jail")
@export var jail_cell_position: Ghost.JailCell


func enter(_data := {}) -> void:
	ghost.sprite.modulate = Color(0.173, 0.173, 0.173, 1.0)
	ghost.current_speed *= 2
	ghost.is_busy = true
	
	var jail_cell: Vector2 = Ghost.JAIL[jail_cell_position]
	ghost.go_to_jail(jail_cell)


func exit() -> void:
	ghost.sprite.modulate = Color.WHITE
	ghost.current_speed = ghost.speed
	ghost.is_busy = false
	
	ghost.reset_pathing()


func physics_update(_delta: float) -> void:
	ghost.navigate()
