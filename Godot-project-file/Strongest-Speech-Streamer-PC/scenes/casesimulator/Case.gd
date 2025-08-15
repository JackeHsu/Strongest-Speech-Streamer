extends TextureButton

@onready var case: TextureButton = $"."
@onready var tip: Label = $tip


var case_opening = preload("res://scenes/casesimulator/CaseSystem.tscn")


@export var blue_items: Array[SlotData] = []
@export var purple_items: Array[SlotData] = []
@export var red_items: Array[SlotData] = []
@export var special_items: Array[SlotData] = []

var item_list: Dictionary = {}

func _ready():
	tip.hide()
	item_list = {
	"blue_items": blue_items,
	"purple_items": purple_items,
	"red_items": red_items,
	"special_items": special_items
	}


func _on_pressed() -> void:
	tip.show()


func _on_mouse_entered() -> void:
	self.material.set_shader_parameter("outline_width", 2)




func _on_mouse_exited() -> void:
	self.material.set_shader_parameter("outline_width", 0)


func _on_confirm_pressed() -> void:
	var spend_money = 1000
	tip.hide()
	# 提示
	if !global.player_gold < spend_money:
		global.player_gold -= spend_money # 扣钱
		global.var_change.emit() # 更新玩家状态
		global.buy_item_tip.emit(spend_money)
		global.prize_draw.emit()
			# 抽奖
		var opening_scene = case_opening.instantiate()
		opening_scene.item_list = item_list
		get_tree().get_root().add_child(opening_scene)
		
	else:
		global.money_not_enough.emit() # 提示钱不够

func _on_cancel_pressed() -> void:
	tip.hide()
