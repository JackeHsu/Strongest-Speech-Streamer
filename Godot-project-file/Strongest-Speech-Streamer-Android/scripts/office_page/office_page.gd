extends Node2D

@onready var background: TextureRect = $background
@onready var main: Control = $Main
@onready var v_box_container: VBoxContainer = $VBoxContainer # 结算界面
@onready var advice: RichTextLabel = $Advice # 建议界面
@onready var start_speech: Button = $start_speech # 准备完成
@onready var judge_talk: Node2D = $judge_talk
@onready var speech: Label = $judge_talk/speech
@onready var timer: Timer = $judge_talk/Timer
@onready var submit: Button = $Submit
@onready var tasks_text: Task
@onready var task_panel: RichTextLabel = $Task_panel # 任务简述
@onready var fail_back: Button = $fail_back
@onready var npc_panel: TextureRect = $npc_panel
@onready var npc_speech: RichTextLabel = $npc_panel/speech # 任务提示
@onready var uploading_file: Label = $uploading_file # 上传文件提示





var npc1 = preload("res://assets/npc/npc_1.png")
var npc2 = preload("res://assets/npc/npc_2.png")


var judge_is_finished = false # 评委讲完话
var judge_dialogue_count = 0
var judge_dialogue = [
	{text = "你的表现很棒！"},
	{text = "现在我们需要收集直播数据。"},
	{text = "过会儿会将反馈内容告诉你。"},
	{text = "你可以先休息一下！"},
]

var scene_1 = preload("res://assets/background/working.png")
var scene_2 = preload("res://assets/background/meeting.png")

# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	randomize()
	task_panel.hide()
	fail_back.hide()
	npc_panel.hide()
	uploading_file.hide()
	tasks_text = preload("res://scripts/office_page/task.gd").new()
	judge_is_finished = false # 初始化状态
	global.file_update_finished = false # 初始化状态
	judge_talk.hide()
	submit.hide()
	background.texture = scene_1
	v_box_container.hide()
	advice.hide()
	Dialogic.timeline_ended.connect(button_show)
	global.speech_finish.connect(judge_talk_show)
	global.file_update_success.connect(back_to_work) # 文件上传成功的返回按钮
	global.file_change_failed.connect(back_to_work_failed) # 文件转化失败的返回按钮
	global.file_update_failed.connect(back_to_work_failed) # 文件上传失败的返回按钮
	#randomize()
	main.hide()
	start_speech.hide()
	
	if global.first_work == true:
		background.texture = scene_1
		Dialogic.start("first_into_office") # 第一次上班
		npc_panel.texture = npc1
		npc_speech.text = "你需要向别人讲解题目的解法，请根据[color=#FF0000]左边的题目[/color]，准备一份[color=#FF0000]演讲稿[/color],演讲时间最长为[color=#FF0000]60秒[/color]。"
		var task_list = tasks_text.task_levels[0]
		task_panel.text = task_list[0].text

		global.tasks_index[0] = 1
		global.first_work = false
	else:
		select_scene()

var perf_history = []  # 放在 global 或本节点作为成员变量

func difficulty_adaptive() -> int: # 返回 1~5 的难度等级
	# ===== 1. 获取玩家核心表现数据 =====
	var level_factor = clamp(float(global.player_level) / 10.0, 0.0, 1.0)
	var speech_factor = clamp(float(global.speech_score) / 100.0, 0.0, 1.0)
	var energy_factor = clamp(float(global.player_energy) / float(global.player_max_energy), 0.0, 1.0)
	var clothes_factor = clamp(float(global.clothes_score) / 100.0, 0.0, 1.0)

	# ===== 2. 计算综合表现分（0~1） =====
	var performance = (level_factor * 0.2) + (speech_factor * 0.45) + (energy_factor * 0.15) + (clothes_factor * 0.2)

	# ===== 3. 平滑机制 =====
	perf_history.append(performance)
	if perf_history.size() > 5:
		perf_history.pop_front()

	var avg_perf = 0.0
	if perf_history.size() > 0:
		var total = 0.0
		for p in perf_history:
			total += p
		
		avg_perf = total / perf_history.size()
	else:
		avg_perf = performance  # perf_history 为空时，用当前值作为平均值

	# ===== 4. 映射到难度等级 1~5 =====
	var difficulty = 1
	if avg_perf >= 0.8:
		difficulty = 5
	elif avg_perf >= 0.6:
		difficulty = 4
	elif avg_perf >= 0.4:
		difficulty = 3
	elif avg_perf >= 0.2:
		difficulty = 2
	else:
		difficulty = 1

	return difficulty


