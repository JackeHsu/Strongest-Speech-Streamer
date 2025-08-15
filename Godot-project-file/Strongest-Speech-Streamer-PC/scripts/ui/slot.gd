extends Control

signal slot_clicked(index: int, button: int)
signal shift_slot_clicked(index: int, button: int)

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var select: TextureRect = $select
@onready var item_describe: Label = $VBoxContainer/describe
@onready var item_name: Label = $VBoxContainer/item_name
@onready var describe: VBoxContainer = $VBoxContainer
@onready var use_ui = preload("res://scenes/ui/use_ui.tscn")


var use_slot_data # 给使用界面传递参数

func set_slot_data(slot_data: SlotData):
	var item_data = slot_data.item_data
	use_slot_data = slot_data
	texture_rect.texture = item_data.item_texture
	
	if slot_data.quantity > 1:
		label.text = "x%s" % slot_data.quantity
		label.show()
	else:
		label.hide()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT) and !Input.is_key_pressed(KEY_SHIFT) and event.is_pressed(): 
		slot_clicked.emit(get_index(), event.button_index)
		global.equipment_selecting = false
		#print(get_index(), event.button_index) # 打印背包格子位置，检验背包是否被正确点击
	
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT) and Input.is_key_pressed(KEY_SHIFT) and event.is_pressed():
		shift_slot_clicked.emit(get_index(),event.button_index)
		global.equipment_selecting = false
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
		if use_slot_data != null: # 格子上有物品时才能打开菜单界面
			describe_hide()
			use_ui_show(use_slot_data)
		
func use_ui_show(use_slot_data):
	var Operate = use_ui.instantiate()
	get_node("/root/main_page/Bag").add_child(Operate)
	Operate.global_position = get_global_mouse_position()
	Operate.call("set_data", use_slot_data)
	Operate.call("set_index", get_index())
	global.use_ui_is_visible = true


func describe_show():
	if use_slot_data != null:
		item_describe.text = use_slot_data.item_data.description
		item_name.text = "名称：" + use_slot_data.item_data.item_name
		describe.show()
	#else:
		#return
	
func describe_hide():
		describe.hide()


func _on_mouse_entered() -> void:
	select.show()
	if global.current_grabbed_slot_data == null and global.use_ui_is_visible == false:
		describe_show()
		
func _on_mouse_exited() -> void:
	select.hide()
	describe_hide()
