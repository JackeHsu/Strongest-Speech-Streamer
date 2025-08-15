extends Resource
class_name SlotData

@export_range(1, 99) var quantity: int = 1
@export var item_data: ItemData


func can_fully_merge_with(other_slot_data: SlotData) -> bool: # 背包的数量没超过99
	return item_data == other_slot_data.item_data and item_data.stackable and quantity + other_slot_data.quantity <= 99

func exceed_fully_merge_with(other_slot_data: SlotData) -> bool: # 背包里的数量超过99
	return item_data == other_slot_data.item_data and item_data.stackable and quantity == 99 and other_slot_data.quantity < 99

func exceed_fully_merge_swap(other_slot_data: SlotData) -> bool: 
	return item_data == other_slot_data.item_data and item_data.stackable and quantity < 99 and other_slot_data.quantity < 99

func create_fully_merge_swap(other_slot_data: SlotData) -> SlotData:
	other_slot_data.quantity = other_slot_data.quantity - (99 - quantity)
	quantity += 99 - quantity
	return other_slot_data

func can_merge_with(other_slot_data: SlotData) -> bool: 
	return item_data == other_slot_data.item_data and item_data.stackable and quantity < 99


func create_single_slot_data() -> SlotData:
	var new_slot_data = duplicate()
	
	new_slot_data.quantity = 1
	quantity -= 1
	return new_slot_data

func grab_single_slot() -> SlotData: # 用于抓取一个物品
	var new_slot_data = duplicate()
	
	new_slot_data.quantity = new_slot_data.quantity - 1
	quantity = 1
	return new_slot_data

func fully_merge_with(other_slot_data: SlotData):
	quantity += other_slot_data.quantity
	
func exceed_fully(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data and item_data.stackable and quantity < 99 and quantity + other_slot_data.quantity > 99
