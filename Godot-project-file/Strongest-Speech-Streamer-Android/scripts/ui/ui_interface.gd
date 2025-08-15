extends Control

@onready var bag: Control = $bag
@onready var grabbed_slot: Control = $grabbed_slot
#@onready var chest_ui: Control = $chest_ui
#@onready var hotbar_ui: Control = $hotbar_ui
#@onready var hotbar: Node2D = $"../../hotbar"
@onready var equipment_ui: Control = $bag/equipment_ui
@onready var equipment: Node2D = $"../../equipment"
@onready var player: Node2D = $"../../Player"
@onready var bag_ui: CanvasLayer = $".."




signal link_bag_close

#var chest_inventory
var hotbar_inventory
var grabbed_slot_data: SlotData # 用于临时储存标点击后的物品信息
var equipment_slot_index
var temporary_grabbed # 用于临时储存抓取物

func _ready() -> void:
	bag.set_inventory_data(player.inventory_data)
	#hotbar_ui.set_inventory_data(hotbar.inventory_data)
	equipment_ui.set_inventory_data(equipment.inventory_data)
	#hotbar.inventory_data.inventory_interact.connect(on_inventory_interact)
	#hotbar.inventory_data.shift_inventory_interact.connect(on_shift_inventory_interact)
	equipment.inventory_data.inventory_interact.connect(on_inventory_interact)
	player.inventory_data.inventory_interact.connect(on_inventory_interact)
	global.bag_data_update.connect(update_bag_data)
	global.equip_data_update.connect(update_equip_data)
	#player.inventory_data.shift_inventory_interact.connect(on_shift_inventory_interact)
	
	
	#for node in get_tree().get_nodes_in_group("chest_inventory"):
		#node.toggle_inventory.connect(set_chest_inventory)
		
	#for node in get_tree().get_nodes_in_group("chest_inventory"):
		#node.exited_chest.connect(clear_external_inventory)
	
	global.esc_close.connect(_esc_close)
	#connect("link_bag_close", Callable(self, "set_chest_inventory"))
	#chest_ui.chest_close.connect(_esc_close)
	bag.bag_close.connect(_esc_close)
	
func update_equip_data():
	equipment = get_node("/root/main_page/equipment")
	equipment_ui.set_inventory_data(equipment.inventory_data)
	equipment.inventory_data.inventory_interact.connect(on_inventory_interact)

func update_bag_data():
	player = get_node("/root/main_page/Player")
	#bag.clear_inventory_data(player.inventory_data)
	bag.set_inventory_data(player.inventory_data)
	if player.inventory_data.inventory_interact.is_connected(on_inventory_interact): # 若之前有连接则先断开
		player.inventory_data.inventory_interact.disconnect(on_inventory_interact)
	player.inventory_data.inventory_interact.connect(on_inventory_interact)

func _esc_close():
	bag.hide()
	bag_ui.hide()
	
			
#func set_chest_inventory(_chest_inventory):
	#bag.visible = !bag.visible
	#if _chest_inventory:
		#if !chest_ui.visible:
			#set_external_inventory(_chest_inventory)
			#bag.show()
		#else:
			#call_deferred("clear_external_inventory")
			#bag.hide()
			

#func set_external_inventory(_chest_inventory): # 建立库存连接
	#chest_inventory = _chest_inventory
	#var inventory_data = chest_inventory.inventory_data
	#inventory_data.inventory_interact.connect(on_inventory_interact)
	#inventory_data.shift_inventory_interact.connect(on_shift_inventory_interact)
	#chest_ui.set_inventory_data(inventory_data)
	#chest_ui.show()

#func clear_external_inventory(): # 断开库存连接
	#if chest_inventory:
		#var inventory_data = chest_inventory.inventory_data
		#inventory_data.inventory_interact.disconnect(on_inventory_interact)
		#inventory_data.shift_inventory_interact.disconnect(on_shift_inventory_interact)
		#chest_ui.clear_inventory_data(inventory_data)
		#chest_ui.hide()
		#bag.hide()
		
		#chest_inventory = null

		
