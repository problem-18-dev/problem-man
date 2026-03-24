extends GhostState


@export_group("Jail")
@export var jail_cell_position: Ghost.JailCell

var _respawn_timer := 0.0
var _respawning := false


func enter(data := {}) -> void:
	if data.size() > 0:
		_respawn_timer = data.respawn_timer
		
	ghost.sprite.modulate = Color(0.173, 0.173, 0.173, 1.0)
	ghost.current_speed *= 2
	
	var jail_coordinates: Vector2 = Ghost.JAIL_COORDINATES[jail_cell_position]
	ghost.go_to_jail(NavigationManager.position_to_cell(jail_coordinates))


func exit() -> void:
	ghost.sprite.modulate = Color.WHITE
	ghost.current_speed = ghost.speed
	_respawning = false
	_respawn_timer = 0.0
	
	ghost.reset_pathing()


func physics_update(_delta: float) -> void:
	if _respawning:
		return
	
	ghost.navigate()
	
	if ghost.target_reached:
		if is_zero_approx(_respawn_timer):
			_start()
			return
		
		_respawn()


func _respawn() -> void:
	_respawning = true
	print("Respawning in ", str(floor(_respawn_timer)))
	await get_tree().create_timer(_respawn_timer).timeout
	_start()


func _start() -> void:
	var game_phase := GameManager.get_current_phase()
	var new_state := GameConfig.PHASE_TO_GHOST_STATE_MAP[game_phase]
	finished.emit(ghost.STATES[new_state])
