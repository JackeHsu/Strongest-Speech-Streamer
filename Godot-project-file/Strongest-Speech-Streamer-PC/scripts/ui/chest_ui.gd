extends Control

@onready var item_grid: GridContainer = $PanelContainer/VBoxContainer/MarginContainer/item_grid


const Slot = preload("res://scenes/ui/slot.tscn")
signal chest_close


func set_inventory_data(inventory_data: InventoryData):
	inventory_data.inventory_update.connect(populate_inventory_data)
	populate_inventory_data(inventory_data)

func clear_inventory_data(inventory_data: InventoryData):
	inventory_data.inventory_update.disconnect(populate_inventory_data)


func populate_inventory_data(inventory_data: InventoryData):
	for i in item_grid.get_children():
		i.queue_free()
		
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		slot.shift_slot_clicked.connect(inventory_data.on_shift_slot_clicked)
		
		if slot_data:
			slot.set_slot_data(slot_data)


func _on_texture_button_pressed() -> void:
	chest_close.emit()
	global.ui_show = false
