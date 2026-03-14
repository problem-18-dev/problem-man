extends CanvasLayer


@onready var state_label: Label = $StateLabel
@onready var score_label: Label = $ScoreLabel


func change_score(score: int) -> void:
	score_label.text = "%06d" % score


func _change_state_label(text: String) -> void:
	state_label.text = text

func _on_chase_pressed() -> void:
	EventBus.state_changed.emit("Chase")
	_change_state_label("Chase")


func _on_scatter_pressed() -> void:
	EventBus.state_changed.emit("Scatter")
	_change_state_label("Scatter")


func _on_frightened_pressed() -> void:
	EventBus.state_changed.emit("Frightened")
	_change_state_label("Frightened")


func _on_eaten_pressed() -> void:
	EventBus.state_changed.emit("Eaten") 
	_change_state_label("Eaten")
