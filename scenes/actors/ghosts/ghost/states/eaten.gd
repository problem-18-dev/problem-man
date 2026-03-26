extends GhostState


@export_group("Properties")
@export var respawn_timer_fallback := 1.5
@export var eaten_speed := 100.0
@export var jail_cell_position: Ghost.JailCell

var _respawning := false
var _respawn_timer := respawn_timer_fallback
var _jail_coordinates: Vector2


func enter(data := {}) -> void:
	if data.size() > 0:
		assert(data.respawn_timer, "Respawn timer not provided even though object exists.")
		_respawn_timer = data.respawn_timer
		
	ghost.sprite.modulate = Color(0.173, 0.173, 0.173, 1.0)
	ghost.current_speed = eaten_speed
	
	_jail_coordinates = Ghost.JAIL_COORDINATES[jail_cell_position]
	ghost.go_to_jail(NavigationManager.position_to_cell(_jail_coordinates))


func exit() -> void:
	ghost.sprite.modulate = Color.WHITE
	ghost.current_speed = ghost.speed
	ghost.respawned.emit(ghost)
	_respawning = false
	_respawn_timer = respawn_timer_fallback
	ghost.reset_pathing()


func physics_update(_delta: float) -> void:
	if _respawning:
		return
	
	ghost.navigate()
	
	if ghost.target_reached:
		_respawn()


func _respawn() -> void:
	_respawning = true
	ghost.position = _jail_coordinates
	await get_tree().create_timer(_respawn_timer).timeout
	_start()


func _start() -> void:
	finished.emit("Scatter")
