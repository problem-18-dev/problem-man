extends Node


enum SFX {
	Hover,
	Press,
}

var _sound_effects := {
	SFX.Hover: "res://ui/theme/sounds/gui_hover.ogg",
	SFX.Press: "res://ui/theme/sounds/gui_press.ogg",
}


func play(sfx_name: SFX, pitch_scale := randf_range(0.8, 1.2)) -> void:
	var player := AudioStreamPlayer.new()
	player.finished.connect(_on_player_finished.bind(player))
	player.bus = "Master"
	player.pitch_scale = pitch_scale
	player.stream = load(_sound_effects[sfx_name])
	player.autoplay = true
	add_child(player)
	

func _on_player_finished(player: AudioStreamPlayer) -> void:
	player.queue_free()
