extends CanvasLayer


@onready var state_label: Label = $StateLabel
@onready var score_label: Label = $ScoreLabel


func change_score(score: int) -> void:
	score_label.text = "%06d" % score


func change_state_label(text: String) -> void:
	state_label.text = text
