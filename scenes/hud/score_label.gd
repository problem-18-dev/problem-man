extends Label


func _ready() -> void:
	await owner.ready


func start(score: int, kill_owner := false) -> void:
	text = str(score)
	global_position = owner.global_position
	position.x -= size.x / 2
	
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(self, "position", position + Vector2.UP * 10.0, 0.5)
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	tween.tween_interval(2.0)
	tween.chain().tween_property(self, "modulate", Color.TRANSPARENT, 1.5)
	if kill_owner:
		tween.chain().tween_callback(owner.queue_free)
