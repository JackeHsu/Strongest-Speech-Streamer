extends Control

@onready var panel_container_4: PanelContainer = $"../PanelContainer4"
@onready var ui: Control = $"."
@onready var panel_container_5: PanelContainer = $"../PanelContainer5"
@onready var rich_text_label: RichTextLabel = $"../RichTextLabel"
@onready var start_speech: Button = $"../start_speech"


func _ready() -> void:
	panel_container_4.hide()
	panel_container_5.hide()
	rich_text_label.hide()
	start_speech.hide()
	
	
func _on_start_pressed() -> void:
	panel_container_4.show()
	ui.hide()
	
	# 记录开始学习时间点
	var file_path = "user://player_data/player_data2.txt"
	
	if FileAccess.file_exists(file_path):
		var time_string = Time.get_datetime_string_from_system()
		var file = FileAccess.open("user://player_data/player_data2.txt", FileAccess.READ_WRITE)
		file.seek_end()
		file.store_line("开始学习时间：" + time_string)
		file.close()

func _on_quit_pressed() -> void:
	# 保存游戏
	var config = ConfigFile.new()
		# 名字
	config.set_value("Settings", "name", global.player_name)
	var err = config.save("user://player_data/player_inform.cfg")
	
	if err == OK:
		print("保存成功，退出游戏")
		get_tree().quit()
	else:
		print("保存失败，错误码：", err)


func _on_speech_tip_close_pressed() -> void:
	panel_container_4.hide()
	ui.show()
	
	var file2_path := "user://player_data/player_data2.txt"

	var time_string = Time.get_datetime_string_from_system()
	var file1 = FileAccess.open("user://player_data/player_data2.txt", FileAccess.READ_WRITE)
	file1.seek_end()
	file1.store_line("结束学习时间：" + time_string)
	file1.close() # 关闭文件


func _on_start_2_pressed() -> void:
	rich_text_label.show()
	panel_container_5.show()
	ui.hide()
	start_speech.show()
	

func _on_speech_tip_close_2_pressed() -> void:
	rich_text_label.hide()
	panel_container_5.hide()
	ui.show()
	start_speech.show()
	start_speech.hide()
