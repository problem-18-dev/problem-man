extends CanvasLayer


const GO_DURATION := 3.5

var _countdown := 3

@onready var score_label: Label = $ScoreLabel
@onready var message_label: Label = $MessageLabel
@onready var lives_container: HBoxContainer = $LivesContainer
@onready var countdown_timer: Timer = $CountdownTimer


func _ready() -> void:
	change_lives(GameManager.get_current_lives())


func change_score(score: int) -> void:
	score_label.text = "%06d" % score


func change_lives(lives: int) -> void:
	var lives_children := lives_container.get_children()
	for life in lives_container.get_child_count():
		lives_children[life].visible = life < lives - 1
		


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


func _on_countdown_timer_timeout() -> void:
	_countdown -= 1
	
	if _countdown > 0:
		change_game_countdown(_countdown)
		return
	
	show_message("GO!", GO_DURATION)
	countdown_timer.stop()
