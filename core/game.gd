extends Node


@export_group("Game Properties")
@export var frightened_duration := 7.0

@onready var hud: CanvasLayer = $HUD
@onready var ghosts_manager: GhostsManager = $GhostsManager
@onready var phase_manager: PhaseManager = $PhaseManager
@onready var player: Player = $Player
@onready var frightened_timer: Timer = $FrightenedTimer


func _ready() -> void:
	frightened_timer.wait_time = frightened_duration


func _on_base_maze_score_added(score: int) -> void:
	var new_score := GameManager.add_score(score)
	hud.change_score(new_score)


func _on_base_maze_level_ended() -> void:
	get_tree().reload_current_scene()


func _on_base_maze_powerup_eaten() -> void:
	if GameManager.frightened_mode:
		frightened_timer.start()
		ghosts_manager.enter_frightened()
		return
	
	phase_manager.pause()
	GameManager.enable_frightened_mode()
	ghosts_manager.enter_frightened()
	frightened_timer.start()


func _on_phase_manager_phase_changed(phase: GameConfig.Phase) -> void:
	hud.change_state_label(GameConfig.PHASES[phase])
	ghosts_manager.attempt_state(GameConfig.PHASE_TO_GHOST_STATE_MAP[phase])


func _on_frightened_timer_timeout() -> void:
	phase_manager.resume()
	GameManager.disable_frightened_mode()
	ghosts_manager.exit_frightened()
