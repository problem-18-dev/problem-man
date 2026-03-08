class_name StateMachine
extends Node


@export_category("Initial values")
@export var initial_state: State

var state: State = initial_state
var states: Dictionary[String, State]


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self


func change_state(new_state: String) -> void:
	var state_to_enter = states[new_state.to_lower()]
	assert(state_to_enter, "Transitioning to %s, but it doesn't exist" % new_state)
	
	state.exit()
	state = state_to_enter
	state.enter()
