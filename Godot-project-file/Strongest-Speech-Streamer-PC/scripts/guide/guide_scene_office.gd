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
	guide_1.set_text("欢迎你，新主播！这是一家专注于中小学生教育的直播公司。")
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
	guide_2.set_text("让我带你“逛”一下吧！")
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
	pointer.position = Vector2(-300, 0)
	pointer.show()
	mask.initMask(Rect2(Vector2(200, 200), Vector2(350, 450)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var guide_3 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_3)
	guide_3.position = Vector2(0, 300)
	guide_3.set_text("这边是你的主要工作区域")
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
	pointer.position = Vector2(-150, 0)
	pointer.show()
	mask.initMask(Rect2(Vector2(380, 300), Vector2(150, 100)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	#var shop = get_node("/root/main_page/office_state_1/")
	#shop.material.set_shader_parameter("outline_width", 5)
	var guide_4 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_4)
	guide_4.set_text("这里是组长的位置！")
	guide_4.position = Vector2(0, 300)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		guide_4.queue_free()
		mask.queue_free()
		guide_dialog_5())
		
func guide_dialog_5():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(-440, 230)
	pointer.show()
	mask.initMask(Rect2(Vector2(180, 540), Vector2(150, 100)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var work_table_1 = get_node("/root/main_page/office_state_1/environment0/working_table_1/Sprite2D")
	work_table_1.material.set_shader_parameter("outline_width", 2)
	var guide_5 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_5)
	guide_5.set_text("这里是你的工位！")
	guide_5.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		work_table_1.material.set_shader_parameter("outline_width", 0)
		guide_5.queue_free()
		mask.queue_free()
		guide_dialog_6())
		
func guide_dialog_6():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(100, -100)
	pointer.show()
	mask.initMask(Rect2(Vector2(600, 200), Vector2(400, 250)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var guide_6 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_6)
	guide_6.set_text("这边是直播间，你会在这里进行直播演讲哦。")
	guide_6.position = Vector2(0, 300)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		guide_6.queue_free()
		mask.queue_free()
		guide_dialog_7())

func guide_dialog_7():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(430, 220)
	pointer.show()
	mask.initMask(Rect2(Vector2(990, 520), Vector2(100, 100)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var guide_7 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_7)
	guide_7.set_text("点“离开”可以离开公司哦！。")
	guide_7.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		guide_7.queue_free()
		mask.queue_free()
		guide_dialog_8())
		
func guide_dialog_8():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(-490, -200)
	pointer.show()
	mask.initMask(Rect2(Vector2(120, 120), Vector2(72, 72)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)

	var guide_8 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_8)
	guide_8.set_text("差点忘记了！这里显示的是你今天还要直播（演讲）几次。")
	guide_8.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		guide_8.queue_free()
		mask.queue_free()
		guide_dialog_9())

func guide_dialog_9():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(420, -200)
	pointer.show()
	mask.initMask(Rect2(Vector2(1035, 135), Vector2(75, 80)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var work_table_1 = get_node("/root/main_page/office_state_1/environment0/working_table_1/Sprite2D")
	work_table_1.material.set_shader_parameter("outline_width", 2)
	var guide_9 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_9)
	guide_9.set_text("建议在直播前点击“主播手册”，学习演讲相关知识！")
	guide_9.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		work_table_1.material.set_shader_parameter("outline_width", 0)
		guide_9.queue_free()
		mask.queue_free()
		guide_dialog_10()
		)


func guide_dialog_10():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(-440, 230)
	pointer.show()
	mask.initMask(Rect2(Vector2(180, 540), Vector2(150, 100)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var work_table_1 = get_node("/root/main_page/office_state_1/environment0/working_table_1/Sprite2D")
	work_table_1.material.set_shader_parameter("outline_width", 2)
	var guide_10 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_10)
	guide_10.set_text("学习过后，让我们点击工位，开始工作准备直播演讲吧！")
	guide_10.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		work_table_1.material.set_shader_parameter("outline_width", 0)
		guide_10.queue_free()
		mask.queue_free()
		self.queue_free()
		)
