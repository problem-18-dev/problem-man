class_name Pellet
extends Edible


signal eaten(value: int)

@export var value := 25

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	_change_sprite()


func eat() -> void:
	eaten.emit(value)
	queue_free()


func _change_sprite() -> void:
	var level_resource := GameConfig.get_current_level_resource()
	sprite_2d.texture = level_resource.pellet_sprite
