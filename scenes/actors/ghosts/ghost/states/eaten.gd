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
		if data.score:
			_tween_score(data.score)
			
		if data.has("respawn_timer"):
			_respawn_timer = data.respawn_timer
	
	ghost.current_speed = eaten_speed
	ghost.change_sprite(Ghost.State.Eaten)
	
	_jail_coordinates = Ghost.JAIL_COORDINATES[jail_cell_position]
	ghost.go_to_jail(NavigationManager.position_to_cell(_jail_coordinates))


func exit() -> void:
	ghost.current_speed = ghost.speed
	ghost.respawned.emit(ghost)
	_respawning = false
	_respawn_timer = respawn_timer_fallback
	ghost.reset_pathing()
	ghost.reset_sprite()


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


func _tween_score(score: int) -> void:
	ghost.score_label.start(score)
