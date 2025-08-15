extends Area2D

@onready var player: CharacterBody2D = $"../../player"
@onready var player_hp_text: Label = $"../../CanvasLayer/HBoxContainer/player_hp"
@onready var audio_stream_player: AudioStreamPlayer = $"../../player/AudioStreamPlayer"


func _on_body_entered(body: Node2D) -> void:
	player.hp += 1
	player_hp_text.text = "X" + str(player.hp)
	audio_stream_player.play()
	queue_free()
