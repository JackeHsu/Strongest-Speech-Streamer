extends Sprite2D 
# 普通物品

@onready var ok: ColorRect = $OK
@onready var deny: ColorRect = $Deny
@onready var area_2d: Area2D = $Area2D
@onready var item: Sprite2D = $"."

# 用于临时储存slot数据
@export var tem_slot_data: SlotData
# 状态
@export var can_place = false # 能否放置
@export var delete = true # 能否删除，因为点击时已经进入删除状态
@export var placed = false # 是否已经放置
@export var mouse_enter = false # 鼠标置于物品上
@export var _process_state: bool = true # 物体的process状态
var layer
# 参数
@export var item_size: Vector2i # 物品尺寸
@export var item_layer: int # 物品层数


func _create_collision():
	var area2d = self.get_node("Area2D")
	var collision_shape_2d = CollisionShape2D.new()
		# 设置碰撞层
	collision_shape_2d.shape = RectangleShape2D.new()
	collision_shape_2d.shape.size.x = item_size.x - 2
	collision_shape_2d.shape.size.y = item_size.y - 8
	collision_shape_2d.position = Vector2i(0, 8)
	area2d.add_child(collision_shape_2d)
		
func _ready() -> void:
	if _process_state == true:
		set_process(true)
	elif _process_state == false:
		set_process(false)
	# 创建碰撞层
	_create_collision()
	
	GameManager.item_delete.connect(delete_f)
	GameManager.item_delete_false.connect(exit_delete_state)
	GameManager.item_delete_true.connect(delete_state)
	GameManager.item_delete2.connect(delete_f2)
	# 设置放置标志
	ok.size = item_size
	deny.size = item_size
	ok.position = - ok.size / 2
	deny.position = - deny.size / 2
	
	if item_layer == 2: # 放置地面
		area_2d.collision_layer = 4
		area_2d.collision_mask = 4
		layer = GameManager.tilemap_ground
	elif item_layer == 1: # 放置墙壁
		area_2d.collision_layer = 2
		area_2d.collision_mask = 2
		layer = GameManager.tilemap_wall
	elif item_layer == 0:
		area_2d.collision_layer = 1
		area_2d.collision_mask = 1
		layer = GameManager.tilemap_ground
	

func board(_position: Vector2i): # 边界判断
	var left = Vector2i(_position.x - (item_size / 2).x + 8, _position.y + 16)
	var right = Vector2i(_position.x + (item_size / 2).x, _position.y + 16)
	var bottom = Vector2i(_position.x, _position.y + (item_size / 2).x)
	var item_left = layer.local_to_map(left)
	var item_right = layer.local_to_map(right)
	var item_bottom = layer.local_to_map(bottom)
	if !layer.get_cell_tile_data(item_left):
		return false
	if !layer.get_cell_tile_data(item_right):
		return false
	if !layer.get_cell_tile_data(item_bottom):
		return false
	return true
	
func _process(_delta: float) -> void:
	if layer == null or not is_instance_valid(layer):
		if item_layer == 2 and is_instance_valid(GameManager.tilemap_ground):
			layer = GameManager.tilemap_ground
		elif item_layer == 1 and is_instance_valid(GameManager.tilemap_wall):
			layer = GameManager.tilemap_wall
		elif item_layer == 0 and is_instance_valid(GameManager.tilemap_ground):
			layer = GameManager.tilemap_ground
			
	var mouse_tile = layer.local_to_map(get_global_mouse_position())
	var tile_data = layer.get_cell_tile_data(mouse_tile)
	#print(tile_data)
	var local_pos = layer.map_to_local(mouse_tile)
	var world_pos = layer.to_local(local_pos)
	position = world_pos
	position.x += 8
		# 判断是否有瓦片
	if tile_data != null and board(get_global_mouse_position()):
		if area_2d.get_overlapping_areas().size() > 0:
			can_place = false
			deny.show()
			ok.hide()
		else:
			can_place = true
			ok.show()
			deny.hide()
	else:
		can_place = false
		deny.show()
		ok.hide()
	
	if delete == true and placed == false: # 用于视觉显示，进入UI范围使用背包显示方法
		self.hide()
		can_place = false
	elif delete == false and placed == false: # 用于视觉显示，进入UI范围使用背包显示方法
		self.show()

func delete_state():
	delete = true

func exit_delete_state():
	delete = false
	
func delete_f():
	if delete and placed == false:
		self.queue_free()
		GameManager.hold_item = false
	if can_place == false:
		self.queue_free()
		GameManager.hold_item = false

func delete_f2():
	if placed == false:
		self.queue_free()
		GameManager.hold_item = false
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if !placed:
			#var arr = area_2d.get_overlapping_areas()
			if !can_place:
				return

			set_process(false)
			_process_state = false
		#set_process_unhandled_input(false)
		#area_2d.monitoring = false
		
			ok.hide()
			deny.hide()
			placed = true
			GameManager.hold_item = false
			GameManager.item_placed.emit()
		else:
			if GameManager.current_state == 1 and !GameManager.hold_item and mouse_enter and event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
				set_process(true)
				_process_state = true
				ok.show()
				deny.show()
				placed = false
				tem_slot_data.quantity = 1
				GameManager.pick_up_item_2.emit(tem_slot_data)
				GameManager.hold_item = true
		
func _on_area_2d_mouse_entered() -> void: # 用于判断鼠标是否移动至物品上
	if placed and GameManager.hold_item == false:
		mouse_enter = true


func _on_area_2d_mouse_exited() -> void: # 用于判断鼠标是否离开物品
	mouse_enter = false
