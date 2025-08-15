extends Control
class_name EquipmentSlot

signal slot_clicked(index: int, button: int)

const EQUIP_SLOT_ICON: Array[Texture2D] = [
	preload("res://assets/ui/equip_slot/head.png"),
	preload("res://assets/ui/equip_slot/clothes.png"),
	preload("res://assets/ui/equip_slot/pants.png"),
	preload("res://assets/ui/equip_slot/shoes.png"),
	preload("res://assets/ui/equip_slot/car_key.png"),
]

@export var equip_type: Equip_data.EQUIP_TYPE = Equip_data.EQUIP_TYPE.Clothes: 
	set(value):
		equip_type = value
		if tr_slot:
			_update_slot_display()

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var tr_slot: TextureRect = %tr_slot
@onready var select: TextureRect = $select


func _update_slot_display():
	var slot_index: int = equip_type
	tr_slot.texture = EQUIP_SLOT_ICON[slot_index]

func _ready() -> void:
	_update_slot_display()
	
func _process(_delta: float) -> void:
	if global.current_grabbed_slot_data != null:
		if global.current_grabbed_slot_data.item_data.equipment_type != self.equip_type + 1: #加一为了防止不属于装备的物品放入装备栏
			self.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			self.mouse_filter = Control.MOUSE_FILTER_PASS
	else:
		self.mouse_filter = Control.MOUSE_FILTER_PASS
		
func set_slot_data(slot_data: SlotData):
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.item_texture
	tr_slot.hide()
	
	if slot_data.quantity > 1:
		label.text = "x%s" % slot_data.quantity
		label.show()
	else:
		label.hide()
		
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT) and !Input.is_key_pressed(KEY_SHIFT) and event.is_pressed(): 
		slot_clicked.emit(get_index(), event.button_index)
		global.equipment_selecting = true
		#print(get_index(), event.button_index) # 打印背包格子位置，检验背包是否被正确点击


func _on_mouse_entered() -> void:
	select.show()


func _on_mouse_exited() -> void:
	select.hide()
