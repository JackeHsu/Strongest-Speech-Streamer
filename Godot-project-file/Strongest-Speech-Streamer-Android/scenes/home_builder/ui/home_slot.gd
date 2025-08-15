extends Control

signal slot_clicked(index: int, button: int)
signal shift_slot_clicked(index: int, button: int)

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var select: TextureRect = $select


var layer
var type
var source_id
var interactive_type

func _ready() -> void:
	if is_connected("mouse_entered", _on_mouse_entered): # 防止存档系统重新连接信号
		disconnect("mouse_entered", _on_mouse_entered)
	connect("mouse_entered", _on_mouse_entered)

	if is_connected("gui_input", _on_gui_input):
		disconnect("gui_input", _on_gui_input)
	connect("gui_input", _on_gui_input)

	if is_connected("mouse_exited", _on_mouse_exited):
		disconnect("mouse_exited", _on_mouse_exited)
	connect("mouse_exited", _on_mouse_exited)

func set_slot_data(slot_data: SlotData):
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.item_texture

	if slot_data.quantity > 1:
		label.text = "x%s" % slot_data.quantity
		label.show()
	else:
		label.hide()
	
	if slot_data.item_data.layer == 2:
		layer = 2
	elif slot_data.item_data.layer == 1:
		layer = 1
	elif slot_data.item_data.layer == 0:
		layer = 0
	
	if slot_data.item_data.group_name == "wall":
		type = "wall"
		source_id = slot_data.item_data.source_id
	elif slot_data.item_data.group_name == "ground":
		type = "ground"
		source_id = slot_data.item_data.source_id
	elif slot_data.item_data.group_name == "furniture":
		type = "furniture"
	elif slot_data.item_data.group_name == "interactive":
		type = "interactive"
		interactive_type = slot_data.item_data.interactive_type
		
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_LEFT) and !Input.is_key_pressed(KEY_SHIFT) and event.is_pressed(): 
		slot_clicked.emit(get_index(), event.button_index)
		if layer == 2:
			if texture_rect.texture != null and type == "furniture":
				GameManager.item_selected_2.emit(texture_rect.texture)
				GameManager.hold_item = true
		elif layer == 1:
			if texture_rect.texture != null and layer == 1 and type == "furniture":
				GameManager.item_selected_1.emit(texture_rect.texture)
				GameManager.hold_item = true
			elif texture_rect.texture != null and layer == 1 and type == "interactive":
				GameManager.interactive_selected_1.emit(texture_rect.texture, interactive_type)
				GameManager.hold_item = true
		elif layer == 0:
			if texture_rect.texture != null and type == "furniture":
				GameManager.item_selected.emit(texture_rect.texture)
				GameManager.hold_item = true
			elif texture_rect.texture != null and type == "wall":
				GameManager.selected_wall.emit(texture_rect.texture, source_id)
				GameManager.hold_item = true
			elif texture_rect.texture != null and type == "ground":
				GameManager.selected_ground.emit(texture_rect.texture, source_id)
				GameManager.hold_item = true
			elif texture_rect.texture != null and type == "interactive":
				GameManager.interactive_selected.emit(texture_rect.texture, interactive_type)
				GameManager.hold_item = true


	elif event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_RIGHT) and !Input.is_key_pressed(KEY_SHIFT) and event.is_pressed(): 
		slot_clicked.emit(get_index(), event.button_index)
		if layer == 2:
			if texture_rect.texture != null and type == "furniture":
				GameManager.item_selected_2.emit(texture_rect.texture)
				GameManager.hold_item = true
		elif layer == 1:
			if texture_rect.texture != null and layer == 1 and type == "furniture":
				GameManager.item_selected_1.emit(texture_rect.texture)
				GameManager.hold_item = true
			elif texture_rect.texture != null and layer == 1 and type == "interactive":
				GameManager.interactive_selected_1.emit(texture_rect.texture, interactive_type)
				GameManager.hold_item = true
		elif layer == 0:
			if texture_rect.texture != null and type == "furniture":
				GameManager.item_selected.emit(texture_rect.texture)
				GameManager.hold_item = true
			elif texture_rect.texture != null and type == "wall":
				GameManager.selected_wall.emit(texture_rect.texture, source_id)
				GameManager.hold_item = true
			elif texture_rect.texture != null and type == "ground":
				GameManager.selected_ground.emit(texture_rect.texture, source_id)
				GameManager.hold_item = true
			elif texture_rect.texture != null and type == "interactive":
				GameManager.interactive_selected.emit(texture_rect.texture, interactive_type)
				GameManager.hold_item = true
		#print(get_index(), event.button_index) # 打印背包格子位置，检验背包是否被正确点击


func _on_mouse_entered() -> void:
	select.show()


func _on_mouse_exited() -> void:
	select.hide()
