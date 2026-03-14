extends Pellet


@onready var duration := randf_range(9, 10)
@onready var life_timer: Timer = $LifeTimer


func _ready() -> void:
	life_timer.start(duration)


func _on_life_timer_timeout() -> void:
	queue_free()
