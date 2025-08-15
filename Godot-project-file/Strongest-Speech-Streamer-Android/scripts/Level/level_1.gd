extends Node2D

@onready var background: TextureRect = $background
@onready var volume_bar_2: TextureProgressBar = $vulume_show/volume_bar2
@onready var label: Label = $tips/Label
@onready var count_down: Label = $Timer/count_down
@onready var timer: Timer = $Timer
@onready var start: Button = $start
@onready var continue_button: Button = $continue
@onready var summary: VBoxContainer = $summary
@onready var speak_score: Label = $summary/speak_score
@onready var exp_and_gold: Label = $summary/exp_and_gold


var vulume_score = 0 # 得分
var start_speak = false

var drop_time = 15 # 时长限制
var cur_time: int

var park_1 = preload("res://assets/background/park/park_1.png")
var park_2 = preload("res://assets/background/park/park_2.png")
var park_3 = preload("res://assets/background/park/park_3.png")
var park_4 = preload("res://assets/background/park/park_4.png")

func _ready() -> void:
	global.player_energy -= 40
	Dialogic.start("start_level_1")
	summary.hide() # 总结
	label.hide() # 提示音量过大过小
	continue_button.hide() # 继续按钮
	cur_time = drop_time # 设计倒计时
	count_down.text = "倒计时：" + str(drop_time)
	count_down.hide()

func _process(delta: float) -> void:
	if start_speak == true:
		update_background()

func update_background():
	if volume_bar_2.value >= 0 && volume_bar_2.value < 0.05:
		label.text = ""
	elif volume_bar_2.value >= 0.05 && volume_bar_2.value < 0.25:
		background.texture = park_1
		vulume_score -= 1
		if vulume_score <= 0:
			vulume_score = 0
		label.text = "太小了！"
		label.add_theme_color_override("font_color", Color(1, 0, 0))
	elif volume_bar_2.value >= 0.25 && volume_bar_2.value < 0.5:
		background.texture = park_2
		vulume_score += 5
		label.text = "合适"
		label.add_theme_color_override("font_color", Color(0, 1, 0))
	elif volume_bar_2.value >= 0.5 && volume_bar_2.value < 0.75:
		background.texture = park_3
		vulume_score += 5
		label.text = "合适"
		label.add_theme_color_override("font_color", Color(0, 1, 0))
	elif volume_bar_2.value >= 0.75 && volume_bar_2.value < 1:
		background.texture = park_4
		vulume_score -= 1
		if vulume_score <= 0:
			vulume_score = 0
		label.text = "太大了！"
		label.add_theme_color_override("font_color", Color(1, 0, 0))
		


func _on_timer_timeout() -> void:
	cur_time -= 1
	count_down.text = "倒计时：" + str(cur_time)
	if cur_time <= 5:
		count_down.add_theme_color_override("font_color", Color(1, 0, 0))
	if cur_time == 0: # 倒计时结束
		#print("结束")
		label.text = "结束了！"
		label.add_theme_color_override("font_color", Color(1, 1, 1))
		timer.stop()
		count_down.hide()
		cur_time = drop_time
		count_down.text = "倒计时：" + str(cur_time)
		continue_button.show() # 展示继续按钮返回主页面
		#print(vulume_score) # 得分
		start_speak = false # 说话结束
		speak_score.text = "得分：" + str(vulume_score / 30)
		calculation_score()
		global.stop_record_caputer.emit()
		summary.show()
		

func calculation_score():
	var player_exp
	var player_gold
	global.player_total_score += int(vulume_score / 150)
	player_exp = int(vulume_score / 30 * (global.high_exp * global.exp_buff))
	player_gold = int(vulume_score / 30 * (global.high_gold * global.gold_buff) * 2.5)
	global.player_exp += player_exp
	global.player_gold += player_gold
	exp_and_gold.text = "经验值：" + str(	player_exp) + "金币：" + str(player_gold)

func _on_start_pressed() -> void:
	timer.start()
	count_down.show()
	start.hide()
	label.show()
	start_speak = true
	global.is_record_caputer.emit() #开始捕获
	

func _on_continue_pressed() -> void:
	Game.change_scene("res://scenes/home_page.tscn")
