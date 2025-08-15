extends Control

@onready var item_grid: GridContainer = $PanelContainer/VBoxContainer/MarginContainer/item_grid


const Slot = preload("res://scenes/ui/shop_slot.tscn")
signal shop_close

@export var chests: Array[Node] = []  # 5个箱子节点

func set_inventory_data(inventory_data: InventoryData):
	if inventory_data.inventory_update.is_connected(populate_inventory_data): # 如果之前已经存在连接则断开重新接
		clear_inventory_data(inventory_data)
		#print("已连接")
	inventory_data.inventory_update.connect(populate_inventory_data)
	populate_inventory_data(inventory_data)
	
func clear_inventory_data(inventory_data: InventoryData):
	#print("以清除")
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
	shop_close.emit()
