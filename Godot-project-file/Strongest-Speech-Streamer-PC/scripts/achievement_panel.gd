extends Panel

@onready var achi_show: TextureRect = $"../../achi_show"
@onready var achi_hide_timer: Timer = $achi_hide_timer
@onready var prompt: Label = $prompt
@onready var achi_icon: TextureRect = $"../../achi_show/achi_icon"
@onready var achi_explain: Label = $"../../achi_show/achi_explain"
@onready var achi_panel: Control = $".."
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


const achi_num = 8 # 总成就个数

var achi_icons = {}


func achi_icons_f(): # 预加载图片
	achi_icons[1] = load("res://assets/ui/achievement/achi_1.png")
	achi_icons[2] = load("res://assets/ui/achievement/achi_2.png")
	achi_icons[3] = load("res://assets/ui/achievement/achi_3.png")
	achi_icons[4] = load("res://assets/ui/achievement/achi_4.png")
	achi_icons[5] = load("res://assets/ui/achievement/achi_5.png")
	achi_icons[6] = load("res://assets/ui/achievement/achi_6.png")
	achi_icons[7] = load("res://assets/ui/achievement/achi_7.png")
	achi_icons[8] = load("res://assets/ui/achievement/achi_8.png")
	
func achi_get_f(): # 判断成就是否完成
	if AchiManager.achi_get_array[0]:
		get_node("GridContainer/Control1/achi_b").modulate = Color(1, 1, 1, 1)
		get_node("GridContainer/Control1/achi_icon").texture = achi_icons[1]
	if AchiManager.achi_get_array[1]:
		get_node("GridContainer/Control2/achi_b").modulate = Color(1, 1, 1, 1)
		get_node("GridContainer/Control2/achi_icon").texture = achi_icons[2]
	if AchiManager.achi_get_array[2]:
		get_node("GridContainer/Control3/achi_b").modulate = Color(1, 1, 1, 1)
		get_node("GridContainer/Control3/achi_icon").texture = achi_icons[3]
	if AchiManager.achi_get_array[3]:
		get_node("GridContainer/Control4/achi_b").modulate = Color(1, 1, 1, 1)
		get_node("GridContainer/Control4/achi_icon").texture = achi_icons[4]
	if AchiManager.achi_get_array[4]:
		get_node("GridContainer/Control5/achi_b").modulate = Color(1, 1, 1, 1)
		get_node("GridContainer/Control5/achi_icon").texture = achi_icons[5]
	if AchiManager.achi_get_array[5]:
		get_node("GridContainer/Control6/achi_b").modulate = Color(1, 1, 1, 1)
		get_node("GridContainer/Control6/achi_icon").texture = achi_icons[6]
	if AchiManager.achi_get_array[6]:
		get_node("GridContainer/Control7/achi_b").modulate = Color(1, 1, 1, 1)
		get_node("GridContainer/Control7/achi_icon").texture = achi_icons[7]
	if AchiManager.achi_get_array[7]:
		get_node("GridContainer/Control8/achi_b").modulate = Color(1, 1, 1, 1)
		get_node("GridContainer/Control8/achi_b/achi_explain").text = "*成就之王*"
		get_node("GridContainer/Control8/achi_icon").texture = achi_icons[8]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	AchiManager.achi_get.connect(achi_show_f)
	prompt.hide()
	achi_icons_f()
	achi_get_f()


