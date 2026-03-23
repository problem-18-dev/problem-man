extends GhostState


func enter(_data := {}) -> void:
	ghost.sprite.modulate = Color(0.453, 0.453, 0.453, 1.0)
	ghost.current_speed /= 2
	ghost.is_busy = true
	
	ghost.find_escape_path()


func exit() -> void:
	ghost.sprite.modulate = Color.WHITE
	ghost.current_speed = ghost.speed
	ghost.is_busy = false
	
	ghost.reset_pathing()


func physics_update(_delta: float) -> void:
	ghost.navigate()
