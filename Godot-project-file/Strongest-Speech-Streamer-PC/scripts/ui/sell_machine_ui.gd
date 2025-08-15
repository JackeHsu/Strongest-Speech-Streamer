extends Control


@onready var shop: Control = $sell_machine
@onready var shop_indoor: Node2D = $".."
@onready var shop_ui: Control = $"."
@onready var popup_location: Marker2D = $"../PopupLocation"


func _check_state(): # 根据建筑形态更新背包状态
	shop.set_inventory_data(shop_indoor.inventory_data)
	shop_indoor.slots = shop_indoor.inventory_data.slot_datas
func _ready() -> void:
	_check_state()
	shop_ui.hide()
	shop.shop_close.connect(shop_close)
	global.state_change.connect(_check_state)


func shop_close():
	shop_ui.hide()
	popup_location.show()
