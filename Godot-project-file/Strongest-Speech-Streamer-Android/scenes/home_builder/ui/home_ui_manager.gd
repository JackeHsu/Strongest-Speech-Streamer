extends Control

@onready var warehouse: Node2D = $"../../../warehouse"
@onready var home_ui: Control = $home_ui
@onready var grabbed_slot: Control = $grabbed_slot
@onready var ui: Control = $"."
@onready var delete_audio: AudioStreamPlayer = $"../../delete_audio"


enum State {
	IDLE,
	PLACE,
	DELETE,
}

var grabbed_slot_data: SlotData # 用于临时储存标点击后的物品信息
var temp_grab_data: SlotData # 先前的抓取数据

func _ready() -> void:
	# 放置下物品清空鼠标
	GameManager.pick_up_item_2.connect(pick_up)
	GameManager.item_placed.connect(clear_grabbed_slot)
	#GameManager.item_placed.connect(grabbed_slot_update)
	home_ui.set_inventory_data(warehouse.inventory_data)
	warehouse.inventory_data.inventory_interact.connect(on_inventory_interact)

func pick_up(slot_data: SlotData):
	grabbed_slot_data = slot_data
	temp_grab_data = slot_data
	grabbed_slot_update()
	
func _process(_delta: float) -> void:
	#print(grabbed_slot.label.visible)
	if grabbed_slot_data != null:
		grabbed_slot.global_position = get_global_mouse_position()
	if grabbed_slot_data != temp_grab_data:
		GameManager.item_delete.emit()
		temp_grab_data = null
	else:
		if !grabbed_slot.label.visible and GameManager.current_state == State.DELETE:
			grabbed_slot.visible = true
		elif !grabbed_slot.label.visible and GameManager.current_state == State.PLACE:
			grabbed_slot.visible = false


func clear_grabbed_slot(): # 放置物品后清理grab_slot
	if grabbed_slot_data.item_data.layer == 0:
		grabbed_slot_data.quantity -= 1
		if grabbed_slot_data.quantity > 0:
			if grabbed_slot_data.quantity != 0:
				GameManager.item_still_live.emit(grabbed_slot_data.item_data.item_texture)
				GameManager.hold_item = true
			grabbed_slot_update()
		else:
			grabbed_slot_data = null
			grabbed_slot_update()
	elif grabbed_slot_data.item_data.layer == 2:
		grabbed_slot_data.quantity -= 1
		if grabbed_slot_data.quantity > 0:
			if grabbed_slot_data.quantity != 0:
				GameManager.item_still_live_2.emit(grabbed_slot_data.item_data.item_texture)
				GameManager.hold_item = true
			grabbed_slot_update()
		else:
			grabbed_slot_data = null
			grabbed_slot_update()
	elif grabbed_slot_data.item_data.layer == 1:
		grabbed_slot_data.quantity -= 1
		if grabbed_slot_data.quantity > 0:
			if grabbed_slot_data.quantity != 0:
				GameManager.item_still_live_1.emit(grabbed_slot_data.item_data.item_texture)
				GameManager.hold_item = true
			grabbed_slot_update()
		else:
			grabbed_slot_data = null
			grabbed_slot_update()
	
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int):
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]: # 左键抓起单一物品
			grabbed_slot_data = inventory_data.grab_single_slot_data(index)
			temp_grab_data = grabbed_slot_data
			GameManager.pick_up_item.emit(temp_grab_data)
		[_, MOUSE_BUTTON_LEFT]:	
			grabbed_slot_data = inventory_data.drop_slot_data_home(grabbed_slot_data, index)
			if grabbed_slot_data != null:
				temp_grab_data = grabbed_slot_data
			GameManager.pick_up_item.emit(temp_grab_data)
			GameManager.item_delete.emit()
			
			#print(grabbed_slot_data)
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_RIGHT]: 
			grabbed_slot_data = inventory_data.grab_single_slot_data(index)
			temp_grab_data = grabbed_slot_data
			#grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_slot_data_home(grabbed_slot_data, index)
			if grabbed_slot_data != null:
				temp_grab_data = grabbed_slot_data
			GameManager.pick_up_item.emit(temp_grab_data)
			GameManager.item_delete.emit()
			
			
	grabbed_slot_update()
func grabbed_slot_update():
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.texture_rect.texture = null
		grabbed_slot.label.text = " "
		grabbed_slot.hide()


func _on_visibility_changed() -> void:
	if ui.visible and grabbed_slot_data:
		grabbed_slot_data = warehouse.inventory_data.pick_up_slot_data(grabbed_slot_data)
	

	grabbed_slot_update()


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if grabbed_slot_data != null:
			delete_audio.play()
			#print(grabbed_slot_data)
			GameManager.item_delete.emit()
			clear_grabbed_slot()
			
