extends Node

var ghosts := Ghosts.new()

class Ghosts:
	signal state_changed(state: String)
