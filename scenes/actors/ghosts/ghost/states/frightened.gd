extends GhostState


@export_group("Properties")
@export var frightened_speed := 50.0


func enter(_data := {}) -> void:
	ghost.current_speed = 50.0
	ghost.change_sprite(Ghost.State.Frightened)
	
	ghost.find_escape_path()


func exit() -> void:
	ghost.current_speed = ghost.speed
	ghost.reset_sprite()
	
	ghost.reset_pathing()


func physics_update(_delta: float) -> void:
	ghost.navigate()
