class_name Ghost
extends CharacterBody2D


@export_category("Stats")
@export var speed := 125.0

var move_pointer := 0
var move_points: PackedVector2Array
var player: Player

@onready var nav_preview_line: Line2D = $NavPreviewLine


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
	var player_cell := NavigationManager.position_to_cell(player.get_position())
	var escape_cell := (player_cell - current_cell) * -1
	var new_move_points := NavigationManager.get_move_points(current_cell, escape_cell)
	move_points = new_move_points
	nav_preview_line.points = new_move_points


func go_to_jail(jail_cell: Vector2) -> void:
	var current_cell := NavigationManager.position_to_cell(position)
	var new_move_points := NavigationManager.get_move_points(current_cell, jail_cell)
	move_points = new_move_points
	nav_preview_line.points = new_move_points


func _on_chase_pressed() -> void:
	$StateMachine._transition_to_next_state("Chase")
	$CanvasLayer/Label.text = "State: Chase"


func _on_scatter_pressed() -> void:
	$StateMachine._transition_to_next_state("Scatter")
	$CanvasLayer/Label.text = "State: Scatter"


func _on_frightened_pressed() -> void:
	$StateMachine._transition_to_next_state("Frightened")
	$CanvasLayer/Label.text = "State: Frightened"


func _on_eaten_pressed() -> void:
	$StateMachine._transition_to_next_state("Eaten")
	$CanvasLayer/Label.text = "State: Eaten"
