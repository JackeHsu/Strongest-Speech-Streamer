extends Node2D

@export var inventory_data: InventoryData # 自动贩卖机库存

func _ready() -> void:
	global.buy_furniture.connect(buy_furniture_f)
	if global.home_inventory != null:
		inventory_data = global.home_inventory
func buy_furniture_f(selected_slot, num):
	if selected_slot != null:
		inventory_data.insert_item(selected_slot.item_data, num)
