extends CanvasLayer


@onready var score_label: Label = $ScoreLabel
@onready var message_label: Label = $MessageLabel
@onready var game_start_timer: Timer = $GameStartTimer


func _process(_delta: float) -> void:
	if game_start_timer.is_stopped():
		return
	
	change_game_countdown(ceili(game_start_timer.time_left))


func change_score(score: int) -> void:
	score_label.text = "%06d" % score


func show_message(message: String, duration = null) -> void:
	message_label.text = message
	if duration:
		await get_tree().create_timer(duration).timeout
		message_label.text = ""


func change_game_countdown(seconds: int) -> void:
	var new_text: String
	
	match seconds:
		3:
			new_text = "THREE"
		2:
			new_text = "TWO"
		1:
			new_text = "ONE"
	
	message_label.text = new_text


func _on_game_start_timer_timeout() -> void:
	show_message("GO!", 3)
