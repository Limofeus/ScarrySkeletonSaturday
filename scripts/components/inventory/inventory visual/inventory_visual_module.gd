extends Node
class_name InventoryVisualModule

var selection_container : SelectionItemContainer = null

func set_creature_inventory(creature_selection_container : SelectionItemContainer) -> void:
	selection_container = creature_selection_container