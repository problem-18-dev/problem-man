extends Control

@export_group("Title")
@export var hover_shadow_color := Color(1.0, 1.0, 0.0, 1.0)

@onready var background_timer: Timer = $BackgroundTimer
@onready var title_label: Label = $TitleLabel
@onready var high_score_label: Label = $HighScoreLabel
@onready var ghost: Sprite2D = $Maze/Ghost


func _ready() -> void:
	var high_score := GameManager.get_high_score()
	if high_score > 0:
		high_score_label.text = "HIGH SCORE: " + str(high_score)
	randomize_ghost_sprite()


func randomize_ghost_sprite() -> void:
	var level_type: GameConfig.LevelType = GameConfig.LEVEL_RESOURCES.keys().pick_random()
	var ghost_sprite := GameConfig.LEVEL_RESOURCES[level_type].chaser_sprite
	ghost.texture = ghost_sprite


func _on_title_label_mouse_entered() -> void:
	title_label.add_theme_color_override("font_shadow_color", hover_shadow_color)


func _on_title_label_mouse_exited() -> void:
	title_label.remove_theme_color_override("font_shadow_color")


func _on_problem_18_button_pressed() -> void:
	OS.shell_open("https://problem-18-dev.github.io")


func _on_itch_io_button_pressed() -> void:
	OS.shell_open("https://problem-18.itch.io")


func _on_story_button_pressed() -> void:
	GameManager.start_story()


func _on_classic_button_pressed() -> void:
	GameManager.start_classic()
