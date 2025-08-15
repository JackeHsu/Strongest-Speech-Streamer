extends Resource
class_name InventoryData

signal inventory_interact(inventory_data: InventoryData, index: int, button: int)
signal inventory_update(inventory_data: InventoryData)
signal shift_inventory_interact(inventory_data: InventoryData, index: int, button: int)

@export var slot_datas: Array[SlotData]


func delete_item(index: int, num: int): # 丢弃物品
	var slot_data = slot_datas[index]
	slot_data.quantity -= num
	if slot_data.quantity < 1:
		slot_datas[index] = null
	inventory_update.emit(self)

func use_equipment(_index: int, equip_type, selected_slot): # 使用装备 # 未完成
	slot_datas[equip_type - 1] = selected_slot
	inventory_update.emit(self)
	#print(equip_type)

func swap_equip(index: int, equip_slot): #交换装备
	slot_datas[index] = equip_slot
	inventory_update.emit(self)

func use_consumable_item(index: int): # 使用可消耗物品
	var slot_data = slot_datas[index]
	#print(slot_data.item_data.item_name)
	slot_data.quantity -= 1
	if slot_data.quantity < 1:
		slot_datas[index] = null
	global.player_energy += slot_data.item_data.energy_value # 使用消耗品玩家数值提升
	global.exp_buff += slot_data.item_data.exp_buff_value # 使用消耗品赋予玩家buff
	if global.exp_buff >= 2.5: # 边界条件
		global.exp_buff = 2.5
	if global.gold_buff >= 2.5: # 边界条件
		global.gold_buff = 2.5
	global.gold_buff += slot_data.item_data.gold_buff_value # 使用消耗品赋予玩家buff
	if global.buff_sustain_rounds <= slot_data.item_data.buff_round: # 使用回合数多的物品重置回合数
		global.buff_sustain_rounds = slot_data.item_data.buff_round # buff效果回合数
	inventory_update.emit(self)
	
func insert_item(item: ItemData, item_num: int):
	var new_slot_data = SlotData.new()
	new_slot_data.item_data = item
	new_slot_data.quantity = item_num
	
	# 尝试在背包中找到一个空位或者可以合并的物品槽
	for i in range(slot_datas.size()):
		var slot_data = slot_datas[i]
		if slot_data != null and slot_data.item_data == item and item.stackable:
			# 计算这个槽位最多还能堆多少
			var remaining_space = item.item_max_amount - slot_data.quantity
			if remaining_space > 0:
			# 更新堆叠的数量
				var amount_to_add = min(remaining_space, new_slot_data.quantity)
				slot_datas[i].quantity += amount_to_add
				new_slot_data.quantity -= amount_to_add
			emit_signal("inventory_update", self)
			if new_slot_data.quantity == 0:
					return true
					
	# 如果有剩余的物品，再检查是否有空槽可以放置
	for i in range(slot_datas.size()):
		if slot_datas[i] == null:
			# 如果找到空位，直接添加剩余的物品
			slot_datas[i] = new_slot_data
			emit_signal("inventory_update", self)
			return true

	# 如果没有可用的槽位，也没有足够的空间进行堆叠，则插入失败
	print("背包已满")
	global.bag_is_full.emit(new_slot_data.quantity)
	return false
		
		
func grab_slot_data(index: int) -> SlotData: 
	var slot_data = slot_datas[index]
	if slot_data:
		slot_datas[index] = null
		inventory_update.emit(self)
		return slot_data
	else:
		return null
		
func grab_single_slot_data(index: int) -> SlotData: # 抓起单一物品，目前只在home处使用
	var slot_data = slot_datas[index]
	if slot_data:
		if slot_data.quantity > 1:
			slot_datas[index] = slot_data.grab_single_slot()
			inventory_update.emit(self)
			return slot_data
		else:
			slot_datas[index] = null
			inventory_update.emit(self)
			return slot_data
	else:
		return null
func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	var return_slot_data: SlotData
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
		global.current_grabbed_slot_data = null # 左键放下全部物品后，设置当前抓取物为空
		
	elif slot_data and slot_data.exceed_fully_merge_with(grabbed_slot_data):
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
		
	elif slot_data and slot_data.exceed_fully_merge_swap(grabbed_slot_data):
		slot_data.create_fully_merge_swap(grabbed_slot_data)
		return_slot_data = slot_data.create_fully_merge_swap(grabbed_slot_data)

	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
		global.current_grabbed_slot_data = slot_data
		
	inventory_update.emit(self) # 更新背包
	
	return return_slot_data
	
func drop_slot_data_home(grabbed_slot_data: SlotData, index: int) -> SlotData: # 家园系统专用
	var slot_data = slot_datas[index]
	var return_slot_data: SlotData
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
		#global.current_grabbed_slot_data = null # 左键放下全部物品后，设置当前抓取物为空
		
	elif slot_data and slot_data.exceed_fully_merge_with(grabbed_slot_data):
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
		
	elif slot_data and slot_data.exceed_fully_merge_swap(grabbed_slot_data):
		slot_data.create_fully_merge_swap(grabbed_slot_data)
		return_slot_data = slot_data.create_fully_merge_swap(grabbed_slot_data)

	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
		#global.current_grabbed_slot_data = slot_data
		
	inventory_update.emit(self) # 更新背包
	
	return return_slot_data


func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if !slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
		
	inventory_update.emit(self) # 更新背包
	
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		global.current_grabbed_slot_data = null
		return null
	
func on_slot_clicked(index: int, button: int):
	inventory_interact.emit(self, index, button)

func on_shift_slot_clicked(index: int, button: int):
	shift_inventory_interact.emit(self, index, button)

func pick_up_equipment_slot_data(slot_data: SlotData, original_index: int) -> SlotData:
	if !slot_datas[original_index]:
		slot_datas[original_index] = slot_data
		inventory_update.emit(self)
		slot_data = null
		return slot_data
			
	return slot_data
		
func pick_up_slot_data(slot_data: SlotData) -> SlotData:
	for index in slot_datas.size(): # 箱子空时传物品
		if !slot_datas[index]:
			slot_datas[index] = slot_data
			inventory_update.emit(self)
			slot_data = null
			return slot_data
			
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data):
			slot_datas[index].fully_merge_with(slot_data)
			inventory_update.emit(self)
			slot_data = null
			return slot_data
			
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].exceed_fully(slot_data):
			slot_datas[index].create_fully_merge_swap(slot_data)
			inventory_update.emit(self)
			return slot_data
	
	return slot_data 

func slot_data_update(slot_data: SlotData, _index: int):
	if slot_data:
		slot_datas[_index] = slot_data
		inventory_update.emit(self)
	if !slot_data:
		slot_datas[_index] = slot_data
		inventory_update.emit(self)
	
