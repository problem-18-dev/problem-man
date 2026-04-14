extends GhostState


const BLINK_AFTER := 5.0

@export_group("Properties")
@export var frightened_speed := 50.0

var _tween: Tween

@onready var blink_timer: Timer = $BlinkTimer


func enter(_data := {}) -> void:
	ghost.current_speed = 50.0
	ghost.change_sprite(Ghost.State.Frightened)
	ghost.find_escape_path()
	blink_timer.start(BLINK_AFTER)


func exit() -> void:
	ghost.current_speed = ghost.speed
	ghost.reset_sprite()
	ghost.reset_pathing()
	blink_timer.stop()
	if _tween:
		_tween.kill()


func physics_update(_delta: float) -> void:
	ghost.navigate()


func _on_blink_timer_timeout() -> void:
	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_SINE).set_loops(4)
	_tween.tween_property(ghost.sprite, "modulate", Color.TRANSPARENT, 0.25)
	_tween.tween_property(ghost.sprite, "modulate", Color.WHITE, 0.25)
