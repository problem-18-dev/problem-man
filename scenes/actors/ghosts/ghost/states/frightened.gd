extends GhostState


func enter(_data := {}) -> void:
	ghost.sprite.modulate = Color(0.453, 0.453, 0.453, 1.0)
	ghost.current_speed /= 2
	
	ghost.find_escape_path()


func exit() -> void:
	ghost.sprite.modulate = Color.WHITE
	ghost.current_speed = ghost.speed
	
	ghost.reset_pathing()


func physics_update(_delta: float) -> void:
	ghost.navigate()
