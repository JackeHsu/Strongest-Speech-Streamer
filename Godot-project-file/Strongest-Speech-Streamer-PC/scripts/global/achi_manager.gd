extends Node

signal achi_get # 获得成就
signal achi_string_update # 更新状态
# 成就
var achi_get_array = [false, false, false, false, false, false, false, false]
var achi_num = 0
var achi_get_situation: Array = [0, 0, 0, 0, 0, 0, 0, 0]

var toys: Array = [0, 0, 0, 0, 0]
var keys: Array = [0, 0, 0, 0, 0, 0, 0]

func _ready() -> void:
	achi_get.connect(_update_achi_array_state)
	achi_string_update.connect(_update_achi_string_state)
	_update_achi_string_state() # 加载游戏时调用即可
func _update_achi_string_state(): # 用于更新achi_get_array
	var j = 0
	for i in len(achi_get_situation):
		if achi_get_situation[i] == 0:
			achi_get_array[i] = false
		else:
			j += 1
			achi_get_array[i] = true
	achi_num = j
func _update_achi_array_state(i): # 用于更新achi_get_situation
	achi_get_situation[i - 1] = 1
	achi_num += 1

func _update_toys_array_state(i): # 用于更新toys
	toys[i - 1] = 1
	if !achi_get_array[5]:
		if toys == [1, 1, 1, 1, 1]:
			achi_get.emit(6)
	
func _update_keys_array_state(i): # 用于更新keys
	keys[i - 1] = 1
	if !achi_get_array[6]:
		if keys == [1, 1, 1, 1, 1, 1, 1]:
			achi_get.emit(7)
