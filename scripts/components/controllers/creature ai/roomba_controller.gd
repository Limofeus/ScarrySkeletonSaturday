extends EntityComponent

@export var roomba_line_time_min_max : Vector2 = Vector2(0.5, 1.5)

@export var movement_input_interface : MovementInputInterface = null
@export var rotation_input_interface : RotationInputInterface = null
@export var roomba_timer : Timer = null

var roomba_rotating : bool = false

func _process(delta):
	if rotation_input_interface.rotation_vector.angle_to(rotation_input_interface.desired_rotation_direction) < 0.1 and roomba_rotating:
		roomba_rotating = false
		roomba_timer.start(randf_range(roomba_line_time_min_max.x, roomba_line_time_min_max.y))
	movement_input_interface.movement_vector = Vector2.ZERO  if roomba_rotating else MovementInputInterface.M_FORWARD

func on_timer_timeout():
	if roomba_rotating:
		return
	random_rotation()
	roomba_rotating = true

func release_jump():
	movement_input_interface.jump_pressed = false

func random_rotation():
	var random_direction = Vector3.FORWARD.rotated(Vector3.UP, randf_range(0, PI * 2))
	#var random_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
	rotation_input_interface.desired_rotation_direction = random_direction

	movement_input_interface.jump_pressed = true
	release_jump.call_deferred()
