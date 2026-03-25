class_name Chaser
extends Ghost


func enter_cruise_elroy() -> void:
	var cruise_elroy_speed := GameConfig.get_ghost_cruise_elroy_speed()
	speed = cruise_elroy_speed
	
	# Immediately adjust speed if in appropriate state
	if is_in_state(Ghost.State.Scatter) or is_in_state(Ghost.State.Chase):
		current_speed = cruise_elroy_speed
	
	print("Chaser cruise elroy speed:", speed)
