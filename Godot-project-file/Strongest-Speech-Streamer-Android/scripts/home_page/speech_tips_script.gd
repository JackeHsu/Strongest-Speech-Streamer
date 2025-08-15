extends MarginContainer


@onready var record_gird: GridContainer = $record_gird
@onready var advice: RichTextLabel = $Advice
@onready var Class: Button = $Advice/Class



const Record = preload("res://scenes/ui/history_record.tscn")


func _ready() -> void:
	var speech_tips_script = load("res://scripts/speech_tips.gd")  # 确保路径正确
	var speech_tips = speech_tips_script.new()  # 创建一个实例

	# 清空record_gird中的子节点
	for i in record_gird.get_children():
		i.queue_free()
		
	var j = 0  # 计数器
	for i in range(0, speech_tips.tips.size(), 4):
		if i + 3 >= speech_tips.tips.size():
			print("警告：格式不正确的记录，跳过")
			continue  # 跳过格式不正确的记录
			
		var record_name = speech_tips.tips[i].replace("名称：", "").strip_edges()
		var record_type = speech_tips.tips[i + 1].replace("类型：", "").strip_edges()
		var record_suggestion = speech_tips.tips[i + 2].replace("建议：", "").strip_edges()
		var record_url = speech_tips.tips[i + 3].strip_edges()
		
		# 创建记录节点
		var record = Record.instantiate()
		j += 1  # 第几条记录
		record.text = "第" + str(j) + "条"
		var url = record.get_child(1)
		url.text = record_url
		var advice = record.get_child(0)
		advice.text = "第" + str(j) + "条" + '\n' + "名称：" + record_name + '\n' + "类型：" + record_type + '\n' + "建议：" + record_suggestion
		record_gird.add_child(record)

func _on_advice_close_pressed() -> void:
	advice.hide()


func _on_class_pressed() -> void:
	OS.shell_open(global.current_class_url)
