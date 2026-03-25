class_name Ghost
extends Area2D


signal eaten(ghost: Ghost)
signal respawned

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

@export_group("Properties")
@export var speed := 75.0
@export var spawn_cell: JailCell

var target_reached := false
var current_speed := speed
var move_pointer := 0
var move_points: PackedVector2Array
var player: Player
var manager: GhostsManager

@onready var nav_preview_line: Line2D = $NavPreviewLine
@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	_determine_speed()
	_position_to_spawn_cell()
	await owner.ready


func navigate() -> void:
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
	position += direction * current_speed * get_physics_process_delta_time()
	
	if position.distance_to(next_position) < current_speed / 100:
		position = next_position
		move_pointer += 1


func die() -> void:
	eaten.emit(self)


func stop() -> void:
	state_machine.set_physics_process(false)


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
 

func _determine_speed() -> void:
	speed = GameConfig.get_ghost_speed()
	print("Ghost normal speed:", speed)


func _position_to_spawn_cell() -> void:
	var coordinates: Vector2 = JAIL_COORDINATES[spawn_cell]
	position = coordinates
