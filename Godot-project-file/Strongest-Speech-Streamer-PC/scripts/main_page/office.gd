extends StaticBody2D

@onready var office_1: Sprite2D = $office1
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var control: Control = $Control
@onready var office: StaticBody2D = $"."
@onready var office_state_1: Node2D = $"../office_state_1"
@onready var shop: StaticBody2D = $"../shop"
@onready var road: StaticBody2D = $"../road"


var office1_texture = preload("res://assets/buildings/office1.png")
var office2_texture = preload("res://assets/buildings/office2.png")
var office3_texture = preload("res://assets/buildings/office3.png")

func _ready() -> void:
	update_building_state()
	global.state_change.connect(update_building_state)

func _on_control_mouse_entered() -> void:
	office_1.material.set_shader_parameter("outline_width", 5)

func _on_control_mouse_exited() -> void:
	office_1.material.set_shader_parameter("outline_width", 0)

func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed: # 下班时间点击进不来公司
			if global.work_times > 0:
				office_state_1.show()
				office.hide()
				shop.hide()
				road.hide()
				if global.first_work == true:
					if !AchiManager.achi_get_array[0]:
						AchiManager.achi_get.emit(1)
					var guide_scene = load("res://scenes/guide/guide_scene_office.tscn").instantiate() # 生成指引界面
					office_state_1.add_child(guide_scene)
					guide_scene.position = Vector2(370, 125)
			else:
				global.off_duty.emit()

func update_building_state():
	if global.shop_state == 0:
		office.position = Vector2(0, -30)
		control.size = Vector2(186, 223)
		control.position = Vector2(570, 471)
		collision_shape_2d.position = Vector2(662, 579.5)
		collision_shape_2d.shape.size = Vector2(190, 223)
		office_1.texture = office1_texture
		
	elif global.shop_state == 1:
		office.position = Vector2(0, -80)
		control.size = Vector2(186, 327)
		control.position = Vector2(570, 417)
		collision_shape_2d.position = Vector2(662, 579.5)
		collision_shape_2d.shape.size = Vector2(190, 329)
		office_1.texture = office2_texture
		
	elif global.shop_state == 2:
		office.position = Vector2(0, -190)
		control.size = Vector2(222, 527)
		control.position = Vector2(550, 316)
		collision_shape_2d.position = Vector2(662, 579.5)
		collision_shape_2d.shape.size = Vector2(220, 527)
		office_1.texture = office3_texture
