extends Control
class_name GuideUi

@onready var next_step: Label = $next_step

signal player_click

func text_scale(): # 文字缩放效果
	next_step.pivot_offset = next_step.size / 2 # 保证居中缩放
	var tween = create_tween()
	tween.tween_property(next_step, "scale", Vector2(1.2, 1.2), 0.75)
	tween.tween_property(next_step, "scale", Vector2(1.0, 1.0), 0.75)


func _on_timer_timeout() -> void:
	text_scale()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				emit_signal("player_click")
				queue_free()
