extends Control


var _prev_level: LevelResource
var _curr_level: LevelResource

@onready var travel_label: Label = $TravelLabel
@onready var traveling_player: Node2D = $TravelingPlayer


func _ready() -> void:
	_setup_sprite()
	_setup_label()


func swap_sprite() -> void:
	traveling_player.change_sprite_frames(_curr_level.player_sprite_frames)
	traveling_player.play()


func go_to_next() -> void:
	GameManager.main.load_scene(Main.Scene.Game)


func _setup_sprite() -> void:
	_prev_level = GameManager.get_previous_level_resource()
	_curr_level = GameManager.get_current_level_resource()
	traveling_player.change_sprite_frames(_prev_level.player_sprite_frames)
	traveling_player.play()



func _setup_label() -> void:
	travel_label.text += "%s..." % _curr_level.name
