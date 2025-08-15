extends Node2D

@onready var background: TextureRect = $background
@onready var pause_screen: Control = $pause_screen
@onready var energy_bar: TextureProgressBar = $Control/HBoxContainer/energy/energy_bar
@onready var level: Label = $Control/HBoxContainer/exp/level
@onready var exp_bar: TextureProgressBar = $Control/HBoxContainer/exp/level/exp_bar
@onready var gold_num: Label = $Control/HBoxContainer/gold/gold_num
@onready var office_situation: TextureRect = $Control/HBoxContainer/situation/office_situation
@onready var situation_text: Label = $Control/HBoxContainer/situation
@onready var nick_text: Label = $Control/HBoxContainer/nickname/nick_text
@onready var bag_ui: Control = $Bag/ui_interface/bag
@onready var equipment_ui: Control = $Bag/ui_interface/bag/equipment_ui
@onready var gold_shop: Label = $shop/shop_indoor/gold # 商店页面金币显示
@onready var warehouse: Node2D = $warehouse
@onready var achievement_panel: Panel = $Control/AchievementPanel
@onready var bgm_player: AudioStreamPlayer = $Node/BGMPlayer
@onready var bgm_timer: Timer = $Node/BGMTimer
@onready var player_rank: Control = $PlayerRank



# 情况
var situation0 = preload("res://assets/ui/situation/stable.png")
var situation1 = preload("res://assets/ui/situation/up.png")
var situation2 = preload("res://assets/ui/situation/up_quickly.png")
var situation_1 = preload("res://assets/ui/situation/down.png")
var situation_2 = preload("res://assets/ui/situation/down_quickly.png")

var sunrise_texture = preload("res://assets/background/sunrise.png")
var sunset_texture = preload("res://assets/background/sunset.png")

var temp_build_state = 0 # 存储当前建筑状态

var shop_bgm = preload("res://assets/audio/Shop_bgm.wav")
var main_bgm_1 = preload("res://assets/audio/Main_page_bgm_1.wav")
var main_bgm_2 = preload("res://assets/audio/Main_page_bgm_2.mp3")

func _ready() -> void: # 保证切换场景后回来背景图不会闪
	
	var file_path = "user://player_data/player_data2.dat"
	
	if FileAccess.file_exists(file_path):
		var time_string = Time.get_datetime_string_from_system()
		var file = FileAccess.open("user://player_data/player_data2.dat", FileAccess.READ_WRITE)
		file.seek_end()
		file.store_line("开始游戏时间：" + time_string)
		file.close()
	
	global.prize_draw.connect(bgm_volume_db_down)
	global.prize_fin.connect(bgm_volume_db_up)
	
	achievement_panel.hide()
	player_rank.hide()
	
	global.max_energy_count += 1 # 最大体力buff回合计数器
	global.buff_count += 1 # buff回合计数器
	if global.max_energy_count == 3: # 最大体力只会持续两个回合
		global.player_max_energy = 100
		global.max_energy_count = 0
	if global.buff_count == global.buff_sustain_rounds + 1:
		global.exp_buff = 1
		global.gold_buff = 1
		global.buff_count = 0
		
	global.clothes_change.emit()
	global.var_change.connect(update_player_state)
	if global.true_new_game and global.new_game == false: # 保证只有在重新打开游戏时才会加载
		load_bag()
	if global.true_new_game_2 and global.new_game == false:
		if FileAccess.file_exists("user://player_data/home_bag.tres"): # 存在仓库数据就执行
			var home_bag = ResourceLoader.load("user://player_data/home_bag.tres")
			warehouse.inventory_data = home_bag
			global.home_inventory = home_bag
	global.true_new_game = false # 保证能够正确设置true_new_game，防止一次打开游戏调用load_bag
	global.true_new_game_2 = false
	
	if global.equipment_inventory && global.player_inventory != null:
		var player_inventory = get_node("/root/main_page/Player")
		player_inventory.inventory_data = global.player_inventory
		global.bag_data_update.emit()
		global.clothes_change.emit()
		
	if global.time == "nighttime":
		background.texture = sunset_texture
	elif global.time == "daytime":
		background.texture = sunrise_texture
		
		# 设置初始值
	if global.new_game == true:
		global.time = "daytime"
		background.texture = sunrise_texture
		var guide_scene = load("res://scenes/guide/guide_scene.tscn").instantiate() # 生成指引界面
		self.add_child(guide_scene)
		guide_scene.position = Vector2(640, 360)
		
		# 等级
		global.player_level = 1
		global.player_exp = 0
		# 金币
		global.player_gold = 0
		gold_num.text = str(global.player_gold)
		gold_shop.text = "金币：" + str(global.player_gold)
		# 情况
		global.office_situation = 0
		office_situation.texture = situation0
		# 称号
		global.player_nickname = "实习生"
		nick_text.text = "实习生"
		# 精力
		global.player_energy = 100
		global.player_max_energy = 100
		global.player_total_score = 0
		# 服装
		global.head_index = 0
		global.clothes_index = 0
		global.pants_index = 0
		global.shoes_index = 0
		global.key_index = 0
		# 时间
		global.time = "daytime"
		# 建筑
		global.shop_state = 0
		global.office_state = 0
		# 公司
		global.first_work = true
		global.first_home = true
		# 次数
		global.work_times = 2
		# 请假
		global.ask_for_leave = 1
		# 录音
		global.player_recording_count = 0
		# 任务
		global.tasks_index = [0, 0, 0, 0, 0]
		global.meeting_index = [0, 0, 0, 0, 0]
		# 成就
		AchiManager.achi_get_situation = [0, 0, 0, 0, 0, 0, 0, 0]
		AchiManager.toys = [0, 0, 0, 0, 0]
		AchiManager.keys = [0, 0, 0, 0, 0, 0, 0]
		# 回家
		global.home_in = false
		global.new_game = false
	else:
		update_player_state() # 防止转场时状态栏加载慢
		#update_player_state() # 防止经验条变化不及时
		
