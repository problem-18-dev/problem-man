extends Edible


signal power_up_eaten


func eat() -> void:
	power_up_eaten.emit()
	queue_free()
