extends Node2D

@export var inventory_data: InventoryData # 自动贩卖机库存
@onready var player: Player = $"../Player"


var slots: Array

@onready var npc: TileMapLayer = $npc
@onready var npc_2: TileMapLayer = $npc2
@onready var environment_0: TileMapLayer = $environment0
@onready var quit: Label = $quit
@onready var office_state_1: Node2D = $"."
@onready var road: StaticBody2D = $"../road"
@onready var office: StaticBody2D = $"../office"
@onready var shop: StaticBody2D = $"../shop"
@onready var shop_ui: Control = $shop_ui # 自动贩卖机
@onready var work_times: Sprite2D = $work_times
@onready var panel_container_4: PanelContainer = $PanelContainer4
@onready var book: Sprite2D = $book


var work_times_0 = preload("res://assets/tilesets/office/work_times2.png")
var work_times_1 = preload("res://assets/tilesets/office/work_times1.png")
var work_times_2 = preload("res://assets/tilesets/office/work_times.png")


var state = global.office_situation

func work_table_change():
	if global.player_nickname == "董事长":
		environment_0.set_cell(Vector2i(10, 15), -1)
		environment_0.set_cell(Vector2i(17, 7), 1, Vector2i(0, 0), 2)

func _ready() -> void:
	panel_container_4.hide()
	office_situation_update()
	if global.work_times == 0:
		work_times.texture = work_times_0
		global.time = "nighttime"
	elif global.work_times == 1:
		work_times.texture = work_times_1
	elif global.work_times == 2:
		work_times.texture = work_times_2
	global.work_table_change.connect(work_table_change)
	if global.office_interior_visible:
		office_state_1.show()
		office.hide()
		shop.hide()
		road.hide()

	if global.player_nickname == "董事长":
		#print(1)
		environment_0.set_cell(Vector2i(10, 15), -1)
		environment_0.set_cell(Vector2i(17, 7), 1, Vector2i(0, 0), 2)

		
