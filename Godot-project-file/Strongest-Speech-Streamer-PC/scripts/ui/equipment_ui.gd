extends Control

@onready var bag: Control = $".."
@onready var item_grid: GridContainer = $PanelContainer2/MarginContainer/item_grid


var grabbed_slot_data: SlotData # 用于临时储存标点击后的物品信息

const Slot = preload("res://scenes/ui/equipment_slot.tscn")


func set_inventory_data(inventory_data: InventoryData):
	inventory_data.inventory_update.connect(populate_inventory_data)
	populate_inventory_data(inventory_data)

func clear_inventory_data(inventory_data: InventoryData):
	inventory_data.inventory_update.disconnect(populate_inventory_data)

func populate_inventory_data(inventory_data: InventoryData):
	for i in item_grid.get_children():
		i.queue_free()
	
		# 获取 EQUIP_TYPE 枚举中的所有键
	var equip_type_keys = Equip_data.EQUIP_TYPE.keys()
	var i = 0
	
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		slot.equip_type = Equip_data.EQUIP_TYPE[equip_type_keys[i % equip_type_keys.size()]]
		i += 1
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if slot_data:
			slot.set_slot_data(slot_data)
		
		
