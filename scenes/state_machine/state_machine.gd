class_name StateMachine
extends Node


@export var initial_state: State

@onready var state := initial_state


func _ready() -> void:
	assert(initial_state, "No initial state given.")
	
	var children = find_children("*", "State") as Array[State]
	for state_node: State in children:
		state_node.finished.connect(transition_to_next_state)
	
	await owner.ready
	state.enter()


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


func transition_to_next_state(next_state: String, data := {}) -> void:
	assert(has_node(next_state), "Transitioning to state %s, but it doesn't exist" % next_state)
	
	state.exit()
	state = get_node(next_state)
	state.enter(data)
