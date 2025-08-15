extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_change_scene)

func _change_scene():
	get_tree().change_scene_to_file("res://scenes/start_page.tscn")
