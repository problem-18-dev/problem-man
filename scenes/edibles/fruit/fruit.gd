extends Pellet


@onready var duration := randf_range(9, 10)
@onready var life_timer: Timer = $LifeTimer
@onready var score_label: Label = $ScoreLabel
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	_change_sprite()
	life_timer.start(duration)


func eat() -> void:
	eaten.emit(value)
	sprite.modulate = Color.TRANSPARENT
	collision_shape_2d.set_deferred("disabled", true)
	score_label.start(value, true)


func _on_life_timer_timeout() -> void:
	queue_free()


func _change_sprite() -> void:
	var level_resource := GameConfig.get_current_level_resource()
	sprite_2d.texture = level_resource.fruit_sprite
