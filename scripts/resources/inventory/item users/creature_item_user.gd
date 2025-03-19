extends SpatialItemUser
class_name CreatureItemUser

var character_body : CharacterBody3D = null
var head_node : Node3D = null #Creature's head node

func _init(spatial_node : Node3D = null, set_character_body : CharacterBody3D = null, set_head_node : Node3D = null):
	super._init(spatial_node)
	character_body = set_character_body
	head_node = set_head_node