extends Control

@onready var item_grid: GridContainer = $PanelContainer/VBoxContainer/MarginContainer/item_grid
@onready var bag: Control = $"."
@onready var player_name: Label = $PanelContainer2/player_name
@onready var history: Label = $history
@onready var history_container: PanelContainer = $PanelContainer4



const Slot = preload("res://scenes/ui/slot.tscn")
signal bag_close
func _ready() -> void:
	history_container.hide()
	player_name.text = global.player_name

func set_inventory_data(inventory_data: InventoryData):
	if inventory_data.inventory_update.is_connected(populate_inventory_data): # 如果之前已经存在连接则断开重新接
		clear_inventory_data(inventory_data)
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
	bag_close.emit()

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("open_bag"):
		#bag.visible = !bag.visible


func _on_history_mouse_entered() -> void: # 历史记录鼠标进入
	history.add_theme_color_override("font_color", Color(1, 1, 1))

func _on_history_mouse_exited() -> void: # 历史记录鼠标离开
	history.add_theme_color_override("font_color", Color('99603f'))


func _on_history_close_pressed() -> void: # 关闭历史记录
	history_container.hide()


func _on_history_gui_input(event: InputEvent) -> void: # 历史记录按钮
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			history_container.show()
