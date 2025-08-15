extends Node2D

@onready var button: Button = $VBoxContainer/Button
@onready var button_2: Button = $VBoxContainer/Button2
@onready var buy_num: Label = $VBoxContainer/Button2/VBoxContainer/buy_num # 购买物品数量
@onready var v_box_container: VBoxContainer = $VBoxContainer/Button2/VBoxContainer # 购买物品确认界面
@onready var num_slider: HSlider = $VBoxContainer/Button2/VBoxContainer/NumSlider



signal buy_item

var index: int # 格子索引
var tem_slot_data
var num: int = 1# 购买数量
var spend_money: int # 购物开销
var rest_num = 0 # 背包满时，购买剩下的量

func _ready() -> void:
	global.bag_is_full.connect(set_num)

func set_num(_num):
	rest_num = _num

func set_index(slot_index):
	index = slot_index

func set_data(buy_slot_data):
	tem_slot_data = buy_slot_data

#and !(button.is_pressed or button.pressed)
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if button.is_hovered() or button_2.is_hovered() or v_box_container.visible:# 点击按钮时过会儿才删除菜单
			pass
		else:
			self.queue_free()
			global.buy_ui_is_visible = false
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
			self.queue_free()
			global.buy_ui_is_visible = false



func _on_button_pressed() -> void:
	self.queue_free()
	#print("取消")
	global.buy_ui_is_visible = false
	
func _on_button_2_pressed() -> void:
	#print("购买")
	if tem_slot_data.item_data.is_commodity == true: # 是商品才能购买
		v_box_container.show()
		if tem_slot_data.item_data.stackable == true: # 可堆叠物品可以买多个
			num_slider.max_value = (global.player_gold / tem_slot_data.item_data.price)
			if num_slider.max_value >= tem_slot_data.item_data.item_max_amount: # 限制每次购物最大购买量
				num_slider.max_value = tem_slot_data.item_data.item_max_amount
			buy_num.text = str(num_slider.value)
		else:
			num_slider.max_value = 1
			buy_num.text = str(num_slider.value)


func _on_confirm_pressed() -> void:
	spend_money = num * tem_slot_data.item_data.price
	if !global.player_gold < spend_money:
		if tem_slot_data.item_data.group_name == "furniture":
			if tem_slot_data.item_data.equipment_value != 0:
				AchiManager._update_toys_array_state(tem_slot_data.item_data.equipment_value)
			global.buy_furniture.emit(tem_slot_data, num)
		elif tem_slot_data.item_data.group_name == "interactive":
			global.buy_furniture.emit(tem_slot_data, num)
		elif tem_slot_data.item_data.group_name == "wall":
			global.buy_furniture.emit(tem_slot_data, num)
		elif tem_slot_data.item_data.group_name == "ground":
			global.buy_furniture.emit(tem_slot_data, num)
		else:
			if tem_slot_data.item_data.equipment_type == 5:
				AchiManager._update_keys_array_state(tem_slot_data.item_data.equipment_value)
			global.buy_item.emit(tem_slot_data, num) # 对玩家背包进行是否满的判断，且插入相应物品返回没成功插入数量
		if rest_num == 0:
			global.player_gold -= spend_money # 扣钱
			#print(spend_money)
			#print(tem_slot_data.item_data.price)
			global.var_change.emit() # 更新玩家状态
			self.queue_free()
			global.buy_ui_is_visible = false
			global.buy_item_tip.emit(spend_money)
		else:
			spend_money = (num - rest_num) * tem_slot_data.item_data.price
			global.player_gold -= spend_money # 扣钱
			global.var_change.emit() # 更新玩家状态
			self.queue_free()
			global.buy_ui_is_visible = false
			if spend_money != 0: # 确保正确显示扣除金额
				global.buy_item_tip.emit(spend_money)
			global.bag_is_full_true.emit()

	else:
		global.money_not_enough.emit() # 提示钱不够
		self.queue_free()
		global.buy_ui_is_visible = false


func _on_cancel_pressed() -> void:
	v_box_container.hide()


func _on_num_slider_drag_ended(_value_changed: bool) -> void:
	buy_num.text = str(num_slider.value)
	num = num_slider.value
	spend_money = num * tem_slot_data.item_data.price
