extends PlayerMovementState

func _on_enter()->void:
	print("Glide proked")

func check_conditions():
	return Input.is_action_pressed("player_dash") and player_attributes.player_body.is_on_floor()
