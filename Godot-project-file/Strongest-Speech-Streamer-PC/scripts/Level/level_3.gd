extends Node2D
@onready var tile_map_layer_0: TileMapLayer = $TileMapLayer_0
@onready var tile_map_layer_1: TileMapLayer = $TileMapLayer_1
@onready var tile_map_layer_2: TileMapLayer = $TileMapLayer_2
@onready var tile_map_layer_3: TileMapLayer = $TileMapLayer_3
@onready var tile_map_layer_4: TileMapLayer = $TileMapLayer_4
@onready var tile_map_layer_5: TileMapLayer = $TileMapLayer_5
@onready var tile_map_layer_6: TileMapLayer = $TileMapLayer_6
@onready var tile_map_layer_7: TileMapLayer = $TileMapLayer_7
@onready var tile_map_layer_8: TileMapLayer = $TileMapLayer_8
@onready var tile_map_layer_9: TileMapLayer = $TileMapLayer_9

@onready var player: CharacterBody2D = $player
@onready var map_0_over: Area2D = $TileMapLayer_0/map_0_over
@onready var map_1_over: Area2D = $TileMapLayer_1/map_1_over
@onready var map_2_over: Area2D = $TileMapLayer_2/map_2_over
@onready var map_3_over: Area2D = $TileMapLayer_3/map_3_over
@onready var map_4_over: Area2D = $TileMapLayer_4/map_4_over
@onready var map_5_over: Area2D = $TileMapLayer_5/map_5_over
@onready var map_6_over: Area2D = $TileMapLayer_6/map_6_over
@onready var map_7_over: Area2D = $TileMapLayer_7/map_7_over
@onready var map_8_over: Area2D = $TileMapLayer_8/map_8_over
@onready var map_9_over: Area2D = $TileMapLayer_9/map_9_over


func set_map():
	var i = global.level_3_num
	if i == 0:
		tile_map_layer_0.show()
		tile_map_layer_0.enabled = true
		map_0_over.monitoring = true
	elif i == 1:
		tile_map_layer_1.show()
		tile_map_layer_1.enabled = true
		map_1_over.monitoring = true
	elif i == 2:
		tile_map_layer_2.show()
		tile_map_layer_2.enabled = true
		map_2_over.monitoring = true
	elif i == 3:
		tile_map_layer_3.show()
		tile_map_layer_3.enabled = true
		map_3_over.monitoring = true
	elif i == 4:
		tile_map_layer_4.show()
		tile_map_layer_4.enabled = true
		map_4_over.monitoring = true
	elif i == 5:
		tile_map_layer_5.show()
		tile_map_layer_5.enabled = true
		map_5_over.monitoring = true
	elif i == 6:
		tile_map_layer_6.show()
		tile_map_layer_6.enabled = true
		map_6_over.monitoring = true
	elif i == 7:
		tile_map_layer_7.show()
		tile_map_layer_7.enabled = true
		map_7_over.monitoring = true
	elif i == 8:
		tile_map_layer_8.show()
		tile_map_layer_8.enabled = true
		map_8_over.monitoring = true
	elif i == 9:
		tile_map_layer_9.show()
		tile_map_layer_9.enabled = true
		map_9_over.monitoring = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.level_3_num == 10:
		global.level_3_num = 0
	#randomize()
	global.player_energy -= 20
	global.go_from_level_3 = true
	Dialogic.start("start_level_3")
	tile_map_layer_0.hide()
	tile_map_layer_0.enabled = false
	map_0_over.monitoring = false
	tile_map_layer_1.hide() # 地图显示
	tile_map_layer_1.enabled = false # 体积碰撞
	map_1_over.monitoring = false # 结算区域碰撞
	tile_map_layer_2.hide()
	tile_map_layer_2.enabled = false
	map_2_over.monitoring = false
	tile_map_layer_3.hide()
	tile_map_layer_3.enabled = false
	map_3_over.monitoring = false
	tile_map_layer_4.hide()
	tile_map_layer_4.enabled = false
	map_4_over.monitoring = false
	tile_map_layer_5.hide()
	tile_map_layer_5.enabled = false
	map_5_over.monitoring = false
	tile_map_layer_6.hide()
	tile_map_layer_6.enabled = false
	map_6_over.monitoring = false
	tile_map_layer_7.hide()
	tile_map_layer_7.enabled = false
	map_7_over.monitoring = false
	tile_map_layer_8.hide()
	tile_map_layer_8.enabled = false
	map_8_over.monitoring = false
	tile_map_layer_9.hide()
	tile_map_layer_9.enabled = false
	map_9_over.monitoring = false
	set_map()
