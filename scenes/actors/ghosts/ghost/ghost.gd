class_name Ghost
extends BaseActor


enum ScatterCorner { TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT }

@export_category("Stats")
@export var speed := 125.0

var corners: Dictionary[ScatterCorner, Vector2i] = {
	ScatterCorner.TOP_LEFT: Vector2(1, 1),
	ScatterCorner.TOP_RIGHT: Vector2(27, 1),
	ScatterCorner.BOTTOM_LEFT: Vector2(1, 27),
	ScatterCorner.BOTTOM_RIGHT: Vector2(27, 27)
}

var _move_pointer: int
var _current_cell: Vector2
var _target_cell: Vector2
var _move_points: PackedVector2Array
var _player: Player

@onready var nav_preview_line: Line2D = $NavPreviewLine


func _ready() -> void:
	super()
	_get_player()
	_start()


func _physics_process(delta: float) -> void:
	if _move_points.size() <= 0:
		return
	
	if _move_pointer == _move_points.size():
		return
	
	var next_position := _move_points[_move_pointer]
	var direction := (next_position - position).normalized()
	position += direction * speed * delta
	
	if position.distance_to(next_position) < 1:
		position = next_position
		_move_pointer += 1


func _start() -> void:
	_current_cell = _maze.position_to_cell(position)
	_target_cell = _maze.position_to_cell(_player.position)
	_move_points = _maze.get_move_points(_current_cell, _target_cell)
	nav_preview_line.points = _move_points


func _update_navigation() -> void:
	_update_own_position()
	_update_pathing()


func _update_own_position() -> void:
	_current_cell = _maze.position_to_cell(position)
	_move_pointer = 0


func _update_pathing() -> void:
	_target_cell = _maze.position_to_cell(_player.position)
	_move_points = _maze.get_move_points(_current_cell, _target_cell)
	nav_preview_line.points = _move_points


func _get_player() -> void:
	_player = get_tree().get_first_node_in_group("player")


func _on_timer_timeout() -> void:
	_update_navigation()