func _state_change(): # 建筑状态是否变化
	if temp_build_state != global.shop_state:
		temp_build_state = global.shop_state
		global.state_change.emit()


func update_player_state():
	#print(global.player_exp)
	# 背景
	if global.time == "nighttime":
		background.texture = sunset_texture
	elif global.time == "daytime":
		background.texture = sunrise_texture
	# 等级
	if global.player_exp >= 100:
		var x = int(global.player_exp / 100) # 升几级
		global.player_exp = global.player_exp - (100 * x)
		global.player_level += x
	if global.player_level >= 1 && global.player_level <= 10: # 建筑状态
		global.shop_state = 0
		global.office_state = 0
		#global.state_change.emit()
	elif global.player_level >= 11 && global.player_level <= 20:
		global.shop_state = 1
		global.office_state = 1
		_state_change()
		#global.state_change.emit()
	elif global.player_level >= 21:
		global.shop_state = 2
		global.office_state = 2
		_state_change()
		#global.state_change.emit()
	level.text = str(global.player_level)
	exp_bar.value = global.player_exp
	# 金币
	gold_num.text = str(global.player_gold)
	gold_shop.text = "金币：" + str(global.player_gold)
	if global.player_gold >= 100000:
		if !AchiManager.achi_get_array[3]: # 成就
			AchiManager.achi_get.emit(4)
	# 情况
	if global.office_situation > 2: # 设置边界
		global.office_situation = 2
	elif global.office_situation < -2:
		global.office_situation = -2
	var situation
	match global.office_situation:
		-2:
			situation = situation_2
			situation_text.add_theme_color_override("font_color", Color(0, 1, 0))
			global.high_exp = 0.5 # 消极状态
			global.high_gold = 3 # 消极状态
		-1:
			situation = situation_1
			situation_text.add_theme_color_override("font_color", Color(0, 1, 0))
			global.high_exp = 0.75 # 怠慢状态
			global.high_gold = 4.5 # 怠慢状态
		0:
			situation = situation0
			situation_text.add_theme_color_override("font_color", Color(1, 1, 1))
			global.high_exp = 1 # 默认状态
			global.high_gold = 6 # 默认状态
		1:
			situation = situation1
			situation_text.add_theme_color_override("font_color", Color(1, 0, 0))
			global.high_exp = 1.5 # 积极状态
			global.high_gold = 7.5 # 积极状态
		2:
			situation = situation2
			situation_text.add_theme_color_override("font_color", Color(1, 0, 0))
			global.high_exp = 2 # 热血状态
			global.high_gold = 9 # 热血状态
	office_situation.texture = situation
	# 称号
	if global.player_level == 1:
		global.player_nickname = "实习生"
		nick_text.text = global.player_nickname
	elif global.player_level > 1 && global.player_level <= 3:
		global.player_nickname = "见习生"
		nick_text.text = global.player_nickname
	elif global.player_level > 3 && global.player_level <= 6:
		global.player_nickname = "员工"
		nick_text.text = global.player_nickname
	elif global.player_level > 6 && global.player_level <= 9:
		global.player_nickname = "专员"
		nick_text.text = global.player_nickname
	elif global.player_level > 9 && global.player_level <= 12:
		global.player_nickname = "助理"
		nick_text.text = global.player_nickname
	elif global.player_level > 12 && global.player_level <= 15:
		global.player_nickname = "主管"
		nick_text.text = global.player_nickname
	elif global.player_level > 15 && global.player_level <= 18:
		global.player_nickname = "组长"
		nick_text.text = global.player_nickname
	elif global.player_level > 18 && global.player_level <= 21:
		global.player_nickname = "经理"
		nick_text.text = global.player_nickname
	elif global.player_level > 21 && global.player_level <= 24:
		global.player_nickname = "总监"
		nick_text.text = global.player_nickname
	elif global.player_level > 24 && global.player_level <= 27:
		global.player_nickname = "总经理"
		nick_text.text = global.player_nickname
	elif global.player_level > 27 && global.player_level <= 29:
		global.player_nickname = "执行官"
		nick_text.text = global.player_nickname
	else:
		global.player_nickname = "董事长"
		nick_text.text = global.player_nickname
		global.work_table_change.emit()
		if !AchiManager.achi_get_array[2]: # 成就
			AchiManager.achi_get.emit(3)
	# 精力
	var energy_percentage := global.player_energy / float(global.player_max_energy)
	energy_bar.value = energy_percentage
	if global.player_energy < 0: # 设置边界
		global.player_energy = 0
	elif global.player_energy > global.player_max_energy:
		global.player_energy = global.player_max_energy
	
	# 建筑
	# 在建筑自己的脚本里
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_screen.show_pause()
'''
	if event.is_action_pressed("add"):
		global.player_energy -= 10
		global.player_exp += 80
		global.player_gold += 10000
		global.office_situation += 1
	#	global.player_level += 1
		global.var_change.emit()
		print("加和减没有注释")

	if event.is_action_pressed("sub"):
		global.player_energy += 10
		global.player_gold -= 1000
		global.office_situation -= 1
		global.var_change.emit()
'''

