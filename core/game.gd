extends Node


@export_group("Game Properties")
@export var frightened_duration := 7.0
@export var game_over_duration := 3.5

@onready var hud: CanvasLayer = $HUD
@onready var ghosts_manager: GhostsManager = $GhostsManager
@onready var phase_manager: PhaseManager = $PhaseManager
@onready var player: Player = $Player
@onready var frightened_timer: Timer = $Timers/FrightenedTimer


func _ready() -> void:
	frightened_timer.wait_time = frightened_duration


func _on_base_maze_score_added(score: int) -> void:
	var new_score := GameManager.add_score(score)
	hud.change_score(new_score)


func _on_base_maze_level_ended() -> void:
	GameManager.next_level()
	get_tree().call_deferred("reload_current_scene")


func _on_base_maze_powerup_eaten() -> void:
	if GameManager.frightened_mode:
		frightened_timer.start()
		ghosts_manager.enter_frightened()
		return
	
	phase_manager.pause()
	GameManager.enable_frightened_mode()
	ghosts_manager.enter_frightened()
	frightened_timer.start()


func _on_base_maze_cruise_elroy_triggered() -> void:
	ghosts_manager.cruise_elroy()
	player.cruise_elroy()


func _on_phase_manager_phase_changed(phase: GameConfig.Phase) -> void:
	GameManager.change_phase(phase)
	ghosts_manager.attempt_state(GameConfig.PHASE_TO_GHOST_STATE_MAP[phase])


func _on_frightened_timer_timeout() -> void:
	phase_manager.resume()
	GameManager.disable_frightened_mode()
	ghosts_manager.exit_frightened()


func _on_player_hit() -> void:
	ghosts_manager.stop_ghosts()
	phase_manager.pause()


func _on_player_died() -> void:
	var lives_left := GameManager.take_life()
	
	if lives_left > 0:
		get_tree().call_deferred("reload_current_scene")
		return
	
	await hud.show_message("Game Over", game_over_duration)
	GameManager.reset()
	get_tree().call_deferred("reload_current_scene")


func _on_game_timer_timeout() -> void:
	ghosts_manager.start_ghosts()
	player.start()
	phase_manager.start()
