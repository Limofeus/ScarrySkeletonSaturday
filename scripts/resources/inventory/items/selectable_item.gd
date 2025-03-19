extends InventoryItem
class_name SelectableItem

@export var select_string : String = "Select" #Equip, Wear, etc.

func _item_selected(item_container : SelectionItemContainer) -> void:
	pass

func _item_deselected(item_container : SelectionItemContainer) -> void:
	pass