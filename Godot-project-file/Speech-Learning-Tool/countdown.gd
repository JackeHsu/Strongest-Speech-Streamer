extends Label

@export var countdown_time: int = 60  # 总秒数
var cur_time: int
var timer_running: bool = false
var finished_once: bool = false  # 是否演讲结束过
@onready var rich_text_label_2: Label = $"."
@onready var start_speech: Button = $".."

@onready var timer: Timer = $Timer  # Label 节点下的 Timer 节点

func _ready() -> void:
	rich_text_label_2.hide()
	cur_time = countdown_time
	text = str(cur_time) + " 秒"
	timer.one_shot = false
	timer.wait_time = 1.0
	timer.stop()
	start_speech.text = "开始演讲"
	

func start_timer():
	start_speech.text = "结束演讲"
	rich_text_label_2.show()
	if cur_time <= 0:
		cur_time = countdown_time
	update_label()
	timer.start()
	timer_running = true
	finished_once = false
	
	var time_string = Time.get_datetime_string_from_system()
	var file = FileAccess.open("user://player_data/player_data.txt", FileAccess.READ_WRITE)
	file.seek_end()
	file.store_line("开始演讲时间：" + time_string)
	file.close() # 关闭文件

func stop_timer():
	rich_text_label_2.hide()
	start_speech.text = "下一次演讲"
	timer.stop()
	timer_running = false
	finished_once = true

func update_label():
	text ="倒计时：" +  str(cur_time) + " 秒"

	if cur_time <= 0:
		timer.stop()
		timer_running = false
		_on_timer_finished()

func _on_timer_finished():
	print("倒计时结束！")
	stop_timer()  # 倒计时结束时自动进入“下一次演讲”状态


func _on_timer_timeout() -> void:
	cur_time -= 1
	update_label()
	if cur_time == 0:
		_on_timer_finished()

func reset_timer():
	cur_time = countdown_time
	update_label()

func _on_start_speech_pressed() -> void:
	if not timer_running and not finished_once:
		# 初次开始
		start_timer()
	elif timer_running:
		# 正在计时 -> 提前结束
		stop_timer()
	elif not timer_running and finished_once:
		# “下一次演讲” -> 重置并开始
		reset_timer()
		start_timer()



func _on_speech_tip_close_2_pressed() -> void:
	if timer_running:
		# 正在计时 -> 提前结束
		stop_timer()
		start_speech.text = "开始演讲"
