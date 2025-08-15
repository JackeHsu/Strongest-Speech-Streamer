extends Control

@onready var resume: Button = $VBoxContainer/HBoxContainer/resume
@onready var upload_date_txt: Node2D = $"../../Game/upload_date_txt"
@onready var home_page: Node2D = $".."
@onready var warehouse: Node2D = $"../warehouse"
@onready var player_rank: Control = $"../PlayerRank"



func _ready() -> void:
	hide()
	
	visibility_changed.connect(func ():
		get_tree().paused = visible
		GameManager.item_delete2.emit()
		)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		hide()
		get_window().set_input_as_handled()

func show_pause() -> void:
	show()
	player_rank.hide()
	
func _on_resume_pressed() -> void:
	hide()


func _on_quit_pressed() -> void: # 存档功能
	var config = ConfigFile.new()
	# 玩家名字
	config.set_value("Settings", "name", global.player_name)
	# 世界时间
	config.set_value("Time", "time", global.time)
	# 玩家等级
	config.set_value("PlayerState", "level", global.player_level)
	config.set_value("PlayerState", "exp", global.player_exp)
	# 玩家金币
	config.set_value("PlayerState", "gold", global.player_gold)
	# 公司情况
	config.set_value("PlayerState", "situation", global.office_situation)
	# 玩家称号
	config.set_value("PlayerState", "nickname", global.player_nickname)
	# 玩家精力
	config.set_value("PlayerState", "energy", global.player_energy)
	#config.set_value("PlayerState", "max_energy", global.player_max_energy)
	# 玩家总分
	config.set_value("PlayerState", "total_score", global.player_total_score)
	# 玩家衣服
	config.set_value("PlayerClothes", "head", global.head_index)
	config.set_value("PlayerClothes", "clothes", global.clothes_index)
	config.set_value("PlayerClothes", "pants", global.pants_index)
	config.set_value("PlayerClothes", "shoes", global.shoes_index)
	config.set_value("PlayerClothes", "key", global.key_index)
	
	# 建筑状态
	config.set_value("BuildingState", "shop", global.shop_state)
	config.set_value("BuildingState", "office", global.office_state)
	
	# 公司状态
	config.set_value("FirstIntoOffice", "state", global.first_work)
	config.set_value("FirstIntoHome", "home", global.first_home)
	# 工作次数
	config.set_value("WorkTimes", "times", global.work_times)
	
	# 请假限制
	config.set_value("LeaveTimes", "times", global.ask_for_leave)
	
	# 录音计数
	config.set_value("Recording", "count", global.player_recording_count)
	
	# 任务计数
	config.set_value("Task", "tasks", global.tasks_index) # 设置初始值
	config.set_value("Task", "meetings", global.meeting_index) # 设置初始值
	
	# 成就系统
	config.set_value("Achievement", "achievement", AchiManager.achi_get_situation)
	config.set_value("Achievement", "toys", AchiManager.toys) # 设置初始值
	config.set_value("Achievement", "keys", AchiManager.keys) # 设置初始值
	# 场景名称
	config.set_value("SceneName", "scene_name", "home_page")
	
	# 关卡计数
	config.set_value("Level_3", "level_3", global.level_3_num)
	
	# 第一次回家
	config.set_value("GoHome", "go_home", global.home_in)
	
	# 仓库库存
	var home_bag = ResourceSaver.save(warehouse.inventory_data, "user://player_data/home_bag.tres")
	
	config.save("user://player_data/player_inform.cfg")
	upload_date_txt.get_upload_txt_url()
	home_page.home_save()
	upload_date_txt.update_leancloud()
	Game.back_to_title()
	
