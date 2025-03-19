extends PlayerMovementState
class_name JumpState

@export var jump_power : float = 10.0

func _on_enter()->void:
	print("Jump proked")
	player_attributes.player_body.velocity += Vector3.UP * jump_power

func check_conditions():
	return Input.is_action_pressed("player_jump")
