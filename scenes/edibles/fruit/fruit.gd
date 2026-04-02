extends Pellet


@onready var duration := randf_range(9, 10)
@onready var life_timer: Timer = $LifeTimer


func _ready() -> void:
	_change_sprite()
	life_timer.start(duration)


func _on_life_timer_timeout() -> void:
	queue_free()


func _change_sprite() -> void:
	var level_resource := GameConfig.get_current_level_resource()
	sprite_2d.texture = level_resource.fruit_sprite
