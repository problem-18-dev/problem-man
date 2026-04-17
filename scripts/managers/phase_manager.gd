class_name PhaseManager
extends Node


signal phase_changed(phase: GameConfig.Phase)

const EASY: Array[float] = [7, 20, 7, 20, 5, 20, 5, 0]
const MEDIUM: Array[float] = [7, 20, 7, 20, 5, 300, 2, 0]
const HARD: Array[float] = [7, 20, 7, 20, 5, 500, 1.5, 0]

var _current_timings

@onready var phase_timer: Timer = $PhaseTimer


func _ready() -> void:
	_current_timings = _get_phase_timer(GameManager.get_current_level())
	GameManager.reset_phase()


func start() -> void:
	_start_timer()


func pause() -> void:
	phase_timer.paused = true


func resume() -> void:
	phase_timer.paused = false


func reset() -> void:
	phase_timer.stop()
	phase_timer.paused = false
	_current_timings = _get_phase_timer(GameManager.get_current_level())
	GameManager.reset_phase()


func _get_phase_timer(level: int) -> Array[float]:
	match level:
		1:
			return EASY.duplicate()
		2, 3, 4:
			return MEDIUM.duplicate()
		_:
			return HARD.duplicate()


func _start_timer() -> void:
	var time = _current_timings.pop_front()
	if time == 0:
		return
	
	phase_timer.start(time)


func _next_phase() -> void:
	GameManager.toggle_phase()
	phase_changed.emit(GameManager.get_current_phase())
	_start_timer()


func _on_phase_timer_timeout() -> void:
	_next_phase()
