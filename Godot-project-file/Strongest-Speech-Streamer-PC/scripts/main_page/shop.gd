extends StaticBody2D

@onready var shop_1: Sprite2D = $shop1
@onready var shop: StaticBody2D = $"."
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var control: Control = $Control
@onready var shop_indoor: Node2D = $shop_indoor
@onready var shopping: Sprite2D = $shop_indoor/shopping
@onready var open_door_audio: AudioStreamPlayer = $shop_indoor/open_door_audio
@onready var speech_bubble: Label = $shop_indoor/speech
@onready var speech_timer: Timer = $shop_indoor/speech_timer
@onready var quit_timer: Timer = $shop_indoor/quit_timer
@onready var shop_background: TextureRect = $shop_indoor/shop_background
@onready var shopping_control: Control = $shop_indoor/shopping/shopping_control
@onready var shop_ui: Control = $shop_indoor/shop_ui
@onready var player_ui_control: Control = $"../Control" # 玩家状态栏显示


var shop1_texture = preload("res://assets/buildings/shop1.png")
var shop2_texture = preload("res://assets/buildings/shop2.png")
var shop3_texture = preload("res://assets/buildings/shop3.png")

var shopping_background1 = preload("res://assets/background/shop.png")
var shopping_background2 = preload("res://assets/background/supermarket.png")

var shop_counter1 = preload("res://assets/background/shop_1.png")
var shop_counter2 = preload("res://assets/background/shop_2.png")


func _ready() -> void:
	shop_indoor.hide()
	update_building_state()
	global.state_change.connect(update_building_state)

func _on_control_mouse_entered() -> void: # 建筑物
	shop_1.material.set_shader_parameter("outline_width", 5)


func _on_control_mouse_exited() -> void: # 建筑物
	shop_1.material.set_shader_parameter("outline_width", 0)


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shop_indoor.show()
			open_door_audio.play()
			speech_bubble.show()
			speech_bubble.text = "欢迎光临"
			speech_timer.start() # 时间到之后speech气泡消失
			shopping_control.show() # 购物柜台可以点击
			
			#print("鼠标左键按下")

func update_building_state():
	if global.shop_state == 0: # 商店外观
		shop.position = Vector2(149, 539)
		control.size = Vector2(159, 240)
		control.position = Vector2(-80, -117)
		collision_shape_2d.position = Vector2(-0.5, 3)
		collision_shape_2d.shape.size = Vector2(159, 238)
		shop_1.texture = shop1_texture
		shop_background.texture = shopping_background1 # 商店背景
		shop_indoor.position = Vector2(-149, -539)
		shopping.texture = shop_counter1 # 商店柜台
		shopping_control.size = Vector2(246, 289)
		shopping_control.position = Vector2(-159, 40)
		speech_bubble.position = Vector2(641, 164) # 对话气泡
		
		
	elif global.shop_state == 1: # 商店外观
		shop.position = Vector2(149, 539)
		control.size = Vector2(219, 273)
		control.position = Vector2(-110, -140)
		collision_shape_2d.position = Vector2(-0.5, -4.5)
		collision_shape_2d.shape.size = Vector2(219, 275)
		shop_1.texture = shop2_texture
		shop_background.texture = shopping_background1 # 商店背景
		shop_indoor.position = Vector2(-149, -539)
		shopping.texture = shop_counter1 # 商店柜台
		shopping_control.size = Vector2(246, 289)
		shopping_control.position = Vector2(-159, 40)
		speech_bubble.position = Vector2(641, 164) # 对话气泡
		
	elif global.shop_state == 2: # 超市外观
		shop.position = Vector2(149, 490)
		control.size = Vector2(219, 366)
		control.position = Vector2(-110, -184)
		collision_shape_2d.position = Vector2(-0.5, -1)
		collision_shape_2d.shape.size = Vector2(219, 364)
		shop_1.texture = shop3_texture
		shop_background.texture = shopping_background2 # 超市背景
		shop_indoor.position = Vector2(-149, -490)
		shopping.texture = shop_counter2 # 商店柜台
		shopping_control.size = Vector2(783, 360)
		shopping_control.position = Vector2(-643, 0)
		speech_bubble.position = Vector2(277, 131) # 对话气泡


func _on_button_pressed() -> void: # 离开按钮
	quit_timer.start() # 计时结束离开商店
	speech_bubble.text = "谢谢惠顾" # 离开商店
	speech_bubble.show()
	open_door_audio.play()
	shop_ui.hide() # 购物界面隐藏
	shopping_control.hide() # 购物柜台不可点击

func _on_shopping_control_mouse_entered() -> void:
	shopping.material.set_shader_parameter("outline_width", 5)


func _on_shopping_control_mouse_exited() -> void:
	shopping.material.set_shader_parameter("outline_width", 0)


func _on_shopping_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton: # 检测是否为鼠标按键事件
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#print("购物")
			shop_ui.show()
			


func _on_speech_timer_timeout() -> void:
	speech_timer.stop()
	speech_bubble.hide()


func _on_quit_timer_timeout() -> void:
	quit_timer.stop()
	speech_bubble.hide()
	shop_indoor.hide()