func office_situation_update() -> void:
	if state == -2:
		# 生成
		npc_2.set_cell(Vector2i(23, 4), 0, Vector2i(52, 23)) # 1
		npc_2.set_cell(Vector2i(23, 5), 0, Vector2i(52, 24))
		npc_2.set_cell(Vector2i(25, 4), 0, Vector2i(57, 25)) # 2
		npc_2.set_cell(Vector2i(25, 5), 0, Vector2i(57, 26))
		npc_2.set_cell(Vector2i(26, 4), 0, Vector2i(59, 23)) # 6
		npc_2.set_cell(Vector2i(26, 5), 0, Vector2i(59, 24))
		npc_2.set_cell(Vector2i(29, 11), 0, Vector2i(61, 27)) # 4
		npc_2.set_cell(Vector2i(29, 12), 0, Vector2i(61, 28))
		npc_2.set_cell(Vector2i(18, 4), 0, Vector2i(58, 29)) # 5
		npc_2.set_cell(Vector2i(18, 5), 0, Vector2i(58, 30))
		npc_2.set_cell(Vector2i(33, 14), 0, Vector2i(51, 25)) # 3
		npc_2.set_cell(Vector2i(33, 15), 0, Vector2i(51, 26))
		# 男员工
		npc_2.set_cell(Vector2i(19, 12), 1, Vector2i(0, 4))
		npc_2.set_cell(Vector2i(19, 13), 1,Vector2i(0, 5))
		# 女员工
		npc_2.set_cell(Vector2i(15, 4), 2, Vector2i(0, 4))
		npc_2.set_cell(Vector2i(15, 5), 2,Vector2i(0, 5))

	elif state == -1:
		# 男员工
		npc_2.set_cell(Vector2i(19, 12), 1, Vector2i(0, 4))
		npc_2.set_cell(Vector2i(19, 13), 1,Vector2i(0, 5))
		# 女员工
		npc_2.set_cell(Vector2i(10, 7), 2, Vector2i(6, 2))
		npc_2.set_cell(Vector2i(10, 8), 2,Vector2i(6, 3))
		# 会议室
		# 生成
		npc_2.set_cell(Vector2i(23, 4), 0, Vector2i(52, 23)) # 1
		npc_2.set_cell(Vector2i(23, 5), 0, Vector2i(52, 24))
		npc_2.set_cell(Vector2i(29, 11), 0, Vector2i(61, 27)) # 4
		npc_2.set_cell(Vector2i(29, 12), 0, Vector2i(61, 28))
		npc_2.set_cell(Vector2i(33, 14), 0, Vector2i(53, 25)) # 3
		npc_2.set_cell(Vector2i(33, 15), 0, Vector2i(53, 26))
		npc.set_cell(Vector2i(30, 3), 0, Vector2i(61, 25)) # 2
		npc.set_cell(Vector2i(30, 4), 0, Vector2i(61, 26))
		npc_2.set_cell(Vector2i(30, 6), 0, Vector2i(62, 29)) # 5
		npc_2.set_cell(Vector2i(30, 7), 0, Vector2i(62, 30))
		npc_2.set_cell(Vector2i(32, 6), 0, Vector2i(62, 23)) # 6
		npc_2.set_cell(Vector2i(32, 7), 0, Vector2i(62, 24))
	
	elif state == 0:
		# 男员工
		npc_2.set_cell(Vector2i(19, 12), 1, Vector2i(0, 4))
		npc_2.set_cell(Vector2i(19, 13), 1,Vector2i(0, 5))
		# 女员工
		npc_2.set_cell(Vector2i(11, 4), 2, Vector2i(0, 2))
		npc_2.set_cell(Vector2i(11, 5), 2,Vector2i(0, 3))
		# 会议室
		# 生成
		npc_2.set_cell(Vector2i(23, 4), 0, Vector2i(52, 23)) # 1
		npc_2.set_cell(Vector2i(23, 5), 0, Vector2i(52, 24))
		npc.set_cell(Vector2i(30, 3), 0, Vector2i(61, 25)) # 2
		npc.set_cell(Vector2i(30, 4), 0, Vector2i(61, 26))
		npc_2.set_cell(Vector2i(29, 11), 0, Vector2i(61, 27)) # 4
		npc_2.set_cell(Vector2i(29, 12), 0, Vector2i(61, 28))
		npc_2.set_cell(Vector2i(24, 8), 0, Vector2i(52, 25)) # 3
		npc_2.set_cell(Vector2i(24, 9), 0, Vector2i(52, 26))
		npc_2.set_cell(Vector2i(30, 6), 0, Vector2i(62, 29)) # 5
		npc_2.set_cell(Vector2i(30, 7), 0, Vector2i(62, 30))
		npc_2.set_cell(Vector2i(32, 6), 0, Vector2i(62, 23)) # 6
		npc_2.set_cell(Vector2i(32, 7), 0, Vector2i(62, 24))
	
	elif state == 1:
	# 男员工
		npc_2.set_cell(Vector2i(10, 11), 1, Vector2i(6, 2))
		npc_2.set_cell(Vector2i(10, 12), 1,Vector2i(6, 3))
	# 女员工
		npc_2.set_cell(Vector2i(11, 4), 2, Vector2i(0, 2))
		npc_2.set_cell(Vector2i(11, 5), 2,Vector2i(0, 3))
	# 会议室
		npc_2.set_cell(Vector2i(23, 4), 0, Vector2i(52, 23)) # 1
		npc_2.set_cell(Vector2i(23, 5), 0, Vector2i(52, 24))
		npc.set_cell(Vector2i(30, 3), 0, Vector2i(61, 25)) # 2
		npc.set_cell(Vector2i(30, 4), 0, Vector2i(61, 26))
		npc.set_cell(Vector2i(32, 3), 0, Vector2i(55, 25)) # 3
		npc.set_cell(Vector2i(32, 4), 0, Vector2i(55, 26))
		npc_2.set_cell(Vector2i(29, 11), 0, Vector2i(61, 27)) # 4
		npc_2.set_cell(Vector2i(29, 12), 0, Vector2i(61, 28))
		npc_2.set_cell(Vector2i(30, 6), 0, Vector2i(62, 29)) # 5
		npc_2.set_cell(Vector2i(30, 7), 0, Vector2i(62, 30))
		npc_2.set_cell(Vector2i(32, 6), 0, Vector2i(62, 23)) # 6
		npc_2.set_cell(Vector2i(32, 7), 0, Vector2i(62, 24))
		
	elif state == 2:
		# 会议室
		npc.set_cell(Vector2i(28, 3), 0, Vector2i(55, 23)) # 1
		npc.set_cell(Vector2i(28, 4), 0, Vector2i(55, 24))
		npc.set_cell(Vector2i(30, 3), 0, Vector2i(61, 25)) # 2
		npc.set_cell(Vector2i(30, 4), 0, Vector2i(61, 26))
		npc.set_cell(Vector2i(32, 3), 0, Vector2i(55, 25)) # 3
		npc.set_cell(Vector2i(32, 4), 0, Vector2i(55, 26))
		npc_2.set_cell(Vector2i(28, 6), 0, Vector2i(62, 27)) # 4
		npc_2.set_cell(Vector2i(28, 7), 0, Vector2i(62, 28))
		npc_2.set_cell(Vector2i(30, 6), 0, Vector2i(62, 29)) # 5
		npc_2.set_cell(Vector2i(30, 7), 0, Vector2i(62, 30))
		npc_2.set_cell(Vector2i(32, 6), 0, Vector2i(62, 23)) # 6
		npc_2.set_cell(Vector2i(32, 7), 0, Vector2i(62, 24))
		# 男员工
		npc_2.set_cell(Vector2i(10, 11), 1, Vector2i(6, 2))
		npc_2.set_cell(Vector2i(10, 12), 1,Vector2i(6, 3))
		# 女员工
		npc_2.set_cell(Vector2i(10, 7), 2, Vector2i(6, 2))
		npc_2.set_cell(Vector2i(10, 8), 2,Vector2i(6, 3))
	elif state == 3: # 下班
		# 男员工
		npc_2.set_cell(Vector2i(30, 12), 1, Vector2i(0, 0))
		npc_2.set_cell(Vector2i(30, 13), 1,Vector2i(0, 1))
		# 女员工
		npc_2.set_cell(Vector2i(31, 14), 2, Vector2i(0, 0))
		npc_2.set_cell(Vector2i(31, 15), 2,Vector2i(0, 1))

