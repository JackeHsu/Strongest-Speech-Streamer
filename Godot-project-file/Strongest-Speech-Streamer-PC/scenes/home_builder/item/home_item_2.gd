extends Sprite2D
# 地板和墙纸

@onready var ok: ColorRect = $OK
@onready var deny: ColorRect = $Deny
@onready var item: Sprite2D = $"."

# 用于临时储存slot数据
var tem_slot_data: SlotData
# 状态
var can_place = false # 能否放置
var delete = true # 能否删除，因为点击时已经进入删除状态
var placed = false # 是否已经放置
var tilemap # tilemap层
var ground_or_wall # 地板还是墙
var source_id # tilesetID

func _ready() -> void:
	GameManager.item_delete.connect(delete_f)
	GameManager.item_delete_false.connect(exit_delete_state)
	GameManager.item_delete_true.connect(delete_state)
	GameManager.item_delete2.connect(delete_f2)
	if ground_or_wall == "ground":
		ground()
	elif ground_or_wall == "wall":
		wall()

func ground():
	tilemap = GameManager.tilemap_ground
	
func wall():
	tilemap = GameManager.tilemap_wall

func _process(delta: float) -> void:
	var mouse_tile = tilemap.local_to_map(get_global_mouse_position())
	#print(mouse_tile)
	var tile_data = tilemap.get_cell_tile_data(mouse_tile)
	#print(tile_data)
	var local_pos = tilemap.map_to_local(mouse_tile)
	#print(local_pos)
	var world_pos = tilemap.to_local(local_pos)
	position = world_pos
	position.x += 6
		# 判断是否有瓦片
	if tile_data != null:
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
	if !placed and event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if !can_place:
			return
		
		ok.hide()
		deny.hide()
		placed = true
		GameManager.hold_item = false
		GameManager.item_placed.emit()
		if ground_or_wall == "ground":
			GameManager.ground_placed.emit(source_id)
		elif ground_or_wall == "wall":
			GameManager.wall_placed.emit(source_id)
		
		self.queue_free()
