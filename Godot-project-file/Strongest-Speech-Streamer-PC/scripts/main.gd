extends Control

@onready var ask_question: HTTPRequest = $AskQuestion
@onready var create_dialog: HTTPRequest = $CreateDialog
@onready var v_box_container: VBoxContainer = $"../VBoxContainer"
@onready var main_score: Label = $"../VBoxContainer/main_score"
@onready var main: Control = $"."
@onready var advice: RichTextLabel = $"../Advice"
@onready var clothes_score: Label = $"../VBoxContainer/clothes_score"
@onready var energy_score: Label = $"../VBoxContainer/energy_score"
@onready var exp_and_gold: Label = $"../VBoxContainer/exp_and_gold"
@onready var working: AnimatedSprite2D = $"../working"
@onready var working_wav: AudioStreamPlayer = $"../working/working_wav"
@onready var office_page: Node2D = $".."
@onready var background: TextureRect = $"../background"
@onready var submit: Button = $"../Submit"
@onready var fail_back: Button = $"../fail_back"
@onready var total_score: Label = $"../VBoxContainer/total_score"



var scene_1 = preload("res://assets/background/working.png")

var suggestion # 建议
var con_id: String # 创建对话ID

func _ready() -> void:
	working.hide()
	create()
	
# 大模型API请求建立
func create():
	
	var url := "https://qianfan.baidubce.com/v2/app/conversation"
	var body := {
		"app_id": "84cfccc6-3680-4ba2-8229-1f8d59421ec9"
	}
	var headers := [
		'Content-Type: application/json',
		'X-Appbuilder-Authorization: Bearer bce-v3/ALTAK-3xBNpTtwlGXNUAa8QZ0hX/d241777dfe2fe073966e2bce5ae29dec29daa13b'
	]
	#建立API请求
	create_dialog.request(url, headers, HTTPClient.METHOD_POST, JSON.new().stringify(body))


func _on_create_dialog_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	con_id = json.data['conversation_id']
	
# 大模型API问答请求
func ask(question: String):
	var url := 'https://qianfan.baidubce.com/v2/app/conversation/runs'
	var body := {
		"app_id": "84cfccc6-3680-4ba2-8229-1f8d59421ec9",
		"query": question,
		"conversation_id": con_id,
		"stream": false
	}
	var headers := [
		'Content-Type: application/json',
		'X-Appbuilder-Authorization: Bearer bce-v3/ALTAK-3xBNpTtwlGXNUAa8QZ0hX/d241777dfe2fe073966e2bce5ae29dec29daa13b'
	]
	ask_question.request(url, headers, HTTPClient.METHOD_POST, JSON.new().stringify(body))

func _on_ask_question_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	var score
	if !'answer' in json.data:
		print("AI调用失败")
		score = "60"
		advice.text = "抱歉！AI还在处理其他工作！请稍后再试一次！"
		calculation_score(score)
		save_player_data(score, advice.text)
	else:
		print("answer: %s" % [json.data['answer']])
		var text = json.data['answer']
		var start_index = text.find("总分：")
		var end_index = text.find("\n", start_index)
	
		if start_index != -1 and end_index != -1:
			var score_text = text.substr(start_index, end_index - start_index)
			score = score_text.split("：", false)[1].strip_edges()  # 去除前后空格
			calculation_score(score)

		else:
			print("文本中没有找到 '总分：'")
			score = "0分"
			calculation_score(score)
		
		var suggestion_start = text.find("建议：")
		var suggestion_end = text.length()
		if suggestion_start != -1:
			var suggestion_text = text.substr(suggestion_start + "建议：".length(), suggestion_end - (suggestion_start + "建议：".length()))
			print(suggestion_text)  # 这将打印出建议部分的文本
			advice.text = suggestion_text
		else:
			print("文本中没有找到 '建议：'")
			advice.text = "没有识别出来！请稍后重试一次！"
			
		save_player_data(score, advice.text)
		
func calculation_score(score):
	var player_exp
	var player_gold
	main_score.text = "演讲得分：" + score
	clothes_score.text = "服装得分：" + str(global.clothes_score) + "分"
	energy_score.text = "状态得分：" + str(global.energy_score) + "分"
	global.player_total_score += int(int(score) * 0.6 + global.clothes_score * 0.2 + global.energy_score * 0.2)
	total_score.text = "总共得分：" + str(global.player_total_score) + "分"
	global.speech_score = int(score)
	if global.speech_score <= 50 && global.speech_score > 0:
		global.office_situation -= 1
	elif global.speech_score == 0:
		global.office_situation -= 2
	elif global.speech_score > 50 && global.speech_score < 90:
		global.office_situation += 1
	elif global.speech_score >= 90:
		global.office_situation += 2
	player_exp = int((global.speech_score * 0.6 + global.clothes_score * 0.2 + global.energy_score * 0.2) * (global.high_exp * global.exp_buff))
	player_gold = int(5 * (global.speech_score * 0.6 + global.clothes_score * 0.2 + global.energy_score * 0.2) * (global.high_gold * global.gold_buff))
	global.player_exp += player_exp
	global.player_gold += player_gold
	exp_and_gold.text = "经验值：" + str(	player_exp) + "金币：" + str(player_gold)
	v_box_container.show()
	working.hide()
	working_wav.stop()

	
func _on_advice_pressed() -> void: # 显示建议
	advice.visible = !advice.visible


func _on_submit_pressed() -> void:
	ask("https://jackehsu.oss-cn-beijing.aliyuncs.com/" + global.player_name + ".wav")
	background.texture = scene_1
	submit.hide()
	working.show()
	working_wav.play()


func _on_fail_back_pressed() -> void:
	background.texture = scene_1
	fail_back.hide()
	advice.text = "没有识别出来！请稍后重试一次！"
	var score = "0"
	calculation_score(score)
	save_player_data(score, advice.text)
	
	
func save_player_data(score, advice):
	var time_string = Time.get_datetime_string_from_system()
	var file = FileAccess.open("user://player_data/player_data.dat", FileAccess.READ_WRITE)
	file.seek_end()
	file.store_string("时间：" + time_string + "||")
	file.store_string("分数:" + score + "||")
	file.store_line("建议：" + advice + "||")
	file.close() # 关闭文件


func _on_texture_button_pressed() -> void:
	advice.visible = !advice.visible
