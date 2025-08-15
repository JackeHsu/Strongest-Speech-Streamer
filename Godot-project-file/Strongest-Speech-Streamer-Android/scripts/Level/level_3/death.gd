extends Area2D
@onready var timer: Timer = $Timer # 一段时间后重启游戏
@onready var player: CharacterBody2D = $"../player"
@onready var player_hp_text: Label = $"../CanvasLayer/HBoxContainer/player_hp"

var player_cur_postion_x

func _ready() -> void:
	player_hp_text.text = "X" + str(player.hp)
func _on_body_entered(body: Node2D) -> void:
	timer.start()
	player_cur_postion_x = player.global_position.x - 30
func _on_timer_timeout() -> void:
	timer.stop()
	player.hp -= 1
	player_hp_text.text = "X" + str(player.hp)
	if player.hp <= 0:
		player.game_over_sig.emit()
	else:
		player.waste_sig.emit()
	player.global_position.x = player_cur_postion_x
	player.global_position.y = 85
