class_name Player
extends Area2D


signal died
signal hit

const CELL_SIZE := 16

@export_category("Stats")
@export var speed := 80.0
@export_category("Maze")
@export var maze: Maze

var _pellet_sound: AudioStream
var _fruit_sound: AudioStream
var _power_up_sound: AudioStream
var _ghost_eat_sound: AudioStream
var _death_sound: AudioStream

var _can_move := false
var _screen_size := Vector2.ZERO
var _allow_rotation := false
var _direction := Vector2.RIGHT
var _next_direction := _direction
var _available_directions := {
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN,
	"move_left": Vector2.LEFT,
	"move_right": Vector2.RIGHT,
}

@onready var player_sprite: AnimatedSprite2D = $Sprites/PlayerSprite
@onready var direction_sprite: Sprite2D = $Sprites/DirectionSprite
@onready var two_step_ahead_marker: Marker2D = $Sprites/PlayerSprite/TwoStepAheadMarker
@onready var four_step_ahead_marker: Marker2D = $Sprites/PlayerSprite/FourStepAheadMarker
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	_screen_size = get_viewport_rect().size
	_setup()
	_determine_speed()


func _physics_process(delta: float) -> void:
	if not maze or not _can_move:
		return
	
	_process_movement(delta)
	_wrap_position()


func _unhandled_key_input(event: InputEvent) -> void:
	for direction_key in _available_directions.keys():
		if event.is_action_pressed(direction_key):
			var next_direction: Vector2 = _available_directions[direction_key]
			_change_next_direction(next_direction)


func start() -> void:
	_can_move = true
	player_sprite.play("move")


func get_two_steps_ahead() -> Vector2:
	var position_ahead := two_step_ahead_marker.global_position
	return maze.get_tile_center(position_ahead)


func get_four_steps_ahead() -> Vector2:
	var position_ahead := four_step_ahead_marker.global_position
	return maze.get_tile_center(position_ahead)


func cruise_elroy() -> void:
	speed = GameConfig.get_player_cruise_elroy_speed()


func _setup() -> void:
	var level_resource := GameManager.get_current_level_resource()
	player_sprite.sprite_frames = level_resource.player_sprite_frames
	_allow_rotation = level_resource.player_allow_rotation
	
	_pellet_sound = level_resource.player_pellet_sound
	_fruit_sound = level_resource.player_fruit_sound
	_power_up_sound = level_resource.player_power_up_sound
	_ghost_eat_sound = level_resource.player_ghost_eat_sound
	_death_sound = level_resource.player_death_sound


func _process_movement(delta: float) -> void:
	var current_cell_center := maze.get_tile_center(position)
	var distance_to_center := position.distance_to(current_cell_center)
	var distance_limit := speed / 100
	
	if distance_to_center < distance_limit:
		position = current_cell_center
		
		var is_direction_cell_wall := maze.is_tile_wall(position + _direction * CELL_SIZE)
		var is_next_direction_cell_wall := maze.is_tile_wall(position + _next_direction * CELL_SIZE)
		
		if not is_next_direction_cell_wall:
			_direction = _next_direction
			_orient_sprite(_next_direction)
		elif is_direction_cell_wall:
			_direction = Vector2.ZERO
	
	position += _direction * speed * delta


func _change_next_direction(new_direction: Vector2) -> void:
	_next_direction = new_direction
	
	var is_opposite := is_zero_approx((_direction + _next_direction).length())
	if is_opposite:
		_direction = new_direction
		_orient_sprite(new_direction)
	
	direction_sprite.rotation = new_direction.angle()


func _wrap_position() -> void:
	position.x = wrapf(position.x, 0, _screen_size.x)


func _orient_sprite(new_direction: Vector2) -> void:
	if _allow_rotation:
		player_sprite.rotation = new_direction.angle()
		player_sprite.flip_v = new_direction == Vector2.DOWN or new_direction == Vector2.LEFT
		return
	
	player_sprite.flip_h = new_direction == Vector2.LEFT


func reset(start_position: Vector2) -> void:
	position = start_position
	_can_move = false
	_direction = Vector2.RIGHT
	_next_direction = _direction
	
	player_sprite.rotation = 0.0
	player_sprite.flip_h = false
	player_sprite.flip_v = false
	player_sprite.stop()
	player_sprite.frame = 0
	direction_sprite.rotation = 0.0
	
	audio_stream_player.stop()
	show()
	_determine_speed()


func _die() -> void:
	_can_move = false
	
	player_sprite.play("death")
	audio_stream_player.stream = _death_sound
	audio_stream_player.play()
	await player_sprite.animation_finished
	died.emit()


func _determine_speed() -> void:
	speed = GameConfig.get_player_speed()


func _play_audio(edible: Edible) -> void:
	if edible is PowerUp:
		audio_stream_player.stream = _power_up_sound
	elif edible is Fruit:
		audio_stream_player.stream = _fruit_sound
	else:
		# Only allow pellet sound if not already playing a different stream
		if not audio_stream_player.playing:
			audio_stream_player.stream = _pellet_sound
	
	if not audio_stream_player.playing:
		audio_stream_player.play()


func _on_area_entered(edible: Area2D) -> void:
	if edible is Edible:
		_play_audio(edible)
		edible.eat()
	
	if edible is Ghost:
		if edible.is_in_state(Ghost.State.Frightened):
			audio_stream_player.stream = _ghost_eat_sound
			audio_stream_player.play()
			edible.die()
			return
		
		if not edible.is_in_state(Ghost.State.Eaten):
			hit.emit()
			_die()
