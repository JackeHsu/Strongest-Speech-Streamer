extends CanvasLayer

#const AVATAR_MAP = {
	#"tavern_keeper": preload("res://assets/npc/tavern_keeper/tavern_keeper_avatar.png"),
	
#}
#var current_tween
#var dialogs = [] # 保存本次需要示的所有对话
#var current = 0  # 当前进行到第几局话

#@onready var next_indicator: TextureRect = $NextIndicator
#@onready var dialogue: CanvasLayer = $"."
#@onready var avatar_name: Label = $avatar_name
#@onready var content: Label = $content
#@onready var avatar: TextureRect = $PanelContainer/Avatar

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#dialogue.hide()

#func hide_dialog_box():
	#
	#global.talking = false

#func show_dialog_box(_dialogs):
	#dialogs = _dialogs
	#dialogue.show()
	#_show_dialog(0)

'''func _show_dialog(index):
	current = index
	var dialog = dialogs[current]
	content.text = dialog.text
	avatar.texture = AVATAR_MAP[dialog.avatar]
	avatar_name.text = dialog.avatar_name
	
	next_indicator.hide()
	var tween = create_tween()
	current_tween = tween
	tween.tween_property(content, "visible_ratio", 1, 0.8).from(0)
	await tween.finished
	next_indicator.show()
'''

func _process(_delta: float) -> void:
	if global.talking:
		get_tree().paused = true
	else:
		get_tree().paused = false

	
'''
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("space") and dialogue.visible:
		if current_tween.is_running():
			current_tween.kill()
			content.visible_ratio = 1
			next_indicator.show()
		elif current + 1 < dialogs.size():
			_show_dialog(current + 1)
		else:
			hide_dialog_box()
		get_viewport().set_input_as_handled()

'''

		
