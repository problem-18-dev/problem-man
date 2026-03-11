extends GhostState


func enter(_data := {}) -> void:
	ghost.move_pointer = 0
	ghost.escape_from_player()


func physics_update(_delta: float) -> void:
	ghost.navigate()
