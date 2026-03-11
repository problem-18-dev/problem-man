class_name GhostState
extends State


const CHASE = "Chase"
const SCATTER = "Scatter"
const FRIGHTENED = "Frightened"
const EATEN = "Eaten"

var ghost: Ghost


func _ready() -> void:
	await owner.ready
	ghost = owner
	assert(ghost, "Ghost states should only be used within a Ghost scene.")
