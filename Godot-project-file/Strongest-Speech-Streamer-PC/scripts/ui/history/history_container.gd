extends MarginContainer


@onready var record_gird: GridContainer = $record_gird
@onready var advice: RichTextLabel = $Advice



const Record = preload("res://scenes/ui/history_record.tscn")


func _ready() -> void:
	var file_path := "user://player_data/player_data.dat"
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var j = 0 # 计数器
		for i in record_gird.get_children():
			i.queue_free()
		
		print("文件存在且成功打开")
		var content = file.get_as_text()  # 读取文件的全部内容
		file.close()  # 不要忘记关闭文件
		
		# 按 "||" 分割内容
		var records = content.split("||")
		
		for i in range(0, records.size(), 3):
			if i + 2 >= records.size():
				#print("警告：格式不正确的记录")
				continue  # 跳过格式不正确的记录
			
			var time = records[i].replace("时间：", "").strip_edges()
			var score = records[i + 1].replace("分数:", "").strip_edges().to_int()
			var suggestion = records[i + 2].replace("建议：", "").strip_edges()
			
			#print("时间：", time)
			#print("分数：", score)
			#print("建议：", suggestion)
			#print("")  # 打印一个空行分隔每条记录
			
			var record = Record.instantiate()
			j += 1 # 第几条记录
			record.text = "第" + str(j) + "条"
			var advice = record.get_child(0)
			advice.text ="第" + str(j) + "条" + '\n' + "时间：" + time + '\n' +"分数：" + str(score) + '\n' + "建议：" + suggestion
			record_gird.add_child(record)
			
	else:
		print("文件不存在或无法打开")


func _on_close_advice_buttton_pressed() -> void:
	advice.hide()
