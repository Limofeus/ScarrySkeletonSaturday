extends EntityComponent

@export var player_body : CharacterBody3D
@export var head_node : Node3D

@export var move_speed : float = 5.0
@export var jump_power : float = 10.0

@export var on_ground_accel : float = 50.0
@export var in_air_accel : float = 3.0
@export var gravity_power : float = 9.8

"""
func _physics_process(delta):
    var input_vector = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    player_body.velocity = head_node.transform.basis * Vector3(input_vector.x, -gravity, input_vector.y) * move_speed
    player_body.move_and_slide()
"""

func _physics_process(delta : float) -> void:
	var input_vector : Vector2 = Input.get_vector("move_forward", "move_backward", "move_left", "move_right") * move_speed
	var desired_velocity : Vector3 = (head_node.transform.basis.z * input_vector.x) + (head_node.transform.basis.x * input_vector.y) + (Vector3.UP * player_body.velocity.y)
	
	if player_body.is_on_floor():
		player_body.velocity = player_body.velocity.move_toward(desired_velocity, on_ground_accel * delta)
	else:
		player_body.velocity = player_body.velocity.move_toward(desired_velocity, in_air_accel * delta)
		#if Input.is_action_just_pressed("ui_accept"): #change later
			#player_body.velocity = -head.global_transform.basis.z * dashPower
	if player_body.is_on_floor() and Input.is_action_just_pressed("ui_up"):
		player_body.velocity += Vector3.UP * jump_power
	else:
		player_body.velocity += Vector3.DOWN * gravity_power * delta
	player_body.move_and_slide()