extends Node

@onready var mic_input: AudioStreamPlayer = $mic_input

var spectrum_analyzer: AudioEffectSpectrumAnalyzerInstance

var fluctuation_count : int = 0  # 记录音量变化次数
var speaking_threshold: float = 0.1  # 语音活动阈值
var last_fluctuation_time: float = 0  # 上次检测到波动的时间
var time_window: float = 1.0  # 每秒检查一次
var prev_volume: float = 0.0  # 上一个音量值

var prev_time : float = 0.0
var word_count : int = 0
var record_bus_index: int
var samples = []

func _ready():
	# 初始化音频捕获效果
	record_bus_index = AudioServer.get_bus_index("Capture")
	spectrum_analyzer = AudioServer.get_bus_effect_instance(record_bus_index, 1)
	
func _process(delta: float) -> void:
	var audio_capture = AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0)
	var linear_sample = db_to_linear(audio_capture)
	samples.push_front(linear_sample)
	
	if samples.size() > 20:
		samples.pop_back()
	
	
	var current_volume = linear_sample
	
	 # 判断音量变化（检测到波动）
	if abs(current_volume - prev_volume) > 0.065 and abs(current_volume - prev_volume) < 0.26:  # 设置一个阈值来判定波动
		#print(abs(current_volume - prev_volume))
	#	print(fluctuation_count)
		fluctuation_count += 1
		prev_volume = current_volume  # 更新上一个音量值
		
	# 计算语速 (WPM)
	var speech_speed = calculate_speech_speed(fluctuation_count)
	global.level_2_player_speed = speech_speed / 2
	
	# 每秒重置 fluctuation_count 进行下一轮语速计算
	if Time.get_ticks_msec() / 1000.0 - prev_time > 0.5:
		prev_time = Time.get_ticks_msec() / 1000.0
		fluctuation_count = 0
		prev_volume = 0
		current_volume = 0

# 计算语速（每分钟波动次数）
func calculate_speech_speed(fluctuation_count: int) -> float:
	# 每秒波动次数转化为每分钟波动次数
	return fluctuation_count * 60.0
	

func average_sample_strength() -> float:
	var avg = 0.0
	for i in range(samples.size()):
		avg += samples[i]
	avg /= samples.size()
	return avg
