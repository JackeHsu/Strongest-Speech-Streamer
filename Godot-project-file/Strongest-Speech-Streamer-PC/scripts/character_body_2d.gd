extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bus_anim: AnimationPlayer = $"../bus/AnimationPlayer"
@onready var bus: Node2D = $"../bus"
@onready var count_down: Label = $"../Timer/count_down"
@onready var timer: Timer = $"../Timer"
@onready var start: Button = $"../start"
@onready var label: Label = $"../tips" # 提示
@onready var summary: VBoxContainer = $"../summary" # 总结
@onready var speak_score: Label = $"../summary/speak_score"
@onready var exp_and_gold: Label = $"../summary/exp_and_gold"
@onready var back: Button = $"../back"



var drop_time = 20 # 时长限制
var cur_time: int

var start_run = false # 开始追赶公交车
var cur_speed
var direction = 0
var score # 得分

var bus_run = false # 公交车开走

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	back.hide()
	summary.hide()
	bus_run = false
	cur_time = drop_time # 设计倒计时
	count_down.text = "倒计时：" + str(drop_time)
	count_down.hide()

func _physics_process(delta: float) -> void:
	if start_run:
		run_the_bus()
	else:
		velocity.x = 0
	move_and_slide()
	if bus_run:
		bus.move_local_x((-delta) * SPEED)
		if bus.position.x <= -1280: # 防止跑边界
			bus_run = false
		

func run_the_bus():
	cur_speed = (global.level_2_player_speed + SPEED)
	if direction:
		velocity.x = direction * cur_speed / 2
		if cur_speed >= SPEED && cur_speed <= 180:
			animation_player.play("walk")
			label.text = "有点慢~"
			label.add_theme_color_override("font_color", Color(1, 1, 0))
		elif cur_speed > 180 && cur_speed <= 450:
			animation_player.play("run")
			label.text = "很合适！"
			label.add_theme_color_override("font_color", Color(0, 1, 0))
		elif cur_speed > 450:
			animation_player.play("fall_down")
			label.text = "哎呦！慢点跑！"
			label.add_theme_color_override("font_color", Color(1, 0, 0))
	else:
		velocity.x = 0
		
func _on_start_pressed() -> void:
	direction = 1
	start_run = true
	count_down.show()
	timer.start()
	start.hide()

func fall_down(): # 玩家摔倒
	direction = 0
	
func stand_up(): # 玩家爬起
	direction = 1

func calculation_score(): # 计算得分
	var player_exp
	var player_gold
	global.player_total_score += score / 15
	player_exp = int(score / 15 * (global.high_exp * global.exp_buff))
	player_gold = int(score / 15 * (global.high_gold * global.gold_buff) * 2.5)
	global.player_exp += player_exp
	global.player_gold += player_gold
	speak_score.text = "得分：" + str(score)
	exp_and_gold.text = "经验值：" + str(	player_exp) + "金币：" + str(player_gold)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		direction = 0
		animation_player.play("idle")
		bus_anim.play("bus_stop")
		start_run = false
		print("玩家进入范围内")
		timer.stop()
		count_down.hide()
		label.text = "赶上了！"
		label.add_theme_color_override("font_color", Color(0, 1, 0))
		score = cur_time * 80
		calculation_score()
		back.show()
		summary.show()

func _on_timer_timeout() -> void: # 时间到
	cur_time -= 1
	count_down.text = "倒计时：" + str(cur_time)
	if cur_time <= 5:
		count_down.add_theme_color_override("font_color", Color(1, 0, 0))
	if cur_time == 0: # 倒计时结束
		timer.stop()
		start_run = false
		direction = 0
		animation_player.play("idle")
		bus_anim.play("bus_run")
		bus_run = true
		count_down.hide()
		label.text = "没赶上！"
		label.add_theme_color_override("font_color", Color(1, 0, 0))
		global.player_energy -= 50 # 没赶上公交车，减少玩家精力值
		score = 80
		calculation_score()
		back.show()
		summary.show()


func _on_start_2_pressed() -> void:
	Game.change_scene("res://scenes/home_page.tscn")
