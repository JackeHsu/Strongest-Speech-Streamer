extends Node2D

@export var inventory_data: InventoryData

@onready var slots: Array = inventory_data.slot_datas

func _ready() -> void:
	check_slots() # 保证初始穿上装备
	if inventory_data:
		# 连接信号
		inventory_data.inventory_update.connect(_on_inventory_update)#连接库存更新信号，以便库存发生变化可以再调用check_slots
		#global.equip_data_update.connect(check_slots)
func _on_inventory_update(_inventory_data: InventoryData) -> void: # 正确显示图像
	# 处理更新并调用 check_slots
	check_slots()


func check_slots():
	var found_hat = false
	var found_clothes = false
	var found_pants = false
	var found_shoes = false
	var found_key = false
	
	for slot in slots:
		if slot != null and slot.item_data != null:
			match slot.item_data.equipment_type:
				1:
					global.head_index = slot.item_data.equipment_value # 传递帽子参数
					found_hat = true
				2:
					global.clothes_index = slot.item_data.equipment_value # 传递衣服参数
					found_clothes = true
				3:
					global.pants_index = slot.item_data.equipment_value # 传递裤子参数
					found_pants = true
				4:
					global.shoes_index = slot.item_data.equipment_value # 传递鞋子参数
					found_shoes = true
				5:
					global.key_index = slot.item_data.equipment_value # 传递钥匙参数
					found_key = true

	# 如果没有找到任何装备，则重置参数
	if not found_hat:
		global.head_index = 0  # 传递默认值
	if not found_clothes:
		global.clothes_index = 0  # 传递默认值
	if not found_pants:
		global.pants_index = 0  # 传递默认值
	if not found_shoes:
		global.shoes_index = 0  # 传递默认值
	if not found_key:
		global.key_index = 0 # 传递默认值
	
	global.clothes_change.emit()
