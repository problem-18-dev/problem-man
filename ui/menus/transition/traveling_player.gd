extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _process(delta: float) -> void:
	animated_sprite_2d.rotate(TAU * delta)


func play() -> void:
	animated_sprite_2d.play("move")


func change_sprite_frames(new_sprite_frames: SpriteFrames) -> void:
	animated_sprite_2d.sprite_frames = new_sprite_frames
