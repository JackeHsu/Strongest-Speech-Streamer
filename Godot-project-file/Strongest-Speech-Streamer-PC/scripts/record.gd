extends Node2D

@onready var record_button: Button = $record_button
@onready var upload_recording = $upload_recording
@onready var count_down: Label = $"../Timer/count_down"
@onready var timer: Timer = $"../Timer"
@onready var texture_progress_bar: TextureProgressBar = $"../Timer/TextureProgressBar"
@onready var float_tips: Node2D = $"../../float_tips"


signal stop_speech

var drop_time = 60 # 演讲时长限制
var cur_time: int

var record_bus_index: int
var record_effect: AudioEffectRecord
var recording: AudioStream

var progressbar_1 = preload("res://assets/volume_bar_3.png") # 绿色
var progressbar_2 = preload("res://assets/volume_bar_4.png") # 黄色
var progressbar_3 = preload("res://assets/volume_bar_5.png") # 红色

func _ready() -> void:
	float_tips.hide()
	stop_speech.connect(upload_speech)
	cur_time = drop_time # 设计倒计时
	count_down.text = "倒计时：" + str(drop_time)
	texture_progress_bar.value = drop_time
	count_down.hide()
	texture_progress_bar.hide()
	record_bus_index = AudioServer.get_bus_index("Record")
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)

	

func start_recording() -> void:
	record_effect.set_recording_active(true)
	record_button.text = '结束演讲'
	timer.start()
	float_tips.show()
	count_down.show()
	texture_progress_bar.show()

func stop_recording() -> void:
	float_tips.hide()
	record_effect.set_recording_active(false)
	record_button.text = '开始演讲'
	recording = record_effect.get_recording()
	stop_speech.emit()
	timer.stop()
	count_down.hide()
	texture_progress_bar.hide()
	cur_time = drop_time
	count_down.text = "倒计时：" + str(cur_time)
	texture_progress_bar.value = cur_time
	global.speech_finish.emit()

	
func _on_record_button_pressed() -> void:
	if record_effect.is_recording_active():
		stop_recording()

	else:
		start_recording()


func upload_speech(): # 上传录音到oss
	if !recording:
		return
	else:
		var dir = DirAccess.open("user://") # 创建文件夹
		if !dir.dir_exists("user://my_recording"):
			dir.make_dir("my_recording")
		recording.save_to_wav('user://my_recording/my_recording' + str(global.player_recording_count) + '.wav')
		audio_conversion()
		upload_recording.upload_recording()


#func _on_save_button_pressed() -> void:
	#if !recording:
		#return

	#recording.save_to_wav('user://my_recording.wav')
	#audio_conversion()
	#upload_wav()
	#upload_recording.upload_recording()

func get_ffmpeg_path() -> String: # 导出时调用此函数
	
	# 获取游戏可执行文件的路径，并指向 ffmpeg.exe
	var exe_dir = OS.get_executable_path().get_base_dir()
	print(exe_dir)
	return exe_dir + "/bin/ffmpeg.exe"


func audio_conversion() -> void:
	#检测路径下是否存在output_mono.wav
	var dir = DirAccess.open("user://")
	var file_path = OS.get_user_data_dir()
	#print(file_path)
	if dir.file_exists("output_mono.wav"):
		dir.remove("output_mono.wav")
	
	var ffmpeg_path
	if OS.has_feature("editor"): 
		# 在 Godot 编辑器里运行（调试）
		ffmpeg_path = ProjectSettings.globalize_path("res://bin/ffmpeg.exe")
	else:
		# 导出版本运行（发布）
		ffmpeg_path = get_ffmpeg_path()

	print("当前 ffmpeg 路径：", ffmpeg_path)

	var input_audio = file_path + "/my_recording/my_recording" + str(global.player_recording_count) + ".wav"
	var output_audio = file_path + "/output_mono.wav"
	#print(input_audio)
	var arguments = ["-i", input_audio, "-ac", "1", "-ar", "48000", output_audio]
	var output = []
	var result = OS.execute(ffmpeg_path, arguments, output, true)
	if result == OK:
		print("FFmpeg command executed successfully!")
		global.player_recording_count += 1
	else:
		print("Failed to execute FFmpeg command.")
		global.player_recording_count += 1
		global.file_change_failed.emit()
	


func _on_timer_timeout() -> void:
	cur_time -= 1
	count_down.text = "倒计时：" + str(cur_time)
	texture_progress_bar.value -= 0.01
	if cur_time <= 10:
		count_down.add_theme_color_override("font_color", Color(1, 0, 0))
		texture_progress_bar.texture_progress = progressbar_3
	elif cur_time > 10 and cur_time <= 30:
		texture_progress_bar.texture_progress = progressbar_2
	elif cur_time > 30 and cur_time <= 60:
		texture_progress_bar.texture_progress = progressbar_1
	if cur_time == 0:
		stop_recording()
