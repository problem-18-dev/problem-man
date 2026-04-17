class_name PowerUp
extends Edible


signal power_up_eaten

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	_change_sprite()


func eat() -> void:
	power_up_eaten.emit()
	queue_free()


func _change_sprite() -> void:
	var level_resource := GameManager.get_current_level_resource()
	sprite_2d.texture = level_resource.power_up_sprite
