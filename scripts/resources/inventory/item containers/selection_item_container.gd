extends ItemContainer
class_name SelectionItemContainer

var selected_slot : int = 0

func _init(new_storage_capacity : int = 1, selected_slot_id : int = 0) -> void:
	super._init(new_storage_capacity)
	select_slot(selected_slot_id)

func select_slot(selected_slot_id : int) -> void:
	if items[selected_slot] is SelectableItem:
		items[selected_slot]._item_deselected(self)
	selected_slot = selected_slot_id
	if items[selected_slot] is SelectableItem:
		items[selected_slot]._item_selected(self)
	on_container_updated.emit() #This one line of code was the most genius idea of this whole project, now we just connect all visual stuff to container updates (including player holding items and stuff)

func offset_selected_slot(offset : int) -> void:
	select_slot((selected_slot + offset + storage_capacity) % storage_capacity)

func get_selected_item() -> InventoryItem:
	return items[selected_slot]