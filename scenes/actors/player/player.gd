class_name Player
extends BaseActor


const CELL_SIZE := 16

@export_category("Stats")
@export var speed := 125.0

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


func _physics_process(delta: float) -> void:
	if not _maze:
		return
	
	_process_movement(delta)


func _unhandled_key_input(event: InputEvent) -> void:
	for direction_key in _available_directions.keys():
		if event.is_action_pressed(direction_key):
			var next_direction: Vector2 = _available_directions[direction_key]
			_change_next_direction(next_direction)


func get_position_ahead(cell_amount: int) -> Vector2:
	return position + (_direction * CELL_SIZE * cell_amount)



func _process_movement(delta: float) -> void:
	var current_cell_center := _maze.get_cell_center(position)
	var distance_to_center := position.distance_to(current_cell_center)
	var distance_limit := speed / 100
	
	if distance_to_center < distance_limit:
		position = current_cell_center
		
		var is_direction_cell_wall := _maze.is_cell_wall(position + _direction * CELL_SIZE)
		var is_next_direction_cell_wall := _maze.is_cell_wall(position + _next_direction * CELL_SIZE)
		
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
