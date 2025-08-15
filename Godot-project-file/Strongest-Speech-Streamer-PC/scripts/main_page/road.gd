extends StaticBody2D


@onready var tip: Label = $tip
@onready var level_1_s: Sprite2D = $level_1/level_1_s
@onready var level_2_s: Sprite2D = $level_2/level_2_s
@onready var level_3_s: Sprite2D = $level_3/level_3_s
@onready var label: Label = $level_3/Label

var level_num # 用于统计是点击的哪个牌子

func _ready() -> void:
	level_num = 0 # 重置level_num
	if global.work_times == 0:
		label.text = "回家"
	else:
		label.text = "请假"
	tip.hide()


func _on_confirm_pressed() -> void: # 请假重置exp_buff和gold_buff
	if global.ask_for_leave > 0:
		global.cant_leave.emit()
		tip.hide()
	else:
		global.time = "nighttime"
		global.ask_for_leave = 1
		if global.work_times == 2:
		#global.time = "nighttime"
			global.player_gold -= 1000
			global.office_situation -= 1
			global.player_max_energy += 20
			global.player_energy = global.player_max_energy
			global.exp_buff = 1.2
			global.max_energy_count = 0 # 重置最大体力计数器
			global.buff_sustain_rounds = 2 #重置buff回合计数器
			global.buff_count = 0 
			global.work_times = 0
			global.player_total_score -= 50
		elif global.work_times == 1:
			global.player_gold -= 800
			global.player_energy = global.player_max_energy
			global.exp_buff = 1.2
			global.max_energy_count = 0 # 重置最大体力计数器
			global.buff_sustain_rounds = 1 #重置buff回合计数器
			global.buff_count = 0 
			global.work_times = 0
			global.player_total_score -= 30
		if level_num == 1:
			bag_save()
			Game.change_scene("res://scenes/level_1.tscn")
		elif level_num == 2:
			bag_save()
			Game.change_scene("res://scenes/level_2.tscn")
		elif level_num == 3:
			bag_save()
			Game.change_scene("res://scenes/home_page.tscn")


func _on_cancel_pressed() -> void:
	tip.hide()


func _on_level_1_c_mouse_entered() -> void:
	level_1_s.material.set_shader_parameter("outline_width", 2)


func _on_level_1_c_mouse_exited() -> void:
	level_1_s.material.set_shader_parameter("outline_width", 0)


func _on_level_1_c_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if global.work_times > 0 or global.time == "daytime": # 请假
				tip.show()
				level_num = 1
			else: # 下班回家
				if global.player_energy <= 10:
					global.first_go_home.emit()
				else:
				#global.time = "daytime"
					global.work_times = 0
				#global.player_energy += 100
					if global.player_energy >= global.player_max_energy:
						global.player_energy = global.player_max_energy
					bag_save()
					Game.change_scene("res://scenes/level_1.tscn")


func _on_level_2_c_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if global.work_times > 0 or global.time == "daytime": # 请假
				tip.show()
				level_num = 2
			else: # 下班回家
				if global.player_energy <= 10:
					global.first_go_home.emit()
				else:
					#global.time = "daytime"
					global.work_times = 0
					#global.player_energy += 100
					if global.player_energy >= global.player_max_energy:
						global.player_energy = global.player_max_energy
					bag_save()
					Game.change_scene("res://scenes/level_2.tscn")


func _on_level_2_c_mouse_entered() -> void:
	level_2_s.material.set_shader_parameter("outline_width", 2)


func _on_level_2_c_mouse_exited() -> void:
	level_2_s.material.set_shader_parameter("outline_width", 0)


func _on_level_3_c_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if global.work_times > 0 or global.time == "daytime": # 请假
				tip.show()
				level_num = 3
			else: # 下班回家
				#global.time = "daytime"
				global.work_times = 0
				#global.player_energy += 100
				if global.player_energy >= global.player_max_energy:
					global.player_energy = global.player_max_energy
				bag_save()
				# 回家交通工具扣除体力
				if global.key_index == 0:
					global.player_energy -= 20
				elif global.key_index == 1:
					global.player_energy -= 15
				elif global.key_index == 2:
					global.player_energy -= 10
					
				Game.change_scene("res://scenes/home_page.tscn")


func _on_level_3_c_mouse_entered() -> void:
	level_3_s.material.set_shader_parameter("outline_width", 2)


func _on_level_3_c_mouse_exited() -> void:
	level_3_s.material.set_shader_parameter("outline_width", 0)


func bag_save():
	var data = SceneData.new()
	var boxes = get_tree().get_nodes_in_group("player")
	for box in boxes:
		var box_scene = PackedScene.new()
		box_scene.pack(box)
		data.box_array.append(box_scene)
		
	ResourceSaver.save(data, "user://player_data/bag_data.tres")
	print("saved!")
	
