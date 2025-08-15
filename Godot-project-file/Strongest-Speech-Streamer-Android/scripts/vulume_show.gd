extends Node2D

@onready var volume_bar: TextureProgressBar = $volume_bar2
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


var record_bus_index: int
var samples = []
var is_caputer = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.is_record_caputer.connect(captuer_start)
	global.stop_record_caputer.connect(captuer_stop)
	var device = AudioServer.get_input_device_list()
	print(device)
	init_mic()

func init_mic():
	record_bus_index = AudioServer.get_bus_index("Capture")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var audio_capture = AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0)
	var linear_sample = db_to_linear(audio_capture)
	samples.push_front(linear_sample)
	
	if samples.size() > 20:
		samples.pop_back()
	
	#volume_bar.value = linear_sample
	volume_bar.value = average_sample_strength()
	

func average_sample_strength() -> float:
	var avg = 0.0
	for i in range(samples.size()):
		avg += samples[i]
	avg /= samples.size()
	return avg

func captuer_start():
	audio_stream_player.play()
	print("开始捕获")
	is_caputer = true
	
func captuer_stop():
	audio_stream_player.stop()
	print("停止捕获")
	is_caputer = false

func _on_audio_stream_player_finished() -> void:
	print("中断")
	if is_caputer == true:
		audio_stream_player.play()