'''
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		var mouse_pos: Vector2 = get_global_mouse_position()
		print("global mouse position: ", mouse_pos)
		
		var local_mouse_pos: Vector2i = npc_2.local_to_map(to_local(mouse_pos))
		var local_mouse_pos2: Vector2i = local_mouse_pos
		local_mouse_pos2.y -= 1
		print(local_mouse_pos)
	
	if Input.is_action_just_pressed("add"):
		state += 1
	if Input.is_action_just_pressed("sub"):
		state -= 1
	#if Input.is_action_just_pressed("test"):
	#	npc.set_cell()
'''


func _on_quit_mouse_entered() -> void:
	if !get_tree().paused:
		quit.material.set_shader_parameter("outline_width", 1)

func _on_quit_mouse_exited() -> void:
	quit.material.set_shader_parameter("outline_width", 0)


func _on_quit_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		global.office_interior_visible = false # 关闭公司室内页面
		if shop_ui.visible:
			shop_ui.hide()
		if panel_container_4.visible:
			panel_container_4.hide()
			
		office_state_1.hide()
		road.show()
		office.show()
		shop.show()


func _on_control_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		panel_container_4.show()


func _on_control_mouse_entered() -> void:
	book.material.set_shader_parameter("outline_width", 2)


func _on_control_mouse_exited() -> void:
	book.material.set_shader_parameter("outline_width", 0)


func _on_speech_tip_close_pressed() -> void:
	panel_container_4.hide()
