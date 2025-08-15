extends Node2D

func _ready() -> void:
	print("这里是测试场景")


func _on_button_pressed() -> void:
	Game.change_scene("res://scenes/main_page.tscn")
