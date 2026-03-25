class_name Player
extends Area2D


signal hit

const CELL_SIZE := 16

@export_category("Stats")
@export var speed := 80.0
@export_category("Maze")
@export var maze: Maze

var _can_move := false
var _screen_size := Vector2.ZERO
var _direction := Vector2.RIGHT
var _next_direction := _direction
var _available_directions := {
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN,
	"move_left": Vector2.LEFT,
	"move_right": Vector2.RIGHT,
}

@onready var player_sprite: Sprite2D = $Sprites/PlayerSprite
@onready var direction_sprite: Sprite2D = $Sprites/DirectionSprite
@onready var two_step_ahead_marker: Marker2D = $Sprites/PlayerSprite/TwoStepAheadMarker
@onready var four_step_ahead_marker: Marker2D = $Sprites/PlayerSprite/FourStepAheadMarker


func _ready() -> void:
	_screen_size = get_viewport_rect().size
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


func get_two_steps_ahead() -> Vector2:
	var position_ahead := two_step_ahead_marker.global_position
	return maze.get_tile_center(position_ahead)


func get_four_steps_ahead() -> Vector2:
	var position_ahead := four_step_ahead_marker.global_position
	return maze.get_tile_center(position_ahead)


func cruise_elroy() -> void:
	speed = GameConfig.get_player_cruise_elroy_speed()
	print("Player cruise elroy speed:", speed)


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
			player_sprite.rotation = _next_direction.angle()
		elif is_direction_cell_wall:
			_direction = Vector2.ZERO
	
	position += _direction * speed * delta


func _change_next_direction(new_direction: Vector2) -> void:
	_next_direction = new_direction
	
	var is_opposite := is_zero_approx((_direction + _next_direction).length())
	if is_opposite:
		_direction = new_direction
		player_sprite.rotation = new_direction.angle()
	
	direction_sprite.rotation = new_direction.angle()


func _wrap_position() -> void:
	position.x = wrapf(position.x, 0, _screen_size.x)


func _die() -> void:
	queue_free()


func _determine_speed() -> void:
	speed = GameConfig.get_player_speed()
	print("Player normal speed", speed)


func _on_area_entered(edible: Area2D) -> void:
	if edible is Edible:
		edible.eat()
	
	if edible is Ghost:
		if edible.is_in_state(Ghost.State.Frightened):
			edible.die()
		
		if not edible.is_in_state(Ghost.State.Eaten):
			hit.emit()
			_die()
