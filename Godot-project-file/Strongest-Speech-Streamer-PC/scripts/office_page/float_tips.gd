extends Node2D

@export var damage_node: PackedScene
@onready var float_tips: Node2D = $"."
@onready var timer: Timer = $Timer


var tips = [
	{text = "注意语速不要太快！"},
	{text = "可以适当停顿调整节奏！"},
	{text = "声音可以大一些！"},
	{text = "控制一下声音大小！"},
	{text = "不要紧张哦~"},
	{text = "要自信一些！"},
	{text = "要自信地看向观众哦！"},
	{text = "保持微笑~"},
	{text = "不能东张西望！"},
	{text = "注意停顿！"},
	{text = "换气控制一下节奏！"},
	{text = "放松一些~"},
	{text = "调整呼吸！"},
	{text = "声音有点小哦~"},
	{text = "上扬语调少用，下降语调多用"},
	{text = "注意手势轻重！"},
	{text = "身体放松、手势自然！"},
	{text = "偶尔可以挥舞手臂哦！"},
	{text = "抬头挺胸，腰背挺直！"},
	{text = "注意眼神交流！"},
	{text = "利用停顿、重复强调要点！"},
	{text = "辅以动作增强表现力！"},
]

func _ready() -> void:
	randomize()

func create_tips():
	var rand_tips = randi_range(0,21) # 随机提示
	var rand_x = randi_range(-10, 10) # 随机x
	var rand_y = randi_range(-10, 10) # 随机y
	#print(rand_x)
	#print(rand_y)
	var damage = damage_node.instantiate()
	damage.position = Vector2(25 * rand_x, 10 * rand_y)
	damage.get_child(0).text = tips[rand_tips].text
	damage.get_child(0).add_theme_color_override("font_color", Color(1, 0, 0))
	
	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", damage.position + _get_direction(), 0.5)
	
	float_tips.add_child(damage)
	
	
func _get_direction():
	return Vector2(randf_range(-1, 1), -randf()) * 16


func _on_timer_timeout() -> void: # 生成tips
	create_tips()
	timer.wait_time = randi_range(2, 5)


func _on_visibility_changed() -> void: # 只有在float_tips显示时才会生成tips
	if self.visible:
		timer.start()
	else:
		timer.stop()