func _process(_delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position()
	
	if grabbed_slot_data != null:
		if grabbed_slot_data.item_data.group_name != "equipment":
			global.equipment_selecting = false
	else:
		global.equipment_selecting = false

#func on_shift_inventory_interact(inventory_data: InventoryData, index: int, button: int):
	#if chest_ui.visible:
		#match [inventory_data, button]:
			#[player.inventory_data, MOUSE_BUTTON_LEFT]:
				#var slot_data = player.inventory_data.slot_datas[index]
				#if slot_data:
					#slot_data = chest_inventory.inventory_data.pick_up_slot_data(slot_data)
					#player.inventory_data.slot_data_update(slot_data, index)
				
			#[chest_inventory.inventory_data, MOUSE_BUTTON_LEFT]:
				#var slot_data = chest_inventory.inventory_data.slot_datas[index]
				#if slot_data:
					#slot_data = player.inventory_data.pick_up_slot_data(slot_data)
					#chest_inventory.inventory_data.slot_data_update(slot_data, index)
	#else:
		#if bag.visible:
			#match [inventory_data, button]:
				#[player.inventory_data, MOUSE_BUTTON_LEFT]:
					#var slot_data = player.inventory_data.slot_datas[index]
					#if slot_data:
						#slot_data = hotbar.inventory_data.pick_up_slot_data(slot_data)
						#player.inventory_data.slot_data_update(slot_data, index)
					
				#[hotbar.inventory_data, MOUSE_BUTTON_LEFT]:
					#var slot_data = hotbar.inventory_data.slot_datas[index]
					#if slot_data:
					#	slot_data = player.inventory_data.pick_up_slot_data(slot_data)
					#	hotbar.inventory_data.slot_data_update(slot_data, index)
					
	
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int):
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
			global.current_grabbed_slot_data = grabbed_slot_data
			equipment_slot_index = index
		[_, MOUSE_BUTTON_LEFT]:	
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_RIGHT]: # 右键与角色互动,在hotbar中已完成
			pass
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)	
			
			
	grabbed_slot_update()
func grabbed_slot_update():
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()


func _on_bag_visibility_changed() -> void:
	if temporary_grabbed != null: # 防止背包满时关闭背包鼠标上还会有物品，关闭背包临时储存鼠标上的物品，打开背包时又把物品返回给鼠标
		grabbed_slot_data = temporary_grabbed
		temporary_grabbed = null
	
	if global.equipment_selecting:
		if !bag.visible and grabbed_slot_data:
			grabbed_slot_data = player.inventory_data.pick_up_equipment_slot_data(grabbed_slot_data, equipment_slot_index)
			global.current_grabbed_slot_data = null
			if grabbed_slot_data:
				grabbed_slot_data = equipment.inventory_data.pick_up_equipment_slot_data(grabbed_slot_data, equipment_slot_index)
				global.current_grabbed_slot_data = null
	else:
		if !bag.visible and grabbed_slot_data:
			grabbed_slot_data = player.inventory_data.pick_up_slot_data(grabbed_slot_data)
			global.current_grabbed_slot_data = null
			if grabbed_slot_data: # 箱子没打开时
				global.current_grabbed_slot_data = grabbed_slot_data
				temporary_grabbed = grabbed_slot_data
				grabbed_slot_data = null
		
		if !bag.visible and grabbed_slot_data:
			grabbed_slot_data = player.inventory_data.pick_up_slot_data(grabbed_slot_data)
			global.current_grabbed_slot_data = null
			#if grabbed_slot_data:
				#grabbed_slot_data = chest_inventory.inventory_data.pick_up_slot_data(grabbed_slot_data)
				#global.current_grabbed_slot_data = null
			
	
			
	grabbed_slot_update()