func select_scene():
	var rand_type = randi() % 2 # 用于确认是会议类型还是任务类型
	var rand_npc = randi() % 2 # 用于确认是哪位NPC
	var rand_talk = randi_range(0, 2) # 用于确认是哪段对话
	
	var difficulty = difficulty_adaptive() - 1
	
	if rand_type == 0: # 任务类型
		#background.texture = scene_1
		npc_speech.text = "你需要向别人讲解题目的解法，请根据[color=#FF0000]左边的题目[/color]，准备一份[color=#FF0000]演讲稿[/color],演讲时间最长为[color=#FF0000]60秒[/color]。"
		var task_list = tasks_text.task_levels[difficulty]
		var idx = global.tasks_index[difficulty]
		var next_idx = (idx + 1) % task_list.size()
		task_panel.text = task_list[next_idx - 1].text
		global.tasks_index[difficulty] = next_idx
		
		
		if rand_npc == 0: # npc_1
			npc_panel.texture = npc1
			if rand_talk == 0: # 第一段对话
				Dialogic.start("task_allocation")
			elif rand_talk == 1: # 第二段对话
				Dialogic.start("task_allocation_2")
			elif rand_talk == 2: # 第三段对话
				Dialogic.start("task_allocation_3")
		else: # npc_2
			npc_panel.texture = npc2
			if rand_talk == 0: # 第一段对话
				Dialogic.start("2_task_allocation")
			elif rand_talk == 1: # 第二段对话
				Dialogic.start("2_task_allocation_2")
			elif rand_talk == 2: # 第三段对话
				Dialogic.start("2_task_allocation_3")
	else: # 会议类型
		#background.texture = scene_2
		npc_speech.text = "你需要根据[color=#FF0000]左边的主题[/color]准备好[color=#FF0000]一份演讲稿[/color]，演讲时间最长为[color=#FF0000]60秒[/color]。"
		var meetings_list = tasks_text.meeting_levels[difficulty]
		var idx = global.meeting_index[difficulty]
		var next_idx = (idx + 1) % meetings_list.size()
		task_panel.text = meetings_list[next_idx - 1].text
		global.meeting_index[difficulty] = next_idx
		
		
		if rand_npc == 0: # npc_1
			npc_panel.texture = npc1
			if rand_talk == 0: # 第一段对话
				Dialogic.start("meeting_report")
			elif rand_talk == 1: # 第二段对话
				Dialogic.start("meeting_report_2")
			elif rand_talk == 2: # 第三段对话
				Dialogic.start("meeting_report_3")
		else: # npc_2
			npc_panel.texture = npc2
			if rand_talk == 0: # 第一段对话
				Dialogic.start("2_meeting_report")
			elif rand_talk == 1: # 第二段对话
				Dialogic.start("2_meeting_report_2")
			elif rand_talk == 2: # 第三段对话
				Dialogic.start("2_meeting_report_3")

			
	
func button_show():
	start_speech.show()
	task_panel.show()
	npc_panel.show()


func _on_continue_pressed() -> void: # 返回主页面
	Game.change_scene("res://scenes/main_page.tscn")


func _on_start_speech_pressed() -> void:
	background.texture = scene_2
	start_speech.hide()
	task_panel.hide()
	npc_panel.hide()
	main.show()

func judge_talk_show(): # 演讲结束后的专家讲话
	judge_talk.show()
	main.hide()
	var dialog = judge_dialogue[judge_dialogue_count]
	speech.text = dialog.text
	judge_dialogue_count += 1
	timer.start()

func _on_timer_timeout() -> void:
	if judge_dialogue_count <= 3:
		judge_talk_show()
	else:
		timer.stop()
		judge_talk.hide()
		judge_is_finished = true
		judge_dialogue_count = 0
		#if global.file_update_finished:
			#back_to_work()
		back_to_work()


func back_to_work(): # 回去工作
	if global.file_update_finished and judge_is_finished:
		submit.show()
		uploading_file.hide()
	if judge_is_finished and !global.file_update_finished:
		uploading_file.show()

func back_to_work_failed(): # 文件上传败的回去工作按钮
	fail_back.show()
