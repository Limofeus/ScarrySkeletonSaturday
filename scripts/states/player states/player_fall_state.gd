extends PlayerMovementState
class_name FallState

func check_conditions():
	return !Input.is_action_pressed("player_jump")
