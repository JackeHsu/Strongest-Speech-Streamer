extends Control
@onready var ui: Control = $"../ui"
@onready var ui_2: Control = $"."
@onready var start: LineEdit = $VBoxContainer/start
@onready var label: Label = $VBoxContainer/Label




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.hide()
	var file1_path := "user://player_data/player_inform.cfg"
	if !FileAccess.file_exists(file1_path):
		ui_2.show()
		ui.hide()
	else:
		ui.show()
		ui_2.hide()
		load_game()


func _on_start_2_pressed() -> void:
	if start.text != "":
		ui_2.hide()
		ui.show()
		start_game()

		global.player_name = start.text
	else:
		label.show()
		


func _on_quit_pressed() -> void:
	get_tree().quit()

func start_game():
	var dir = DirAccess.open("user://") # 创建文件夹
	if !dir.dir_exists("user://player_data"):
		dir.make_dir("player_data")
		var file = FileAccess.open("user://player_data/player_data.txt", FileAccess.WRITE)
		file.store_line("未进行演讲")
		file.close()
		var file2 = FileAccess.open("user://player_data/player_data2.txt", FileAccess.WRITE)
		file2.store_line("时长记录")
		file2.close()
		# 保存游戏
		var config = ConfigFile.new()
		# 名字
		config.set_value("Settings", "name", start.text)
		var err = config.save("user://player_data/player_inform.cfg")
		if err != OK:
			print("保存失败，错误码：", err)
		else:
			print("保存成功")
		

func load_game():
	var config = ConfigFile.new()
	var result = config.load("user://player_data/player_inform.cfg")
	if result == OK: # 加载存档
		global.player_name = config.get_value("Settings", "name")
	# 创建一个用于储存数据的文件
