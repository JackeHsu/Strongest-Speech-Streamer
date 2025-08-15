extends Node2D


@export var inventory_data1: InventoryData # 便利店库存
@export var inventory_data2: InventoryData # 商店库存
@export var inventory_data3: InventoryData # 超市库存
@export var inventory_data4: InventoryData # 超市第二页库存
@export var inventory_data5: InventoryData # 超市第三页库存
@export var inventory_data6: InventoryData # 超市第四页库存

@onready var player: Player = $"../../Player"


var slots: Array

	
