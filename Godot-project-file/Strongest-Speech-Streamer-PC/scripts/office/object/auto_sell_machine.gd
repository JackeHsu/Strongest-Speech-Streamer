extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shop_ui: Control = $"../../shop_ui"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var popup_location: Marker2D = $"../../PopupLocation" # 上班提示


func _on_control_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		#print("点击")
		shop_ui.show()
		popup_location.hide()
		audio_stream_player_2d.play()


func _on_control_mouse_entered() -> void:
	if !get_tree().paused:
		sprite_2d.material.set_shader_parameter("outline_width", 2)


func _on_control_mouse_exited() -> void:
	sprite_2d.material.set_shader_parameter("outline_width", 0)
