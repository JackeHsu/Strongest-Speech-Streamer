extends Node2D


@onready var background: TextureRect = $background
@onready var energy_bar: TextureProgressBar = $Control/HBoxContainer/energy/energy_bar
@onready var level: Label = $Control/HBoxContainer/exp/level
@onready var exp_bar: TextureProgressBar = $Control/HBoxContainer/exp/level/exp_bar
@onready var gold_num: Label = $Control/HBoxContainer/gold/gold_num
@onready var office_situation: TextureRect = $Control/HBoxContainer/situation/office_situation
@onready var situation_text: Label = $Control/HBoxContainer/situation
@onready var nick_text: Label = $Control/HBoxContainer/nickname/nick_text
@onready var tip: Label = $tip
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var pause_screen: Control = $pause_screen
@onready var panel_container_4: PanelContainer = $PanelContainer4 # 演讲技巧提示
@onready var warehouse: Node2D = $warehouse
@onready var back: TextureButton = $Back
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var achi: Label = $Control/HBoxContainer/achi
@onready var achi_panel: Control = $achi_panel
@onready var bgm_player: AudioStreamPlayer = $Node/BGMPlayer
@onready var bgm_timer: Timer = $Node/BGMTimer
@onready var player_rank: Control = $PlayerRank
@onready var rank: Label = $Control/rank




var sunrise_texture = preload("res://assets/background/sunrise.png")
var sunset_texture = preload("res://assets/background/sunset.png")


func update_player_state(): # 更新玩家状态栏
	#print(global.player_exp)
	# 背景
	if global.time == "nighttime":
		background.texture = sunset_texture
	elif global.time == "daytime":
		background.texture = sunrise_texture
	# 等级
	level.text = str(global.player_level)
	exp_bar.value = global.player_exp
	# 金币
	gold_num.text = str(global.player_gold)
	# 情况
	var situation
	match global.office_situation:
		-2:
			situation = load("res://assets/ui/situation/down_quickly.png")
			situation_text.add_theme_color_override("font_color", Color(0, 1, 0))
			global.high_exp = 0.5 # 消极状态
			global.high_gold = 3 # 消极状态
		-1:
			situation = load("res://assets/ui/situation/down.png")
			situation_text.add_theme_color_override("font_color", Color(0, 1, 0))
			global.high_exp = 0.75 # 怠慢状态
			global.high_gold = 4.5 # 怠慢状态
		0:
			situation = load("res://assets/ui/situation/stable.png")
			situation_text.add_theme_color_override("font_color", Color(1, 1, 1))
			global.high_exp = 1 # 默认状态
			global.high_gold = 6 # 默认状态
		1:
			situation = load("res://assets/ui/situation/up.png")
			situation_text.add_theme_color_override("font_color", Color(1, 0, 0))
			global.high_exp = 1.5 # 积极状态
			global.high_gold = 7.5 # 积极状态
		2:
			situation = load("res://assets/ui/situation/up_quickly.png")
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
		if !AchiManager.achi_get_array[2]: # 成就
			AchiManager.achi_get.emit(3)
	var energy_percentage := global.player_energy / float(global.player_max_energy)
	energy_bar.value = energy_percentage
	if global.player_energy < 0: # 设置边界
		global.player_energy = 0
	elif global.player_energy > global.player_max_energy:
		global.player_energy = global.player_max_energy

func update_back_button(): # 更新返回按钮图案与音效
	if global.key_index == 0:
		back.texture_normal = load("res://assets/home/back_button/walk_sign.png") #步行
		var audio_stream = load("res://assets/audio/car/walk.wav") as AudioStream
		audio_stream_player.stream = audio_stream
	elif global.key_index == 1:
		back.texture_normal = load("res://assets/home/back_button/bike_0.png") # 自行车
		var audio_stream = load("res://assets/audio/car/bicycle.wav") as AudioStream
		audio_stream_player.stream = audio_stream
	elif global.key_index == 2:
		back.texture_normal = load("res://assets/home/back_button/bike_1.png") # 摩托车
		var audio_stream = load("res://assets/audio/car/bike.wav") as AudioStream
		audio_stream_player.stream = audio_stream
	elif global.key_index == 3:
		back.texture_normal = load("res://assets/home/back_button/normal_car_0.png") # 普通小汽车
		var audio_stream = load("res://assets/audio/car/car_0.wav") as AudioStream
		audio_stream_player.stream = audio_stream
	elif global.key_index == 4:
		back.texture_normal = load("res://assets/home/back_button/normal_car_1.png") # 普通小汽车
		var audio_stream = load("res://assets/audio/car/car_1.wav") as AudioStream
		audio_stream_player.stream = audio_stream
	elif global.key_index == 5:
		back.texture_normal = load("res://assets/home/back_button/sports_car_0.png") # 跑车
		var audio_stream = load("res://assets/audio/car/car_2.wav") as AudioStream
		audio_stream_player.stream = audio_stream
	elif global.key_index == 6:
		back.texture_normal = load("res://assets/home/back_button/sports_car_1.png") # 跑车
		var audio_stream = load("res://assets/audio/car/car_3.wav") as AudioStream
		audio_stream_player.stream = audio_stream
	elif global.key_index == 7:
		back.texture_normal = load("res://assets/home/back_button/sports_car_2.png") # 跑车
		var audio_stream = load("res://assets/audio/car/car_4.wav") as AudioStream
		audio_stream_player.stream = audio_stream

func load_home_bag_data(): # 加载仓库数据
	if FileAccess.file_exists("user://player_data/home_bag.tres"):
			var home_bag = ResourceLoader.load("user://player_data/home_bag.tres")
			
			warehouse.inventory_data = home_bag
			global.home_inventory = home_bag

