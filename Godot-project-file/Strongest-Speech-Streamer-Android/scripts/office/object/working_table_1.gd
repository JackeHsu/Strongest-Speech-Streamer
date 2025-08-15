extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed: # 下班时间不能点击
			if global.player_energy >= 30:
				if global.work_times > 0:
					global.work_times -= 1
					global.ask_for_leave -= 1
					if global.player_energy < 50 && global.player_energy > 40: # 根据体力值，设置状态得分
						global.energy_score = randi_range(6, 20)
					elif global.player_energy <= 40 && global.player_energy >= 30:
						global.energy_score = randi_range(1, 5)
					elif global.player_energy >= 50 && global.player_energy < 75:
						global.energy_score = randi_range(20, 49)
					elif global.player_energy >= 75:
						global.energy_score = randi_range(50, 100)
					elif global.player_energy >= 100:
						global.energy_score = 100
					# 这里会加入一些状态判断，影响得分
					global.player_energy -= 35
					global.office_interior_visible = true # 保留公司室内页面
					Game.change_scene("res://scenes/office_page.tscn")
					print("鼠标左键按下")
				else:
					global.off_duty.emit()
			else:
				global.energy_not_enough.emit()

func _on_control_mouse_entered() -> void:
	if !get_tree().paused:
		sprite_2d.material.set_shader_parameter("outline_width", 2)


func _on_control_mouse_exited() -> void:
	sprite_2d.material.set_shader_parameter("outline_width", 0)
