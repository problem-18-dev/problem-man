extends Node


func _on_chase_pressed() -> void:
	EventBus.state_changed.emit("Chase")


func _on_scatter_pressed() -> void:
	EventBus.state_changed.emit("Scatter")


func _on_frightened_pressed() -> void:
	EventBus.state_changed.emit("Frightened")


func _on_eaten_pressed() -> void:
	EventBus.state_changed.emit("Eaten") 
