extends Resource
class_name SceneData

@export var box_array: Array[PackedScene]
@export var home_data: PackedScene

@export var first_layer_data: PackedScene # 存储第一层物品
@export var wall_data: PackedScene # 存储墙上物品
@export var item_list: Array = []
