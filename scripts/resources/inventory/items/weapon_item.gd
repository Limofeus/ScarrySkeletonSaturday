extends EntitySpawnerItem
class_name WeaponItem

static var combo_progress : int = 0 #NotImplementedYet™

func spawn_network_entity(_item_user : SpatialItemUser, item_use_node : Node3D) -> void:
	var additional_velocity_vector : Vector3 = Vector3.ZERO

	if _item_user is CreatureItemUser:
		additional_velocity_vector = _item_user.character_body.velocity #In global basis (theoretically)

	var pos_rot_spawn_argument : PosRotSpawnArgument = PosRotSpawnArgument.new(item_use_node.global_position + (-item_use_node.global_basis.z * position_offset), item_use_node.global_rotation)
	var projectile_spawn_argument : ProjectileSpawnArgument = ProjectileSpawnArgument.new(_item_user.team_id, Vector3.ZERO, additional_velocity_vector)

	return NetworkSpawner.spawner_singleton.spawn_network_entity(scene_to_instantiate, [pos_rot_spawn_argument, projectile_spawn_argument])