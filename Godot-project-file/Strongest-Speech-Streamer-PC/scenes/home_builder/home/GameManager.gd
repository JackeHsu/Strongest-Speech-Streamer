extends Node

signal item_selected
signal item_selected_2 # 选择二层物品
signal item_selected_1 # 选择墙壁物品
signal item_still_live_2 # 鼠标中还有二层物品
signal item_still_live_1 # 选择墙壁物品
signal item_placed # 物品放置
signal item_delete # 物品删除
signal item_delete2 # 暂停时物品删除
signal item_delete_true # 进入UI区域
signal item_delete_false # 离开UI区域
signal item_still_live # 鼠标中还有物品
signal pick_up_item # 捡起物品
signal pick_up_item_2 # 用于传递参数
signal selected_wall # 选择壁纸
signal selected_ground # 选择地板
signal wall_placed # 壁纸放置
signal ground_placed # 地板放置
signal interactive_selected # 选择可交互物品
signal interactive_selected_1 # 墙壁可交互物品

var current_state = State.IDLE
var tilemap_ground
var tilemap_wall
var temp_item_slot_data: SlotData # 用于参数传递
var hold_item = false # 鼠标上是否有物品

enum State {
	IDLE,
	PLACE,
	DELETE,
}

func _ready():
	item_selected.connect(item_select)
	item_selected_2.connect(item_select_2)
	item_still_live.connect(item_continue)
	item_still_live_2.connect(item_continue_2)
	pick_up_item.connect(item_slot_data)
	selected_ground.connect(ground_select)
	selected_wall.connect(wall_select)
	interactive_selected.connect(interactive_select)
	item_selected_1.connect(item_select_1)
	item_still_live_1.connect(item_continue_1)
	interactive_selected_1.connect(interactive_select_1)
	
func item_select(texture: Texture2D): # 位于地面
	var item = load("res://scenes/home_builder/item/item.tscn").instantiate()
	item.texture = texture
	item.item_size = item.texture.get_size()
	item.tem_slot_data = temp_item_slot_data
	item.item_layer = 0
	get_tree().call_group("Home", "place_object", item)

func item_continue(texture: Texture2D): # 位于地面
	var item = load("res://scenes/home_builder/item/item.tscn").instantiate()
	item.texture = texture
	item.delete = false
	item.item_size = item.texture.get_size()
	item.tem_slot_data = temp_item_slot_data
	item.item_layer = 0
	get_tree().call_group("Home", "place_object", item)
	
func item_select_2(texture: Texture2D): # 位于地面第二层
	var item = load("res://scenes/home_builder/item/item.tscn").instantiate()
	item.texture = texture
	item.item_size = item.texture.get_size()
	item.tem_slot_data = temp_item_slot_data
	item.item_layer = 2
	get_tree().call_group("Home", "place_object_2", item)

func item_continue_2(texture: Texture2D): # 位于地面第二层
	var item = load("res://scenes/home_builder/item/item.tscn").instantiate()
	item.texture = texture
	item.delete = false
	item.item_size = item.texture.get_size()
	item.tem_slot_data = temp_item_slot_data
	item.item_layer = 2
	get_tree().call_group("Home", "place_object_2", item)

func item_select_1(texture: Texture2D): # 位于墙壁
	var item = load("res://scenes/home_builder/item/item.tscn").instantiate()
	item.texture = texture
	item.item_size = item.texture.get_size()
	item.tem_slot_data = temp_item_slot_data
	item.item_layer = 1
	get_tree().call_group("Home", "place_object_wall", item)
	
func item_continue_1(texture: Texture2D): # 位于墙壁
	var item = load("res://scenes/home_builder/item/item.tscn").instantiate()
	item.texture = texture
	item.delete = false
	item.item_size = item.texture.get_size()
	item.tem_slot_data = temp_item_slot_data
	item.item_layer = 1
	get_tree().call_group("Home", "place_object_wall", item)
	
func ground_select(texture: Texture2D, source_id: int):
	var item = load("res://scenes/home_builder/item/item_2.tscn").instantiate()
	item.texture = texture
	#item.item_size = item.texture.get_size()
	item.ground_or_wall = "ground"
	item.source_id = source_id
	get_tree().call_group("Home", "place_object_2", item)
	
func wall_select(texture: Texture2D, source_id: int):
	var item = load("res://scenes/home_builder/item/item_2.tscn").instantiate()
	item.texture = texture
	#item.item_size = item.texture.get_size()
	item.ground_or_wall = "wall"
	item.source_id = source_id
	get_tree().call_group("Home", "place_object_2", item)
	
func interactive_select(texture: Texture2D, interactive_type: String):
	var item = load("res://scenes/home_builder/item/item_3.tscn").instantiate()
	item.texture = texture
	item.item_size = item.texture.get_size()
	item.tem_slot_data = temp_item_slot_data
	item.item_layer = 0
	item.interactive_type = interactive_type
	get_tree().call_group("Home", "place_object", item)
	
func interactive_select_1(texture: Texture2D, interactive_type: String):
	var item = load("res://scenes/home_builder/item/item_3.tscn").instantiate()
	item.texture = texture
	item.item_size = item.texture.get_size()
	item.tem_slot_data = temp_item_slot_data
	item.item_layer = 1
	item.interactive_type = interactive_type
	get_tree().call_group("Home", "place_object_wall", item)
	
func item_slot_data(slot_data: SlotData):
	temp_item_slot_data = slot_data
