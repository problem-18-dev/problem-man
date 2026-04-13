extends Control


@onready var color_rect: ColorRect = $ColorRect


func _ready() -> void:
	_change_color()


func _change_color() -> void:
	var level_resource := GameConfig.get_current_level_resource()
	color_rect.color = level_resource.maze_background_color
