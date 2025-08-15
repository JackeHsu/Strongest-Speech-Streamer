extends Control

@onready var item_container = $"CaseScrollContainer/ItemContainer"
@onready var case_container = $"CaseScrollContainer"
@onready var panel = $Panel
@onready var timer: Timer = $Timer
@onready var item_cursor: TextureRect = $ItemCursor
@onready var get_prize: AudioStreamPlayer2D = $get_prize
@onready var background_vague: ColorRect = $background_vague
@onready var rolling_hit: AudioStreamPlayer2D = $rolling_hit



var blue_back = preload("res://scenes/casesimulator/Sprites/mavi.png")
var purple_back = preload("res://scenes/casesimulator/Sprites/mor.png")
var red_back = preload("res://scenes/casesimulator/Sprites/kirmizi.png")
var special_back = preload("res://scenes/casesimulator/Sprites/sari.png")


var blue_range = range(1,56)
var purple_range = range(56,90)
var red_range = range(90,100)

var item_list = {}
var texture_rects = [] # 存放物品图标
var slot_rects = [] # 存放物品
var increase_value = 0
var index_number = 2
var high_limit = 270
var speed = 40
var case_stopped = false


var last_sound_time = 0  # 上次播放音效的时间
var sound_interval = 0.1  # 初始音效播放间隔（单位：秒）


var rest_num = 0 # 背包满时，购买剩下的量


func set_num(_num):
	rest_num = _num

func _ready():
	global.bag_is_full.connect(set_num)
	case_container.get_h_scroll_bar().scale.x = 0
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(0,100):
		var chance = rng.randi_range(1, 100)
		if chance in blue_range:
			create_item("blue_items")
		elif chance in purple_range:
			create_item("purple_items")
		elif chance in red_range:
			create_item("red_items")
		else:
			create_item("special_items")


func _process(_delta):
	if not case_stopped:
		increase_value += 1 * speed
		case_container.scroll_horizontal = increase_value
			
		if case_container.scroll_horizontal > high_limit:
			rolling_hit.play()
			index_number += 1
			high_limit += 260


func create_item(item_type_key):
	var slot_data_index = randi() % item_list.get(item_type_key).size()
	var slot_data = item_list.get(item_type_key)[slot_data_index]
	
	# 设置背景
	var img = TextureRect.new()
	if item_type_key == "blue_items": # 蓝色
		img.texture = blue_back
	elif item_type_key == "purple_items": # 紫色
		img.texture = purple_back
	elif item_type_key == "red_items": # 红色
		img.texture = red_back
	elif item_type_key == "special_items": # 金色
		img.texture = special_back
	# 设置图标
	if slot_data and slot_data.item_data and slot_data.item_data.item_texture:
		var item_icon = TextureRect.new()
		item_icon.texture = slot_data.item_data.item_texture
		var item_icon_x = 128 / item_icon.texture.get_size().x
		var item_icon_y = 128 / item_icon.texture.get_size().y
		var _scale = min(item_icon_x, item_icon_y)
		item_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		item_icon.scale = Vector2(_scale, _scale)  # 图标大小
		var parent_size = Vector2(250, 250)  # 假设父节点大小为 250x250
		var scaled_size = item_icon.texture.get_size() * _scale
		item_icon.position = (parent_size - scaled_size) / 2
		img.add_child(item_icon)
		texture_rects.append(img)
		slot_rects.append(slot_data)
		item_container.add_child(img)


func _on_Timer_timeout():
	if speed > 0 and not case_stopped:
		speed -= 0.5
	elif speed <= 0:
		case_stopped = true
		rolling_hit.stop()
		var selected_texture = texture_rects[index_number]
		var slot = slot_rects[index_number]
		
		var texturerect = panel.get_node("TextureRect")
		texturerect.texture = selected_texture.texture # 背景
		var item_icon = TextureRect.new()
		item_icon.texture = slot.item_data.item_texture
		var item_icon_x = 128 / item_icon.texture.get_size().x
		var item_icon_y = 128 / item_icon.texture.get_size().y
		var _scale = min(item_icon_x, item_icon_y)
		item_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		item_icon.scale = Vector2(_scale, _scale)  # 图标大小
		var parent_size = Vector2(250, 250)  # 假设父节点大小为 250x250
		var scaled_size = item_icon.texture.get_size() * _scale
		item_icon.position = (parent_size - scaled_size) / 2
		texturerect.add_child(item_icon)
			#  添加物品到背包
		if slot.item_data.group_name == "furniture":
			if slot.item_data.equipment_value != 0:
				AchiManager._update_toys_array_state(slot.item_data.equipment_value)
			global.buy_furniture.emit(slot, 1)
		elif slot.item_data.group_name == "interactive":
			global.buy_furniture.emit(slot, 1)
		elif slot.item_data.group_name == "wall":
			global.buy_furniture.emit(slot, 1)
		elif slot.item_data.group_name == "ground":
			global.buy_furniture.emit(slot, 1)
		else:
			if slot.item_data.equipment_type == 5:
				AchiManager._update_keys_array_state(slot.item_data.equipment_value)
			global.buy_item.emit(slot, 1)
		panel.show()
		case_container.hide()
		item_cursor.hide()
		background_vague.hide()
		get_prize.play()
		timer.stop()


func _on_ButtonPanel_pressed():
	global.prize_fin.emit()
	queue_free()
