extends Panel


func _on_mouse_entered() -> void:
	GameManager.item_delete_true.emit() # 进入UI区域


func _on_mouse_exited() -> void:
	GameManager.item_delete_false.emit() # 离开UI区域
