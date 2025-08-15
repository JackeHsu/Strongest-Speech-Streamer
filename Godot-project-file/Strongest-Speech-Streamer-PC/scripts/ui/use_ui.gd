extends Node2D

@onready var button: Button = $VBoxContainer/Button
@onready var button_2: Button = $VBoxContainer/Button2
@onready var button_3: Button = $VBoxContainer/Button3
@onready var delete_num: Label = $VBoxContainer/Button2/VBoxContainer/delete_num # 丢弃物品数量
@onready var v_box_container: VBoxContainer = $VBoxContainer/Button2/VBoxContainer # 丢弃物品确认界面
@onready var num_slider: HSlider = $VBoxContainer/Button2/VBoxContainer/NumSlider



signal use_item

var index: int # 格子索引
var tem_slot_data
var num: int  = 1# 删除数量

func _process(_delta: float) -> void:
	if tem_slot_data.item_data.group_name == "equipment":
		button.hide()
		button_3.show()
	else:
		button.show()
		button_3.hide()

func set_index(slot_index):
	index = slot_index

func set_data(use_slot_data):
	tem_slot_data = use_slot_data

#and !(button.is_pressed or button.pressed)
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if button.is_hovered() or button_2.is_hovered() or button_3.is_hovered() or v_box_container.visible:# 点击按钮时过会儿才删除菜单
			pass
		else:
			self.queue_free()
			global.use_ui_is_visible = false
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
			self.queue_free()
			global.use_ui_is_visible = false



func _on_button_pressed() -> void:
	global.use_item.emit(index)
	self.queue_free()
	global.use_ui_is_visible = false
	#print("使用物品")
	global.var_change.emit()
	
func _on_button_2_pressed() -> void:
	#print("丢弃物品")
	v_box_container.show()
	num_slider.max_value = tem_slot_data.quantity
	delete_num.text = str(num_slider.value)
	

func _on_button_3_pressed() -> void:
	#print("装备物品")
	global.use_equip.emit(index, tem_slot_data.item_data.equipment_type)
	self.queue_free()
	global.use_ui_is_visible = false


func _on_confirm_pressed() -> void:
	global.delete_item.emit(index, num)
	self.queue_free()
	global.use_ui_is_visible = false


func _on_cancel_pressed() -> void:
	v_box_container.hide()


func _on_num_slider_drag_ended(_value_changed: bool) -> void:
	delete_num.text = str(num_slider.value)
	num = num_slider.value
