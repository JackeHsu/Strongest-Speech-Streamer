extends Control

@onready var bag: Label = $HBoxContainer/bag
@onready var bag_ui2: Control = $"../Bag/ui_interface/bag"
@onready var bag_ui1: CanvasLayer = $"../Bag"
@onready var rank: Label = $rank
@onready var player_rank: Control = $"../PlayerRank"




func _on_bag_mouse_entered() -> void:
	bag.material.set_shader_parameter("outline_width", 1)


func _on_bag_mouse_exited() -> void:
	bag.material.set_shader_parameter("outline_width", 0)


func _on_bag_gui_input(event: InputEvent) -> void: # 打开背包
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#print("鼠标左键按下")
			bag_ui2.show()
			bag_ui1.show()
			


func _on_rank_mouse_entered() -> void:
	rank.material.set_shader_parameter("outline_width", 1)


func _on_rank_mouse_exited() -> void:
	rank.material.set_shader_parameter("outline_width", 0)


func _on_rank_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#print("鼠标左键按下")
			player_rank.show()
			player_rank.show_result()
