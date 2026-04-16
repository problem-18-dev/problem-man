extends Node


@export_group("Game Properties")
@export var frightened_duration := 7.0
@export var game_over_duration := 3.5

@onready var hud: CanvasLayer = $HUD
@onready var ghosts_manager: GhostsManager = $GhostsManager
@onready var phase_manager: PhaseManager = $PhaseManager
@onready var player: Player = $Player
@onready var frightened_timer: Timer = $Timers/FrightenedTimer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var is_paused := get_tree().paused
		if is_paused:
			hud.unpause_game()
			get_tree().paused = false
			return
		
		hud.pause_game()
		get_tree().paused = true


func _on_base_maze_score_added(score: int) -> void:
	var new_score := GameManager.add_score(score)
	hud.change_score(new_score)


func _on_base_maze_level_ended() -> void:
	GameManager.next_level()


func _on_base_maze_powerup_eaten() -> void:
	if GameManager.frightened_mode:
		ghosts_manager.enter_frightened()
		frightened_timer.start()
		return
	
	phase_manager.pause()
	frightened_timer.start()
	GameManager.enable_frightened_mode()
	ghosts_manager.enter_frightened()


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
	
	if lives_left > 5:
		GameManager.main.load_scene(Main.Scene.Game)
		return
	
	await hud.show_message("GAME OVER", game_over_duration)
	GameManager.save_high_score()
	GameManager.reset()
	get_tree().call_deferred("reload_current_scene")


func _on_game_timer_timeout() -> void:
	ghosts_manager.start_ghosts()
	player.start()
	phase_manager.start()
