extends Node3D
class_name VisualMineTrigger

static var all_visual_triggers : Array[Node3D] = []

func _ready() -> void:
	print("Added visual mine trigger: " + str(name) + " of " + str(get_parent().name))
	all_visual_triggers.append(self)

func _exit_tree() -> void:
	print("Removed visual mine trigger: " + str(name) + " of " + str(get_parent().name))
	all_visual_triggers.erase(self)