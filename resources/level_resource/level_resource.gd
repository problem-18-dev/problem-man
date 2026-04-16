class_name LevelResource
extends Resource


@export_group("Level")
@export var name: String
@export_subgroup("HUD")
@export var life_texture: Texture2D
@export var text_color := Color.WHITE

@export_group("Player")
@export var player_sprite_frames: SpriteFrames
@export var player_allow_rotation := false

@export_group("Ghosts")
@export_subgroup("Common")
@export var ghost_allow_flip := false
@export var ghost_allow_rotation := false
@export var ghost_scale := 1.25
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

@export_group("Maze")
@export var maze_texture: Texture2D
@export var maze_background_color: Color
