extends MarginContainer


@onready var record_gird: GridContainer = $record_gird
@onready var advice: RichTextLabel = $Advice
@onready var start_speech: Button = $"../../start_speech"


const Record = preload("res://history_record.tscn")


func _ready() -> void:
	var tasks_text_script = preload("res://task.gd")
	var tasks_text = tasks_text_script.new()
	
	var all_questions = tasks_text.tasks + tasks_text.meetings
	
	# 清空 record_gird 中的子节点
	for child in record_gird.get_children():
		child.queue_free()
	
	# 遍历所有任务
	for i in range(all_questions.size()):
		var question_data = all_questions[i]
		
		# 创建记录节点
		var record = Record.instantiate()
		record.text = "第" + str(i + 1) + "题"
		
		# 给 Record 节点添加点击事件，显示题目
		var advice_label = record.get_child(0)  # 假设第0个是显示题目的 RichTextLabel
		advice_label.text = question_data.text
		
		record_gird.add_child(record)

func _on_advice_close_pressed() -> void:
	advice.hide()
	
