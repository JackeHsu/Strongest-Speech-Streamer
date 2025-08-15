extends Node2D
class_name Player

@export var inventory_data: InventoryData

@onready var slots: Array = inventory_data.slot_datas # 物品使用功能
@onready var body_sprite: Sprite2D = $"../Bag/ui_interface/bag/PanelContainer3/Control/player_skeleton/body"
@onready var head_sprite: Sprite2D = $"../Bag/ui_interface/bag/PanelContainer3/Control/player_skeleton/head"
@onready var clothes_sprite: Sprite2D = $"../Bag/ui_interface/bag/PanelContainer3/Control/player_skeleton/clothes"
@onready var pants_sprite: Sprite2D = $"../Bag/ui_interface/bag/PanelContainer3/Control/player_skeleton/pants"
@onready var shoes_sprite: Sprite2D = $"../Bag/ui_interface/bag/PanelContainer3/Control/player_skeleton/shoes"
@onready var equipment: Node2D = $"../equipment"


const composite_sprite = preload("res://scripts/player/CompositeSprite.gd") # 服装脚本
var composite_sprite_instance = composite_sprite.new()



func _ready() -> void:
	global.buy_item.connect(buy_item_func) # 连接购买按钮信号
	global.use_item.connect(use_item_func) # 连接使用物品按钮信号
	global.delete_item.connect(delete_item_func) # 连接丢弃物品按钮信号
	global.use_equip.connect(use_equip_func) # 连接使用装备按钮信号
	global.clothes_change.connect(change_clothes) # 连接服装更换信号
	# 初始衣服
	body_sprite.texture = composite_sprite_instance.body_spritesheet[0]
	clothes_sprite.texture = composite_sprite_instance.clothes_spritesheet[0]
	pants_sprite.texture = composite_sprite_instance.pants_spritesheet[0]
	shoes_sprite.texture = composite_sprite_instance.shoes_spritesheet[0]
	
func use_item_func(index):
	var selected_slot = slots[index]
	if selected_slot != null:
		if selected_slot.item_data.group_name == "food": # 玩家选择使用食物
			inventory_data.use_consumable_item(index)

func use_equip_func(index, equip_type):
	var selected_slot = slots[index]
	if selected_slot != null:
		if selected_slot.item_data.group_name == "equipment": # 玩家选择使用装备
			if equipment.slots[equip_type - 1] == null:
				inventory_data.delete_item(index, 1)
				equipment.inventory_data.use_equipment(index, equip_type, selected_slot)
			else:
				inventory_data.swap_equip(index, equipment.slots[equip_type - 1])
				equipment.inventory_data.use_equipment(index, equip_type, selected_slot)

func delete_item_func(index, num):
	var selected_slot = slots[index]
	if selected_slot != null:
		inventory_data.delete_item(index, num)


func buy_item_func(selected_slot, num):
	if selected_slot != null:
		inventory_data.insert_item(selected_slot.item_data, num)

	
func change_clothes(): # 更换衣服
	head_sprite.texture = composite_sprite_instance.head_spritesheet[global.head_index]
	clothes_sprite.texture = composite_sprite_instance.clothes_spritesheet[global.clothes_index]
	pants_sprite.texture = composite_sprite_instance.pants_spritesheet[global.pants_index]
	shoes_sprite.texture = composite_sprite_instance.shoes_spritesheet[global.shoes_index]
