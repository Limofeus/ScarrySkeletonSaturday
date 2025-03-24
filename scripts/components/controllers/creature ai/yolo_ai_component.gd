extends CreatureAIComponent

@export var ignore_distance : float = 20.0
@export var run_threshold_distance : float = 7.0
@export var attack_distance : float = 4.0

var current_target : Node3D = null

func cur_dist_to_target() -> float:
	if current_target == null:
		return 0.0
	return creature_attributes.spatial_node.global_position.distance_to(current_target.global_position)

func reassign_target() -> void:
	print("Searching for targets")
	var target_aray : Array[CreatureAttributes] = targeting_component.find_different_team_creatures(creature_attributes)
	if target_aray.size() > 0:
		print("Found a target or smh")
		current_target = target_aray[0].spatial_node

func attack_tick() -> void:
	if current_target != null:
		if cur_dist_to_target() < attack_distance:
			use_item.emit()

func _process(delta):
	if current_target != null:
		rotation_input_interface.desired_rotation_direction = (current_target.global_position - creature_attributes.spatial_node.global_position).normalized()
	movement_input_interface.dash_pressed = cur_dist_to_target() > run_threshold_distance
	movement_input_interface.movement_vector = MovementInputInterface.M_FORWARD if (cur_dist_to_target() > attack_distance and cur_dist_to_target() < ignore_distance) else Vector2.ZERO