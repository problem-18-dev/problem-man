class_name Ambusher
extends Ghost


func _ready() -> void:
	super()
	var level_resource := GameConfig.get_current_level_resource()
	sprite.texture = level_resource.ambusher_sprite
