extends GhostState


func enter(_data := {}) -> void:
	ghost.current_speed = 0


func exit() -> void:
	ghost.current_speed = ghost.speed
