class_name Ghost
extends CharacterBody2D


@export_category("Stats")
@export var speed := 100.0

var move_pointer := 0
var move_points: PackedVector2Array
var player: Player
var manager: GhostsManager

@onready var nav_preview_line: Line2D = $NavPreviewLine


func _init() -> void:
	EventBus.state_changed.connect(_on_state_changed)


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func navigate() -> void:
	if move_points.size() <= 0:
		return
	
	if move_pointer == move_points.size() - 1:
		position = move_points[-1]
		return
	
	var next_position := move_points[move_pointer + 1]
	var direction := (next_position - position).normalized()
	position += direction * speed * get_physics_process_delta_time()
	
	if position.distance_to(next_position) < speed / 100:
		position = next_position
		move_pointer += 1


func escape_from_player() -> void:
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
	move_points = []
	move_pointer = 0


func _on_state_changed(state: String) -> void:
	$StateMachine._transition_to_next_state(state)
