extends Marker2D


@export var damage_node: PackedScene
@onready var popup_location_shop: Marker2D = $"." # 商店定位标
@onready var popup_location_office: Marker2D = $"." # 办公室定位标



func _ready() -> void:
	randomize()
	global.buy_item_tip.connect(popup)
	global.money_not_enough.connect(money_not_eonough_popup)
	global.bag_is_full_true.connect(bag_is_full_popup)
	global.energy_not_enough.connect(energy_not_enough)
	global.off_duty.connect(off_duty)
	global.first_go_home.connect(go_home)
	global.go_to_sleep.connect(go_to_sleep_f)
	global.go_to_work.connect(go_to_work_f)
	global.cant_sleep.connect(go_to_work_f)
	global.cant_leave.connect(go_to_work_f)
	
func go_to_work_f():
	var damage = damage_node.instantiate()
	damage.position = popup_location_office.position
	damage.get_child(0).text = "先去上班吧！"
	damage.get_child(0).add_theme_color_override("font_color", Color(1, 0, 0))
	
	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", popup_location_office.position + _get_direction(), 0.5)
	
	popup_location_office.add_child(damage)
	
func go_to_sleep_f():
	var damage = damage_node.instantiate()
	damage.position = popup_location_office.position
	damage.get_child(0).text = "应该睡觉了！"
	damage.get_child(0).add_theme_color_override("font_color", Color(1, 0, 0))
	
	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", popup_location_office.position + _get_direction(), 0.5)
	
	popup_location_office.add_child(damage)
	
func go_home(): 
	var damage = damage_node.instantiate()
	damage.position = popup_location_office.position
	damage.get_child(0).text = "好累，先回家吧！"
	damage.get_child(0).add_theme_color_override("font_color", Color(1, 0, 0))
	
	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", popup_location_office.position + _get_direction(), 0.5)
	
	popup_location_office.add_child(damage)

func off_duty(): 
	var damage = damage_node.instantiate()
	damage.position = popup_location_office.position
	damage.get_child(0).text = "下班了！"
	damage.get_child(0).add_theme_color_override("font_color", Color(1, 0, 0))
	
	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", popup_location_office.position + _get_direction(), 0.5)
	
	popup_location_office.add_child(damage)
	
func energy_not_enough():
	var damage = damage_node.instantiate()
	damage.position = popup_location_office.position
	damage.get_child(0).text = "体力不够了！"
	damage.get_child(0).add_theme_color_override("font_color", Color(1, 0, 0))
	
	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", popup_location_office.position + _get_direction(), 0.5)
	
	popup_location_office.add_child(damage)
	
func bag_is_full_popup():
	var damage = damage_node.instantiate()
	damage.position = popup_location_shop.position
	damage.get_child(0).text = "背包满了！"
	damage.get_child(0).add_theme_color_override("font_color", Color(1, 0, 0))
	
	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", popup_location_shop.position + _get_direction(), 0.5)
	
	popup_location_shop.add_child(damage)

func money_not_eonough_popup():
	var damage = damage_node.instantiate()
	damage.position = popup_location_shop.position
	damage.get_child(0).text = "钱不够！"
	damage.get_child(0).add_theme_color_override("font_color", Color(1, 0, 0))
	
	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", popup_location_shop.position + _get_direction(), 0.5)
	
	popup_location_shop.add_child(damage)
	
func popup(money: int):
	var damage = damage_node.instantiate()
	damage.position = popup_location_shop.position
	damage.get_child(0).text = "-" + str(money)
	damage.get_child(0).add_theme_color_override("font_color", Color(1, 0.84, 0))
	
	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", popup_location_shop.position + _get_direction(), 0.5)
	
	popup_location_shop.add_child(damage)
	
func _get_direction():
	return Vector2(randf_range(-1, 1), -randf()) * 16
	
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("test"):
		#popup()
