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
	guide_1.set_text("欢迎你，未来的演说家！")
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
	guide_2.set_text("请允许我花费一点点时间，向你介绍如何一步一步成为一名合格的演说家!")
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
	pointer.position = Vector2(0, -300)
	pointer.show()
	mask.initMask(Rect2(Vector2(0, 0), Vector2(1280, 72)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var guide_3 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_3)
	guide_3.set_text("这里是状态栏，显示玩家和公司状态")
	guide_3.position = Vector2(0, 0)
	
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
	pointer.position = Vector2(-150, -330)
	pointer.show()
	mask.initMask(Rect2(Vector2(450, 0), Vector2(200, 72)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var guide_4 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_4)
	guide_4.set_text("演讲的表现会影响公司经营的情况哦！")
	guide_4.position = Vector2(0, 0)
	
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
	pointer.position = Vector2(580, -330)
	pointer.show()
	mask.initMask(Rect2(Vector2(1180, 0), Vector2(120, 60)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var guide_5 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_5)
	guide_5.set_text("这里是背包，可以使用道具和更换服装。合适的衣服能够在演讲时获得更高的分数哦！")
	guide_5.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		guide_5.queue_free()
		mask.queue_free()
		guide_dialog_6())
		
func guide_dialog_6():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(580, -280)
	pointer.show()
	mask.initMask(Rect2(Vector2(1160, 50), Vector2(120, 60)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var guide_6 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_6)
	guide_6.set_text("这里是积分榜，你可以看到其他人的积分哦！")
	guide_6.position = Vector2(0, 0)
	
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
	pointer.position = Vector2(-450, 250)
	pointer.show()
	mask.initMask(Rect2(Vector2(50, 400), Vector2(200, 300)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var shop = get_node("/root/main_page/shop/shop1")
	shop.material.set_shader_parameter("outline_width", 5)
	var guide_7 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_7)
	guide_7.set_text("这里是商店，上班之前，下班以后可以去商店里逛逛哦！")
	guide_7.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		shop.material.set_shader_parameter("outline_width", 0)
		guide_7.queue_free()
		mask.queue_free()
		guide_dialog_8())

func guide_dialog_8():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(430, 230)
	pointer.show()
	mask.initMask(Rect2(Vector2(980, 400), Vector2(200, 300)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var road = get_node("/root/main_page/road/road_background")
	road.material.set_shader_parameter("outline_width", 2)
	var guide_8 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_8)
	guide_8.set_text("如果早上发现没有体力上班的话，可以点这里请一天假哦。")
	guide_8.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		road.material.set_shader_parameter("outline_width", 0)
		guide_8.queue_free()
		mask.queue_free()
		guide_dialog_9())
		
func guide_dialog_9():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(350, -330)
	pointer.show()
	mask.initMask(Rect2(Vector2(950, 0), Vector2(200, 72)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)

	var guide_9 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_9)
	guide_9.set_text("适当的请假休息可以补充体力，提升状态，但是会扣除工资，而且公司的经营情况也会下降！")
	guide_9.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		guide_9.queue_free()
		mask.queue_free()
		guide_dialog_10())
		
func guide_dialog_10():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(430, 150)
	pointer.show()
	mask.initMask(Rect2(Vector2(980, 400), Vector2(200, 300)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var road = get_node("/root/main_page/road/road_background")
	road.material.set_shader_parameter("outline_width", 2)
	var guide_10 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_10)
	guide_10.set_text("下班后点击此处可以进行演讲技巧的训练哦！")
	guide_10.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		road.material.set_shader_parameter("outline_width", 0)
		guide_10.queue_free()
		mask.queue_free()
		guide_dialog_11())
		
func guide_dialog_11():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(0, 230)
	pointer.hide()
	mask.initMask(Rect2(Vector2(640, 360), Vector2(0, 0)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var guide_11 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_11)
	guide_11.set_text("按键盘上的“ESC”键可以保存并退出游戏")
	guide_11.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		guide_11.queue_free()
		mask.queue_free()
		guide_dialog_12())
	
func guide_dialog_12():
	var mask = preload("res://scenes/guide/guide_mask.tscn").instantiate()
	self.add_child(mask)
	move_child(pointer, -1)
	pointer.position = Vector2(0, 230)
	pointer.show()
	mask.initMask(Rect2(Vector2(540, 400), Vector2(250, 300)))
	mask.transition_anim()
	color_rect.color = Color(0, 0, 0, 0)
	
	var office = get_node("/root/main_page/office/office1")
	office.material.set_shader_parameter("outline_width", 5)
	var guide_12 = preload("res://scenes/guide/guide_dialogue.tscn").instantiate()
	self.add_child(guide_12)
	guide_12.set_text("好啦，那现在让我们点击公司去上班，开始第一天的演讲吧！")
	guide_12.position = Vector2(0, 0)
	
	var next_step = preload("res://scenes/guide/guide.tscn").instantiate()
	self.add_child(next_step)
	next_step.position = Vector2(0, 0)
	next_step.player_click.connect(func():
		guide_12.queue_free()
		office.material.set_shader_parameter("outline_width", 0)
		mask.queue_free()
		self.queue_free())