func achi_show_f(current_achi):
	AchiManager.achi_get_array[current_achi - 1] = true
	# 设置成就榜上的文字和图标
	if current_achi == 8:
		get_node("GridContainer/Control" + str(current_achi) + "/achi_b/achi_explain").text = "*成就之王*"
	# 设置弹出成就的文字和图标
	get_node("GridContainer/Control" + str(current_achi) + "/achi_icon").texture = achi_icons[current_achi]
	achi_icon.texture = get_node("GridContainer/Control" + str(current_achi) + "/achi_icon").texture
	achi_explain.text = get_node("GridContainer/Control" + str(current_achi) + "/achi_b/achi_explain").text
	
	var tween := create_tween() #成就出现动画
	tween.tween_property(achi_show, "position", Vector2(429.5, 10), 1)
	audio_stream_player.play() # 播放音效
	await tween.finished
	# 点亮成就
	get_node("GridContainer/Control" + str(current_achi) + "/achi_b").modulate = Color(1, 1, 1, 1)
	
	achi_hide_timer.start()


func _on_achi_hide_timer_timeout() -> void:
	achi_hide_timer.stop()
	var tween := create_tween() #成就出现动画
	tween.tween_property(achi_show, "position", Vector2(429.5, -60), 1)
	await tween.finished
	if AchiManager.achi_get_array == [true, true, true, true, true, true, true, false]:
		AchiManager.achi_get.emit(8)

func _on_achi_1_mouse_entered() -> void:
	prompt.show()
	prompt.position = Vector2(449, 42)
	if AchiManager.achi_get_array[0]:
		prompt.text = "恭喜完成成就！"
	else:
		prompt.text = "提示：如果还没去上班的话就赶快去吧！"

func _on_achi_1_mouse_exited() -> void:
	prompt.hide()

func _on_achi_2_mouse_entered() -> void:
	prompt.show()
	prompt.position = Vector2(449, 112)
	if AchiManager.achi_get_array[1]:
		prompt.text = "恭喜完成成就！"
	else:
		prompt.text = "提示：累了的话就去睡觉吧！"

func _on_achi_2_mouse_exited() -> void:
	prompt.hide()

func _on_achi_3_mouse_entered() -> void:
	prompt.show()
	prompt.position = Vector2(449, 182)
	if AchiManager.achi_get_array[2]:
		prompt.text = "恭喜完成成就！"
	else:
		prompt.text = "提示：你知道该怎么做！加油！"

func _on_achi_3_mouse_exited() -> void:
	prompt.hide()

func _on_achi_4_mouse_entered() -> void:
	prompt.show()
	prompt.position = Vector2(449, 252)
	if AchiManager.achi_get_array[3]:
		prompt.text = "恭喜完成成就！"
	else:
		prompt.text = "提示：目标是！赚够10万金币！"
	
func _on_achi_4_mouse_exited() -> void:
	prompt.hide()

func _on_achi_5_mouse_entered() -> void:
	prompt.show()
	prompt.position = Vector2(449, 322)
	if AchiManager.achi_get_array[4]:
		prompt.text = "恭喜完成成就！"
	else:
		prompt.text = "提示：跳跃大冒险通过第十关！"

func _on_achi_5_mouse_exited() -> void:
	prompt.hide()

func _on_achi_6_mouse_entered() -> void:
	prompt.show()
	prompt.position = Vector2(449, 392)
	if AchiManager.achi_get_array[5]:
		prompt.text = "恭喜完成成就！"
	else:
		prompt.text = "提示：快去收服全部的玩偶吧！"

func _on_achi_6_mouse_exited() -> void:
	prompt.hide()

func _on_achi_7_mouse_entered() -> void:
	prompt.show()
	prompt.position = Vector2(449, 462)
	if AchiManager.achi_get_array[6]:
		prompt.text = "恭喜完成成就！"
	else:
		prompt.text = "提示：把全部车都买下来！"

func _on_achi_7_mouse_exited() -> void:
	prompt.hide()

func _on_achi_8_mouse_entered() -> void:
	prompt.show()
	prompt.position = Vector2(449, 532)
	if AchiManager.achi_get_array[7]:
		prompt.text = "恭喜达成全成就！"
	else:
		prompt.text = "？？？"

func _on_achi_8_mouse_exited() -> void:
	prompt.hide()

func _on_texture_button_pressed() -> void:
	achi_panel.hide()
