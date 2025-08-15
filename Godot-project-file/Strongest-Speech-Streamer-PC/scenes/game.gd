extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var game: CanvasLayer = $"."

var world_states := {}

func _ready() -> void:
	color_rect.color.a = 0
	game.visible = false #未转场时转场效果禁用


func change_scene(path: String) -> void :
	var tree := get_tree()
	tree.paused = true #转场时冻结游戏
	game.visible = true
	
	var tween := create_tween() #场景切换渡效果
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 1, 0.2)
	await tween.finished
	
	
	var old_name := tree.current_scene.scene_file_path.get_file().get_basename() # 背包系统转场保存数据
	if old_name == "main_page":
		var player_inventory = get_node("/root/main_page/Player")
		var equipment_inventory = get_node("/root/main_page/equipment")
		global.player_inventory = player_inventory.inventory_data
		global.equipment_inventory = equipment_inventory.inventory_data # 背包统转场保存数据
	
	tree.change_scene_to_file(path) #切换场景
	await tree.tree_changed
	
	var new_name := tree.current_scene.scene_file_path.get_file().get_basename() # 背包系统转场保存数据
	if new_name == "main_page":
		var player_inventory = get_node("/root/main_page/Player")
		var equipment_inventory = get_node("/root/main_page/equipment") # 保存转场时装备信息
		if global.player_inventory && global.equipment_inventory != null:
			equipment_inventory.inventory_data = global.equipment_inventory
			player_inventory.inventory_data = global.player_inventory # 背包系统转场保存数据
			
	tree.paused = false
	game.visible = false #转场结束时转场效果禁用
	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 0, 0.2)
	global.var_change.emit()
	
	
	#global.clothes_change.emit()
	#await tween.finished


func back_to_title():
	change_scene("res://scenes/start_page.tscn")
