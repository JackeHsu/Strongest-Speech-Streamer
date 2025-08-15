extends VBoxContainer

@export var current_player_name: LineEdit
@onready var label: Label = $Label
@onready var timer: Timer = $Timer


func _ready() -> void:
	label.hide()

func _on_confirm_pressed() -> void: # 开始游戏确认
	global.player_name = current_player_name.text
	global.new_game = true
	
	if current_player_name.text == "":
		timer.start()
		label.show()
	else:
		start_game()
		global.player_inventory = null
		global.equipment_inventory = null
	
func start_game():
	var dir = DirAccess.open("user://") # 创建文件夹
	if !dir.dir_exists("user://player_data"):
		dir.make_dir("player_data")
	else:
		var dir_2 = DirAccess.open("user://player_data")
		var files = dir_2.get_files()
		for file in files:
			print(file)
			var file_path = "user://player_data" + "/" + file
			dir.remove(file_path)  # 删除文件
	# 创建一个用于储存数据的文件
	var file = FileAccess.open("user://player_data/player_data.dat", FileAccess.WRITE)
	file.store_line("未进行演讲")
	file.close()
	var file2 = FileAccess.open("user://player_data/player_data2.dat", FileAccess.WRITE)
	file2.store_line("游戏在线时长记录")
	file2.close()
	# 保存游戏
	var config = ConfigFile.new()
	# 名字
	config.set_value("Settings", "name", current_player_name.text)
	# 时间
	config.set_value("Time", "time", "daytime") # 设置初始值
	# 经验
	config.set_value("PlayerState", "level", 1) # 设置初始值
	config.set_value("PlayerState", "exp", 0) # 设置初始值
	# 金币
	config.set_value("PlayerState", "gold", 0) # 设置初始值
	# 情况
	config.set_value("PlayerState", "situation", 0) # 设置初始值
	# 称号
	config.set_value("PlayerState", "nickname", "实习生") # 设置初始值
	# 精力
	config.set_value("PlayerState", "energy", 100) # 设置初始值
	#config.set_value("PlayerState", "max_energy", 100) # 设置初始值
	# 总分
	config.set_value("PlayerState", "total_score", 0) # 设置初始值
	# 衣服
	config.set_value("PlayerClothes", "head", 0) # 设置初始值
	config.set_value("PlayerClothes", "clothes", 0) # 设置初始值
	config.set_value("PlayerClothes", "pants", 0) # 设置初始值
	config.set_value("PlayerClothes", "shoes", 0) # 设置初始值
	config.set_value("PlayerClothes", "key", 0) # 设置初始值
	
	# 建筑
	config.set_value("BuildingState", "shop", 0) # 设置初始值
	config.set_value("BuildingState", "office", 0) # 设置初始值
	
	# 是否第一次上班
	config.set_value("FirstIntoOffice", "state", true) # 设置初始值
	config.set_value("FirstIntoHome", "home", true) # 设置初始值
	
	# 当日工作次数
	config.set_value("WorkTimes", "times", 2) # 设置初始值
	
	# 差几回合可以请假
	config.set_value("LeaveTimes", "times", 1) # 设置初始值
	
	# 录音文件计数
	config.set_value("Recording", "count", 0) # 设置初始值
	
	# 任务进度计数
	config.set_value("Task", "tasks", global.tasks_index) # 设置初始值
	config.set_value("Task", "meetings", global.meeting_index) # 设置初始值
	
	# 成就
	config.set_value("Achievement", "achievement", AchiManager.achi_get_situation) # 设置初始值
	config.set_value("Achievement", "toys", AchiManager.toys) # 设置初始值
	config.set_value("Achievement", "keys", AchiManager.keys) # 设置初始值
	
	# 关卡计数
	config.set_value("Level_3", "level_3", 0) # 设置初始值
	
	# 第一次回家
	config.set_value("GoHome", "go_home", false)
	
	# 最后所在场景名称
	config.set_value("SceneName", "scene_name", "start_page")
	
	config.save("user://player_data/player_inform.cfg")
	print("成功保存")
	Game.change_scene("res://scenes/main_page.tscn")


func _on_timer_timeout() -> void:
	label.hide()
