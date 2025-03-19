extends State
class_name PlayerMovementState

@export var player_attributes : PlayerAttributes

@export var speed_mult : float = 1.0
@export var max_accel : float = 10.0
@export var max_angle_correct : float = 2.0
@export var speed_loss : float = 1.0

@export var gravity_mult : float = 1.0
@export var vertical_velocity_adjust_factor : float = 0.0

func get_input_vector() -> Vector2:
	return Input.get_vector("move_forward", "move_backward", "move_left", "move_right")

func get_desired_world_vector(input_vector : Vector2) -> Vector3:
	return (player_attributes.head_node.transform.basis.z * input_vector.x) + (player_attributes.head_node.transform.basis.x * input_vector.y)

func get_desired_vertical_vector(input_vector : Vector2) -> Vector3:
	return ((player_attributes.look_node.global_basis.z * input_vector.x) + (player_attributes.head_node.transform.basis.x * input_vector.y)).normalized()
#Both use actual speed
func calculate_planar_movement_vector(delta : float, input_vector : Vector2, current_planar_velocity : Vector3) -> Vector3:
	var desired_world_vector : Vector3 = get_desired_world_vector(input_vector)
	
	var relative_velocity : Vector3 = current_planar_velocity / (speed_mult * player_attributes.player_speed)
	
	var desired_speed_save_velocity : Vector3 = desired_world_vector * max(relative_velocity.length(), 1.0) #either this or replace curr velocity by speed cap constant

	var angle_diff = relative_velocity.signed_angle_to(desired_world_vector, Vector3.UP)
	
	var rotated_towards_desired = relative_velocity.rotated(Vector3.UP, clamp(angle_diff, -max_angle_correct * delta, max_angle_correct * delta))
	
	#rotated velocity speed loss
	rotated_towards_desired = StaticUtility.lerp_dampen(rotated_towards_desired, Vector3.ZERO, speed_loss, delta)
	
	var move_toward_desired : Vector3 = relative_velocity.move_toward(desired_world_vector, max_accel * delta)

	DebugDraw3D.draw_line(player_attributes.player_body.global_position, player_attributes.player_body.global_position + desired_world_vector, Color.RED)
	DebugDraw3D.draw_line(player_attributes.player_body.global_position, player_attributes.player_body.global_position + relative_velocity, Color.YELLOW)
	DebugDraw3D.draw_line(player_attributes.player_body.global_position, player_attributes.player_body.global_position + rotated_towards_desired, Color.BLUE)

	if desired_speed_save_velocity.distance_to(rotated_towards_desired) < desired_speed_save_velocity.distance_to(move_toward_desired):
		return rotated_towards_desired * (speed_mult * player_attributes.player_speed)
	else:
		return move_toward_desired * (speed_mult * player_attributes.player_speed)

func calculate_vertical_movement_vector(delta : float, input_vector : Vector2, current_vertical_velocity : float) -> Vector3:
	var desired_vertical_vector : Vector3 = get_desired_vertical_vector(input_vector)

	#DebugDraw3D.scoped_config().set_thickness(0)
	#DebugDraw3D.draw_arrow(look_node.global_position, look_node.global_position + desired_vertical_vector, Color.ORANGE)
	#DebugDraw3D.scoped_config().set_thickness(0.01)

	var vertical_velocity_vector : Vector3 = Vector3(0.0, current_vertical_velocity, 0.0)

	if desired_vertical_vector.length() > 0.0 and vertical_velocity_adjust_factor > 0.0: #theoreticaly there's no need to check for 0.0, but just in case
		var vertical_velocity_adjust_value : float = clamp(vertical_velocity_vector.dot(desired_vertical_vector) + 1.0, 0.0, 1.0) * vertical_velocity_adjust_factor * delta
		#vertical_velocity_vector = StaticUtility.lerp_dampen(vertical_velocity_vector, desired_vertical_vector + (Vector3.DOWN * gravity), vertical_velocity_adjust_value, delta)
		if(abs(current_vertical_velocity) >= vertical_velocity_adjust_value):
			vertical_velocity_vector = vertical_velocity_vector.normalized() * (abs(current_vertical_velocity) - vertical_velocity_adjust_value)
			vertical_velocity_vector += desired_vertical_vector * vertical_velocity_adjust_value
		else:
			vertical_velocity_vector = desired_vertical_vector * abs(current_vertical_velocity)

	vertical_velocity_vector += (Vector3.DOWN * player_attributes.gravity_power * gravity_mult * delta)
	return vertical_velocity_vector

func _on_physics_update(delta) -> void:
	var input_vector : Vector2 = get_input_vector()
	var current_relative_velocity : Vector3 = player_attributes.player_body.velocity
	var planar_velocity : Vector3 = Vector3(current_relative_velocity.x, 0.0, current_relative_velocity.z)
	var vertical_velocity : float = current_relative_velocity.y

	var new_planar_velocity : Vector3 = calculate_planar_movement_vector(delta, input_vector, planar_velocity)
	var new_vertical_velocity : Vector3 = calculate_vertical_movement_vector(delta, input_vector, vertical_velocity)

	var new_velocity : Vector3 = new_planar_velocity + new_vertical_velocity

	player_attributes.player_body.velocity = new_velocity
	player_attributes.player_body.move_and_slide()

	DebugDraw3D.draw_line(player_attributes.player_body.global_position + (Vector3.UP * 0.2), player_attributes.player_body.global_position + (Vector3.UP * 0.2) + (player_attributes.player_body.velocity / 30.0), Color.GREEN)

func check_conditions():
	return (player_attributes.player_body.is_on_floor() and (!Input.is_action_pressed("player_dash")) and player_attributes.player_body.velocity.y <= 0.0)
