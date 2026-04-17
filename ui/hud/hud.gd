extends CanvasLayer


const GO_DURATION := 2.5

var _countdown := 4

@onready var score_label: Label = $ScoreLabel
@onready var message_label: Label = $MessageLabel
@onready var lives_container: HBoxContainer = $LivesContainer
@onready var countdown_timer: Timer = $CountdownTimer
@onready var overlay_rect: ColorRect = $OverlayRect


func _ready() -> void:
	change_lives(GameManager.get_current_lives())
	change_score(GameManager.get_current_score())
	var level_resource := GameManager.get_current_level_resource()
	_setup_labels(level_resource)
	_setup_lives(level_resource)


func change_score(score: int) -> void:
	score_label.text = "%06d" % score


func change_lives(lives: int) -> void:
	var lives_children := lives_container.get_children()
	for life in lives_container.get_child_count():
		lives_children[life].visible = life < lives


func show_message(message: String, duration = null) -> void:
	message_label.text = message
	if duration:
		await get_tree().create_timer(duration).timeout
		hide_message()


func hide_message() -> void:
	message_label.text = ""


func pause_game() -> void:
	overlay_rect.show()
	show_message("PAUSED")


func unpause_game() -> void:
	overlay_rect.hide()
	hide_message()


func change_game_countdown(seconds: int) -> void:
	var new_text: String
	
	match seconds:
		4:
			new_text = "FOUR"
		3:
			new_text = "THREE"
		2:
			new_text = "TWO"
		1:
			new_text = "ONE"
	
	message_label.text = new_text


func _setup_labels(level_resource: LevelResource) -> void:
	score_label.add_theme_color_override("font_color", level_resource.text_color)
	message_label.add_theme_color_override("font_color", level_resource.text_color)


func _setup_lives(level_resource: LevelResource) -> void:
	var lives := lives_container.get_children()
	for life: TextureRect in lives:
		life.texture = level_resource.life_texture


func _on_countdown_timer_timeout() -> void:
	_countdown -= 1
	
	if _countdown > 0:
		change_game_countdown(_countdown)
		return
	
	show_message("GO!", GO_DURATION)
	countdown_timer.stop()
