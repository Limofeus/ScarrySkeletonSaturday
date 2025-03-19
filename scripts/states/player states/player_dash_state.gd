extends PlayerMovementState

@export var initial_dash_power : float = 20.0
@export var sustained_dash_power : float = 10.0
@export var velocity_preserve : float = 0.3
@export var dash_time : float = 0.2

var dash_start_time : float = 0.0

func _on_enter()->void:
	var desired_world_vector : Vector3 = get_desired_world_vector(get_input_vector())

	player_attributes.player_body.velocity = player_attributes.player_body.velocity * velocity_preserve

	player_attributes.player_body.velocity += desired_world_vector * initial_dash_power
	dash_start_time = Time.get_unix_time_from_system()

func _on_physics_update(delta : float)->void:
	super._on_physics_update(delta)
	var input_vector : Vector2 = Input.get_vector("move_forward", "move_backward", "move_left", "move_right")
	var desired_world_vector : Vector3 = (player_attributes.head_node.transform.basis.z * input_vector.x) + (player_attributes.head_node.transform.basis.x * input_vector.y)
	player_attributes.player_body.velocity += desired_world_vector * sustained_dash_power * delta

	DebugDraw2D.set_text("DashSpeed:", player_attributes.player_body.velocity.length())

func check_conditions():
	return Input.is_action_just_pressed("player_dash")

func state_locked():
	return dash_start_time + dash_time >= Time.get_unix_time_from_system()
