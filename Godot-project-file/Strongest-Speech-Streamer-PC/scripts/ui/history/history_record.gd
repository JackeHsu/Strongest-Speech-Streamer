extends Button

@onready var advice_son: RichTextLabel = $Advice
@onready var text_edit: TextEdit = $TextEdit # 用于临时存储课程网址



func _on_pressed() -> void:
	var advice = get_parent().get_parent().get_child(1)
	advice.text = advice_son.text
	global.current_class_url = text_edit.text
	advice.show()
