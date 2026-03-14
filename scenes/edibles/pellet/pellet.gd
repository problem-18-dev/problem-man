class_name Pellet
extends Edible


signal eaten(value: int)

@export var value := 25


func eat() -> void:
	eaten.emit(value)
	queue_free()
