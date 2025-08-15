extends Control

@onready var start_page: Control = $"."
@onready var expain_page: CanvasLayer = $"../expain_page"
@onready var player_name_ui: VBoxContainer = $"../player_name_ui"
@onready var expain_page_load: CanvasLayer = $"../expain_page_load"
@onready var save_tip: Label = $"../save_tip"




func _ready() -> void:
	expain_page.hide()
	player_name_ui.hide()
	expain_page_load.hide()
	save_tip.hide()
	global.saving_date.connect(save_tip.show)
	global.txt_update_failed.connect(txt_text)
	global.txt_update_success.connect(txt_text)

func txt_text():
	save_tip.text = "保存成功！"

func _on_quit_pressed() -> void: # 退出游戏
	get_tree().quit()


func _on_expain_pressed() -> void: # 游戏说明
	expain_page.show()
	start_page.hide()

func _on_back_1_pressed() -> void:
	expain_page.hide()
	start_page.show()

func _on_start_pressed() -> void: # 开始游戏
	start_page.hide()
	player_name_ui.show()


func _on_back_pressed() -> void:
	start_page.show()
	player_name_ui.hide()


func _on_load_pressed() -> void:
	var config = ConfigFile.new()
	var result = config.load("user://player_data/player_inform.cfg")
	
	
	if result == OK: # 加载存档
		global.new_game = false
		# 名字
		global.player_name = config.get_value("Settings", "name")
		# 时间
		global.time = config.get_value("Time", "time")
		# 等级
		global.player_level = config.get_value("PlayerState", "level")
		global.player_exp = config.get_value("PlayerState", "exp")
		# 金币
		global.player_gold = config.get_value("PlayerState", "gold")
		# 情况
		global.office_situation = config.get_value("PlayerState", "situation")
		# 称号
		global.player_nickname = config.get_value("PlayerState", "nickname")
		# 精力
		global.player_energy = config.get_value("PlayerState", "energy")
		#global.player_max_energy = config.get_value("PlayerState", "max_energy")
		# 总分
		global.player_total_score = config.get_value("PlayerState", "total_score")
		# 衣服
		global.head_index = config.get_value("PlayerClothes", "head")
		global.clothes_index = config.get_value("PlayerClothes", "clothes")
		global.pants_index = config.get_value("PlayerClothes", "pants")
		global.shoes_index = config.get_value("PlayerClothes", "shoes")
		global.key_index = config.get_value("PlayerClothes", "key")
		# 建筑状态
		global.shop_state = config.get_value("BuildingState", "shop")
		global.office_state = config.get_value("BuildingState", "office")
		
		# 公司状态
		global.first_work = config.get_value("FirstIntoOffice", "state")
		global.first_home = config.get_value("FirstIntoHome", "home")
		
		# 工作次数
		global.work_times = config.get_value("WorkTimes", "times")
		
		# 请假许可
		global.ask_for_leave = config.get_value("LeaveTimes", "times")
		
		# 录音计数
		global.player_recording_count = config.get_value("Recording", "count")
		
		# 任务计数
		global.tasks_index = config.get_value("Task", "tasks")
		global.meeting_index = config.get_value("Task", "meetings")
		
		# 成就系统
		AchiManager.achi_get_situation = config.get_value("Achievement", "achievement")
		AchiManager.achi_string_update.emit()
		AchiManager.toys = config.get_value("Achievement", "toys")
		AchiManager.keys = config.get_value("Achievement", "keys")
		
		# 关卡计数
		global.level_3_num = config.get_value("Level_3", "level_3")
		
		# 第一次回家
		global.home_in = config.get_value("GoHome", "go_home")
		
		# 场景名称
		global.scene_name = config.get_value("SceneName", "scene_name")
		if global.scene_name == "home_page":
			Game.change_scene("res://scenes/home_page.tscn")
		else:
			Game.change_scene("res://scenes/main_page.tscn")
		

	else:
		start_page.hide()
		expain_page_load.show()


func _on_back_3_pressed() -> void:
	start_page.show()
	expain_page_load.hide()
