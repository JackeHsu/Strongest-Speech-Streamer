extends Node2D

@onready var first_layer: Node2D = $first_layer
@onready var second_layer: Node2D = $first_layer/second_layer
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var grabbed_slot: Control = $CanvasLayer/UI/grabbed_slot
@onready var ground: TileMapLayer = $ground
@onready var wall: TileMapLayer = $wall
@onready var wall_item: Node2D = $wall_item
@onready var back: TextureButton = $"../Back"
@onready var idle_button: Button = $IDLE
@onready var place_button: Button = $PLACE



enum State {
	IDLE,
	PLACE,
	DELETE,
}

#var current_state = State.IDLE

func _ready() -> void:
	idle_button.hide()
	global.game_pause.connect(_on_idle_pressed)
	canvas_layer.hide()
	GameManager.tilemap_ground = get_node("ground")
	GameManager.tilemap_wall = get_node("wall")
	GameManager.ground_placed.connect(ground_change)
	GameManager.wall_placed.connect(wall_change)
	
func replace_tiles(tilemap: TileMapLayer, new_tile_id: int): # 待完善
	# 获取所有已使用的格子坐标
	var used_cells = tilemap.get_used_cells()
	for cell in used_cells:
		# 检查当前格子的图块 ID
		var cell_pos = Vector2i(cell)
		var atlas_coord = tilemap.get_cell_atlas_coords(cell_pos)
			# 替换为新的图块 ID
		tilemap.set_cell(cell, new_tile_id, atlas_coord)

func wall_change(source_id: int):
	print("放置壁纸")
	replace_tiles(wall, source_id)

func ground_change(source_id: int):
	print("放置地板")
	replace_tiles(ground, source_id)

func place_object(obj):
	first_layer.add_child(obj)
	obj.owner = first_layer.owner
	
	var child_count = first_layer.get_child_count()
	var last_child = first_layer.get_child(child_count - 1)

	first_layer.move_child(last_child, 0)
	
func place_object_2(obj):
	second_layer.add_child(obj)
	obj.owner = second_layer.owner

func place_object_wall(obj):
	wall_item.add_child(obj)
	obj.owner = wall_item.owner

func _on_place_pressed() -> void: # 进入放置状态
	idle_button.show()
	place_button.hide()
	GameManager.current_state = State.PLACE
	canvas_layer.show()
	back.hide()


func _on_idle_pressed() -> void: # 进入闲置状态
	idle_button.hide()
	place_button.show()
	GameManager.current_state = State.IDLE
	#print(GameManager.current_state)
	GameManager.item_delete.emit()
	canvas_layer.hide()
	back.show()

func _on_ui_mouse_entered() -> void:
	GameManager.item_delete_true.emit()
	GameManager.current_state = State.DELETE


func _on_ui_mouse_exited() -> void:
	GameManager.item_delete_false.emit()
	GameManager.current_state = State.PLACE
	#if grabbed_slot.label.text != null:
		#grabbed_slot.visible = true



	
