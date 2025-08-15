extends Node2D


@onready var volume_bar: TextureProgressBar = $volume_bar2
@onready var player: CharacterBody2D = $"../../player"


var is_active = false
var record_bus_index: int
var samples = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 初始化音频捕获效果
	record_bus_index = AudioServer.get_bus_index("Capture")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var audio_capture = AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0)
	var linear_sample = db_to_linear(audio_capture)
	samples.push_front(linear_sample)
	
	if samples.size() > 20:
		samples.pop_back()
	
	volume_bar.value = average_sample_strength()
	var volume = volume_bar.value
	if volume > 0.05 && volume < 0.42 && is_active:
		player.direction = 1

	elif volume >= 0.42 && is_active:
		player.is_jump = true
		player.direction = 1
	else:
		player.direction = 0
func average_sample_strength() -> float:
	var avg = 0.0
	for i in range(samples.size()):
		avg += samples[i]
	avg /= samples.size()
	return avg