func _ready() -> void:
	if global.first_home:
		var guide_scene = load("res://scenes/guide/guide_scene_home.tscn").instantiate() # 生成指引界面
		self.add_child(guide_scene)
		guide_scene.position = Vector2(640, 360)
		global.first_home = false
	
	
	if global.home_in == false:
		global.home_in = true
		
	if global.true_new_game_2 and global.new_game == false: # 保证只有在重新打开游戏时才会加载
		load_home_bag_data()
	global.true_new_game_2 = false
	
	if global.go_from_level_3: # 从level返回时加载仓库数据
		load_home_bag_data()
		global.go_from_level_3 = false
		
	if global.level_3_num == 10:
		if !AchiManager.achi_get_array[4]:
			AchiManager.achi_get.emit(5)
	
	home_load()
	player_rank.hide()
	canvas_layer.hide()
	tip.hide()
	panel_container_4.hide()
	achi_panel.hide()

	if global.time == "nighttime":
		background.texture = sunset_texture
	elif global.time == "daytime":
		background.texture = sunrise_texture
		
	global.player_sleep.connect(player_sleep_f)
	global.play_game.connect(play_game_f)
	global.read_tips.connect(read_tips_f)
	audio_stream_player.connect("finished", Callable(self, "change_scene_f"))
	
	update_back_button()
	
	update_player_state()

func player_sleep_f():
	if global.time == "daytime":
		global.cant_sleep.emit()
	else:
		tip.show()

func play_game_f():
	if global.time == "daytime":
		#print("还是去上班吧！")
		global.go_to_work.emit()
	else:
		if global.player_energy >= 10:
			home_save()
			var home_bag = ResourceSaver.save(warehouse.inventory_data, "user://player_data/home_bag.tres")
			Game.change_scene("res://scenes/level_3.tscn")
		else:
			global.go_to_sleep.emit()
		#print("打电动")

func read_tips_f():
	panel_container_4.show()


func _on_confirm_pressed() -> void:
	tip.hide()
	global.time = "daytime"
	global.player_energy = global.player_max_energy
	global.work_times = 2
	print("当前体力值" + str(global.player_energy))
	print("当前最大体力值" + str(global.player_max_energy))
	if !AchiManager.achi_get_array[1]:
		AchiManager.achi_get.emit(2)
	change_scene_tween()
	
func change_scene_tween(): # 转场黑屏效果
	var tree := get_tree()
	tree.paused = true #转场时冻结游戏
	canvas_layer.visible = true
	var tween := create_tween() #场景切换渡效果
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 1, 1)
	await tween.finished
	update_player_state()

	tree.paused = false
	
	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 0, 1)
	await tween.finished
	canvas_layer.visible = false #转场结束时转场效果禁用
	
func _on_cancel_pressed() -> void:
	tip.hide()


func home_load(): # 家数据加载
	if !FileAccess.file_exists("user://player_data/home_data.tres"):
		return
	var data = ResourceLoader.load("user://player_data/home_data.tres") as SceneData
	if not data:
		print("不存在家数据！")
		return
	var parent = get_tree().current_scene # 父节点

	for node in get_tree().get_nodes_in_group("Home"):
		node.free()
	var home_node = data.home_data
	var node = home_node.instantiate()
	node.set_name("home")
	get_tree().current_scene.add_child(node, true)
	  # 将 home 移动到父节点的第 4 个子节点位置（索引 3）
	var target_index = min(3, parent.get_child_count() - 1)  # 确保索引有效
	parent.move_child(node, target_index)
	
		# 确保GameManager的变量正确赋值
	GameManager.tilemap_ground = node.get_node("ground")
	GameManager.tilemap_wall = node.get_node("wall")
	
	#global.home_inventory = node.get_node("warehouse").inventory_data
	
	print("加载家数据!")

func home_save():
	var data = SceneData.new()
	var node = get_node("home")
	var home_scene = PackedScene.new()
	home_scene.pack(node)
	data.home_data = home_scene
	#global.home_inventory = node.get_node("warehouse").inventory_data
	ResourceSaver.save(data, "user://player_data/home_data.tres")
	print("家数据保存!")


func _on_back_pressed() -> void:
	if global.player_energy == 0:
		global.go_to_sleep.emit()
	else:
		back.hide()
		home_save()
		# 回家交通工具扣除体力
		if global.key_index == 0:
			global.player_energy -= 20
		elif global.key_index == 1:
			global.player_energy -= 15
		elif global.key_index == 2:
			global.player_energy -= 10
		audio_stream_player.play()
		get_tree().paused = true # 防止点击回公司后可以点击其他地方

	
func change_scene_f():
	Game.change_scene("res://scenes/main_page.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		global.game_pause.emit()
		pause_screen.show_pause()


func _on_speech_tip_close_pressed() -> void: # 关闭提示页面
	panel_container_4.hide()


func _on_back_mouse_entered() -> void:
	back.material.set_shader_parameter("outline_width", 1)


func _on_back_mouse_exited() -> void:
	back.material.set_shader_parameter("outline_width", 0)

func _on_achi_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			achi_panel.show()


func _on_achi_mouse_entered() -> void:
	achi.material.set_shader_parameter("outline_width", 1)


func _on_achi_mouse_exited() -> void:
	achi.material.set_shader_parameter("outline_width", 0)


func _on_bgm_timer_timeout() -> void:
	bgm_timer.stop()
	bgm_player.play()


func _on_rank_mouse_entered() -> void:
	rank.material.set_shader_parameter("outline_width", 1)


func _on_rank_mouse_exited() -> void:
	rank.material.set_shader_parameter("outline_width", 0)


func _on_rank_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#print("鼠标左键按下")
			player_rank.show()
			player_rank.show_result()


func _on_pause_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pause_screen.show_pause()
