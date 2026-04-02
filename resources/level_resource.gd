class_name LevelResource
extends Resource

@export_group("Player")
@export var player_sprite_frames: SpriteFrames

@export_group("Ghosts")
@export_subgroup("Chaser")
@export var chaser_sprite: Texture2D

@export_subgroup("Ambusher")
@export var ambusher_sprite: Texture2D

@export_subgroup("Ignorant")
@export var ignorant_sprite: Texture2D

@export_subgroup("Fickle")
@export var fickle_sprite: Texture2D

@export_group("Pellets")
@export var pellet_sprite: Texture2D

@export_group("Fruit")
@export var fruit_sprite: Texture2D

@export_group("PowerUps")
@export var power_up_sprite: Texture2D
