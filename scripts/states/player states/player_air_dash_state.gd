extends PlayerMovementState

@export var initial_dash_power : float = 20.0
@export var sustained_dash_power : float = 10.0
@export var velocity_preserve : float = 0.3
@export var vertical_dash_nerf : float = 0.2
@export var dash_time : float = 0.2

var dash_start_time : float = 0.0

func _on_enter()->void:
	var desired_vertical_vector = get_desired_vertical_vector(get_input_vector())

	var vertical_nerf_factor = lerp(vertical_dash_nerf, 1.0,clamp(Vector3.DOWN.dot(desired_vertical_vector.normalized()) + 1.0, 0.0, 1.0))

	player_attributes.player_body.velocity = player_attributes.player_body.velocity * velocity_preserve

	player_attributes.player_body.velocity += desired_vertical_vector * initial_dash_power * vertical_nerf_factor
	dash_start_time = Time.get_unix_time_from_system()

func _on_physics_update(delta : float)->void:
	super._on_physics_update(delta)
	var desired_vertical_vector = get_desired_vertical_vector(get_input_vector())
	var vertical_nerf_factor = lerp(vertical_dash_nerf, 1.0,clamp(Vector3.DOWN.dot(desired_vertical_vector.normalized()) + 1.0, 0.0, 1.0))

	player_attributes.player_body.velocity += desired_vertical_vector * sustained_dash_power * delta * vertical_nerf_factor

	DebugDraw2D.set_text("DashSpeed:", player_attributes.player_body.velocity.length())

func check_conditions():
	return Input.is_action_just_pressed("player_dash")

func state_locked():
	return dash_start_time + dash_time >= Time.get_unix_time_from_system()
