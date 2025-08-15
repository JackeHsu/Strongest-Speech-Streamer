extends Control

@onready var pointer: Pointer = $Pointer
@onready var color_rect: ColorRect = $ColorRect
@onready var guide_scene: Control = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guide_dialog_1()
	pointer.hide()


func guide_dialog_1():
	var guide_1 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_1)
	guide_1.set_text("欢迎回家，这里以后就是你温馨的小家了！")
	guide_1.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		guide_1.queue_free()
		guide_dialog_2())

func guide_dialog_2():
	var guide_2 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_2)
	guide_2.set_text("可能现在看起来是有点空荡荡的，不过没关系！")
	guide_2.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.player_click.connect(func():
		guide_2.queue_free()
		guide_dialog_3())

func guide_dialog_3():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(-600, -200)
	pointer.show()
	mask.initMask(Rect2(Vector2(7, 80), Vector2(100, 100)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var guide_3 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_3)
	guide_3.position = Vector2(0, 0)
	guide_3.set_text("我们点击这里，就可以进入仓库了！")
	#guide_3.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		guide_3.queue_free()
		mask.queue_free()
		guide_dialog_4())

func guide_dialog_4():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(0, 150)
	pointer.show()
	mask.initMask(Rect2(Vector2(0, 550), Vector2(1280, 300)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var home_inventory_ui = get_node("/root/home_page/home/CanvasLayer")
	home_inventory_ui.show()
	var back_button = get_node("/root/home_page/Back")
	back_button.hide()
	#var shop = get_node("/root/main_page/office_state_1/")
	#shop.material.set_shader_parameter("outline_width", 5)
	var guide_4 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_4)
	guide_4.set_text("进入仓库后，点击里面的家具，然后按照自己喜欢的样子摆放出来哦！")
	guide_4.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		home_inventory_ui.hide()
		back_button.show()
		guide_4.queue_free()
		mask.queue_free()
		guide_dialog_5())
		
func guide_dialog_5():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(-480, 230)
	pointer.show()
	mask.initMask(Rect2(Vector2(30, 460), Vector2(200, 250)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var back_button = get_node("/root/home_page/Back")
	back_button.material.set_shader_parameter("outline_width", 2)
	var guide_5 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_5)
	guide_5.set_text("需要更多家具的话可以点这里去商店购买！")
	guide_5.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		back_button.material.set_shader_parameter("outline_width", 1)
		guide_5.queue_free()
		mask.queue_free()
		guide_dialog_6())
		
func guide_dialog_6():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(-480, 230)
	pointer.show()
	mask.initMask(Rect2(Vector2(30, 460), Vector2(200, 250)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var back_button = get_node("/root/home_page/Back")
	back_button.material.set_shader_parameter("outline_width", 2)
	var guide_6 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_6)
	guide_6.set_text("点击这里是返回公司。装备不同的钥匙！这里会发生变化哦！")
	guide_6.position = Vector2(0, 300)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		back_button.material.set_shader_parameter("outline_width", 0)
		guide_6.queue_free()
		mask.queue_free()
		pointer.hide()
		guide_dialog_7())

func guide_dialog_7():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	mask.initMask(Rect2(Vector2(640, 360), Vector2(0, 0)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var guide_7 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_7)
	guide_7.set_text("那么就说这么多，你好好休息吧！")
	guide_7.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		guide_7.queue_free()
		self.queue_free()
		)
