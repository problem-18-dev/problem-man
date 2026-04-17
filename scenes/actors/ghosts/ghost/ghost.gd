class_name Ghost
extends Area2D

signal arrived_in_jail
signal eaten(ghost: Ghost)
signal respawned(ghost: Ghost)

enum State { Chase, Scatter, Frightened, Eaten }
enum Corner { TopLeft, TopRight, BottomLeft, BottomRight }
enum JailCell { Left, Center, Right, Out }

const STATES := {
	State.Chase: "Chase",
	State.Scatter: "Scatter",
	State.Frightened: "Frightened",
	State.Eaten: "Eaten",
}

const CORNERS := {
	Corner.TopLeft: Vector2(1, 1),
	Corner.TopRight: Vector2(26, 1),
	Corner.BottomLeft: Vector2(1, 27),
	Corner.BottomRight: Vector2(26, 27),
}

const JAIL_COORDINATES := {
	JailCell.Left: Vector2(184, 216), 
	JailCell.Center: Vector2(224, 216),
	JailCell.Right: Vector2(264, 216),
	JailCell.Out: Vector2(224, 184),
}

const BASE_SCORE := 200

@export_group("Properties")
@export var speed := 75.0
@export var spawn_cell: JailCell

var target_reached := false
var current_speed := speed
var move_pointer := 0
var move_points: PackedVector2Array
var player: Player
var manager: GhostsManager

var _can_move := false
var _can_flip := false
var _can_rotate := false

@onready var nav_preview_line: Line2D = $NavPreviewLine
@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite
@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	_setup()
	_determine_speed()
	_position_to_spawn_cell()
	await owner.ready


func navigate() -> void:
	if not _can_move:
		return
	
	if move_points.size() <= 0:
		target_reached = true
		return
	
	if move_pointer == move_points.size() - 1:
		position = move_points[-1]
		target_reached = true
		return
	
	target_reached = false
	var next_position := move_points[move_pointer + 1]
	var direction := (next_position - position).normalized()
	_rotate_sprite(direction)
	position += direction * current_speed * get_physics_process_delta_time()
	
	if position.distance_to(next_position) < current_speed / 100:
		position = next_position
		move_pointer += 1


func reset() -> void:
	_can_move = false
	_position_to_spawn_cell()
	reset_pathing()
	reset_sprite()
	_determine_speed()
	state_machine.reset()


func die() -> void:
	eaten.emit(self)


func start() -> void:
	_can_move = true


func stop() -> void:
	_can_move = false


func change_sprite(state: Ghost.State) -> void:
	match state:
		State.Eaten:
			sprite.frame = 2
		State.Frightened:
			sprite.frame = 1
		_:
			sprite.frame = 0


func reset_sprite() -> void:
	sprite.frame = 0
	sprite.modulate = Color.WHITE


func find_escape_path() -> void:
	var current_cell := NavigationManager.position_to_cell(position)
	var escape_cell := NavigationManager.get_random_cell()
	var new_move_points := NavigationManager.get_move_points(current_cell, escape_cell)
	set_pathing(new_move_points)


func go_to_jail(jail_cell: Vector2) -> void:
	var current_cell := NavigationManager.position_to_cell(position)
	var new_move_points := NavigationManager.get_move_points(current_cell, jail_cell)
	set_pathing(new_move_points)


func set_pathing(new_move_points: PackedVector2Array) -> void:
	move_pointer = 0
	move_points = new_move_points
	nav_preview_line.points = new_move_points


func reset_pathing() -> void:
	current_speed = speed
	move_points = []
	move_pointer = 0
	target_reached = false


func change_state(state: Ghost.State, data := {}) -> void:
	state_machine.transition_to_next_state(Ghost.STATES[state], data)


func is_in_state(state: Ghost.State) -> bool:
	return state_machine.state.name == STATES[state]


func draw_nav_lines() -> void:
	nav_preview_line.show()
 

func _setup() -> void:
	var level_resource := GameManager.get_current_level_resource()
	_can_flip = level_resource.ghost_allow_flip
	_can_rotate = level_resource.ghost_allow_rotation
	sprite.apply_scale(Vector2.ONE * level_resource.ghost_scale)


func _determine_speed() -> void:
	speed = GameConfig.get_ghost_speed()


func _position_to_spawn_cell() -> void:
	var coordinates: Vector2 = JAIL_COORDINATES[spawn_cell]
	position = coordinates


func _rotate_sprite(direction: Vector2) -> void:
	if _can_flip:
		sprite.flip_h = direction == Vector2.RIGHT
		return
	
	if _can_rotate:
		sprite.rotation = direction.angle()
