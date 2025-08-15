extends CharacterBody2D

signal game_over_sig
signal waste_sig # 玩家损失一格生命值

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var start: Button = $"../CanvasLayer/start"
@onready var back: Button = $"../CanvasLayer/back"
@onready var tips: Label = $"../CanvasLayer/tips"
@onready var summary: VBoxContainer = $"../CanvasLayer/summary"
@onready var jump_score_text: Label = $"../CanvasLayer/summary/jump_score"
@onready var exp_and_gold: Label = $"../CanvasLayer/summary/exp_and_gold"
@onready var vulume_show: Node2D = $"../CanvasLayer/vulume_show"
@onready var score: Label = $"../CanvasLayer/score"
@onready var timer: Timer = $"../Timer"



const SPEED = 40.0
const JUMP_VELOCITY = -300.0

var hp = 3
var direction = 0
var level_3_start = false # 游戏开始
var is_jump = false # 判断是否跳跃
var jump_score = 0
var jump_cooldown = 0.1  # 跳跃冷却时间（秒）
var cooldown_timer = 0.0  # 当前冷却时间

func game_over(): # 未通关
	direction = 0
	level_3_start = false
	#jump_score = 80
	calculation_score()
	vulume_show.is_active = false
	tips.text = "游戏结束！"
	timer.stop()
	tips.add_theme_color_override("font_color", Color(1, 0, 0))
	back.show()
	summary.show()
	
func game_pass(): # 通关
	direction = 0
	tips.text = "恭喜过关！"
	tips.add_theme_color_override("font_color", Color(0, 1, 0))
	timer.stop()
	level_3_start = false
	vulume_show.is_active = false
	global.level_3_num += 1
	calculation_score()
	jump_score += 100 * hp
	back.show()
	summary.show()

		
func calculation_score(): # 计算得分
	var player_exp
	var player_gold
	global.player_total_score += jump_score / 5
	player_exp = int(jump_score / 5 * (global.high_exp * global.exp_buff))
	player_gold = int(jump_score / 5 * (global.high_gold * global.gold_buff) * 2.5)
	global.player_exp += player_exp
	global.player_gold += player_gold
	jump_score_text.text = "得分：" + str(jump_score)
	exp_and_gold.text = "经验值：" + str(	player_exp) + "金币：" + str(player_gold)

func game_continue() -> void:
	level_3_start = false
	vulume_show.is_active = false
	timer.stop()
	start.show()

func _ready() -> void:
	back.hide()
	game_over_sig.connect(game_over)
	waste_sig.connect(game_continue)
	summary.hide()
func _physics_process(delta: float) -> void:
#print(cooldown_timer)
	
	if not is_on_floor():
		cooldown_timer = jump_cooldown
		velocity += get_gravity() * delta
		#is_jump = false
	else:
		if cooldown_timer != 0:
			cooldown_timer -= delta
			if cooldown_timer < 0:
				cooldown_timer = 0
		if velocity.y < 0:  # 如果角色正在下落
			velocity.y = lerp(velocity.y, 0, delta * 10)  # 缓冲落地速度
			#is_jump = false  # 确保落地后不会立即跳起
	# Handle jump.
	if is_jump and is_on_floor() and cooldown_timer == 0:  # 确保只有在地面上才能跳跃
		velocity.y = JUMP_VELOCITY
		is_jump = false  # 跳跃完成后重置跳跃状态
	elif is_on_floor():
		is_jump = false  # 确保落地后重置跳跃状态

	#if is_jump:
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.play("walk")

	else:
		velocity.x = 0
		animated_sprite_2d.play("idle")
	
	'''
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		#timer.start()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#timer.stop()
	'''
	
	move_and_slide()
func _on_map_1_over_body_entered(body: Node2D) -> void: # map_1
	if body is CharacterBody2D:
		game_pass()
		
func _on_map_2_over_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		game_pass()

func _on_map_3_over_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		game_pass()

func _on_map_4_over_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		game_pass()
		
func _on_map_5_over_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		game_pass()
		
func _on_map_6_over_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		game_pass()
		
	
func _on_start_pressed() -> void:
	level_3_start = true # 开始游戏
	start.hide()
	timer.start()
	start.text = "继续"
	vulume_show.is_active = true

func _on_back_pressed() -> void:
	Game.change_scene("res://scenes/home_page.tscn")


func _on_timer_timeout() -> void:
	jump_score += 10
	score.text = "得分:" + str(jump_score)

	