func load_bag(): # 背包数据加载
	if !FileAccess.file_exists("user://player_data/bag_data.tres"):
		return
	var data = ResourceLoader.load("user://player_data/bag_data.tres") as SceneData
	for box in get_tree().get_nodes_in_group("player"):
		box.free()
	for box in data.box_array:
		var box_node = box.instantiate()
		get_tree().current_scene.add_child(box_node, true)
		if box_node.name == "equipment":
			global.equipment_inventory = box_node.inventory_data
		elif box_node.name == "Player":
			global.player_inventory = box_node.inventory_data
	global.bag_data_update.emit()
	global.equip_data_update.emit()
	
	print("load!")

func bgm_volume_db_up():
	bgm_player.volume_db += 20
func bgm_volume_db_down():
	bgm_player.volume_db -= 20
	
func _on_bgm_timer_timeout() -> void:
	bgm_timer.stop()
	randomize()
	var rand_bgm = randi() % 2
	if global.time == "daytime":
		if rand_bgm == 0:
			bgm_player.stream = main_bgm_1
			bgm_player.play()
		elif rand_bgm == 1:
			bgm_player.stream = main_bgm_2
			bgm_player.play()
	elif global.time == "nighttime":
		bgm_player.stream = shop_bgm
		bgm_player.play()


func _on_pause_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pause_screen.show_pause()
