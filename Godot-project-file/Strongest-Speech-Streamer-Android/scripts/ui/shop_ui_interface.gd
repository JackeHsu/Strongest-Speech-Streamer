extends Control

@onready var shop: Control = $shop
@onready var shop_indoor: Node2D = $".."
@onready var shop_ui: Control = $"."
@onready var page: Label = $HBoxContainer/page
@onready var next: Button = $HBoxContainer/next
@onready var last: Button = $HBoxContainer/last


func _check_state(): # 根据建筑形态更新背包状态
	if global.shop_state == 0:
		shop.set_inventory_data(shop_indoor.inventory_data1)
		#shop_indoor.inventory_data1.inventory_interact.connect(on_inventory_interact)
		shop_indoor.slots = shop_indoor.inventory_data1.slot_datas
		last.disabled = true
		next.disabled = true
		page.text = "1/1"
	elif global.shop_state == 1:
		shop.set_inventory_data(shop_indoor.inventory_data2)
		#if shop_indoor.inventory_data1.inventory_interact.is_connected(on_inventory_interact):
			#shop_indoor.inventory_data1.inventory_interact.disconnect(on_inventory_interact)
		#if !shop_indoor.inventory_data2.inventory_interact.is_connected(on_inventory_interact):
			#shop_indoor.inventory_data2.inventory_interact.connect(on_inventory_interact)
		shop_indoor.slots = shop_indoor.inventory_data2.slot_datas
		last.disabled = true
		next.disabled = true
		page.text = "1/1"
	elif global.shop_state == 2 and global.shop_inventory_state == 0:
		shop.set_inventory_data(shop_indoor.inventory_data3)
		#if shop_indoor.inventory_data2.inventory_interact.is_connected(on_inventory_interact):
			#shop_indoor.inventory_data2.inventory_interact.disconnect(on_inventory_interact)
		#if !shop_indoor.inventory_data3.inventory_interact.is_connected(on_inventory_interact):
		#	shop_indoor.inventory_data3.inventory_interact.connect(on_inventory_interact)
		shop_indoor.slots = shop_indoor.inventory_data3.slot_datas
		last.disabled = true
		next.disabled = false
		page.text = "1/4"
	elif global.shop_state == 2 and global.shop_inventory_state == 1: # 第二页
		shop.set_inventory_data(shop_indoor.inventory_data5)
		shop_indoor.slots = shop_indoor.inventory_data5.slot_datas
		page.text = "2/4"
		last.disabled = false
		next.disabled = false
	elif global.shop_state == 2 and global.shop_inventory_state == 2: # 第三页
		shop.set_inventory_data(shop_indoor.inventory_data4)
		shop_indoor.slots = shop_indoor.inventory_data4.slot_datas
		page.text = "3/4"
		last.disabled = false
		next.disabled = false
	elif global.shop_state == 2 and global.shop_inventory_state == 3: # 第四页
		shop.set_inventory_data(shop_indoor.inventory_data6)
		shop_indoor.slots = shop_indoor.inventory_data6.slot_datas
		page.text = "4/4"
		last.disabled = false
		next.disabled = true
func _ready() -> void:
	_check_state()
	shop_ui.hide()
	shop.shop_close.connect(shop_close)
	global.state_change.connect(_check_state)


func shop_close():
	shop_ui.hide()

func _on_last_pressed() -> void:
	if global.shop_state == 2 and global.shop_inventory_state != 0:
		global.shop_inventory_state -= 1
		global.state_change.emit()


func _on_next_pressed() -> void:
	if global.shop_state == 2 and global.shop_inventory_state != 3:
		global.shop_inventory_state += 1
		global.state_change.emit()
