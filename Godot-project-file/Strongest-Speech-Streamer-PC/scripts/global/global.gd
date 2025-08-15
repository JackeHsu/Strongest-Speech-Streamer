extends Node

signal esc_close
signal use_item(index: int) # 连接use_ui界面的按钮
signal delete_item(index: int, num: int) # 链接use_ui界面的按钮 
signal use_equip(index: int, equip_type) # 发送装备类型
signal bag_data_update # 背包数据更新信号
signal equip_data_update() # 装备数据更新信号
signal var_change # 数值变化信号
signal state_change # 建筑状态变化信号
signal buy_item(selected_slot: SlotData, num: int) # 购买信号
signal buy_furniture(selected_slot: SlotData, num: int) # 购买家具
signal buy_item_tip(money: int) # 购买信号，用于发出提示
signal money_not_enough # 钱不够的信号
signal bag_is_full(rest_num: int) # 背包满了,用于传递参数
signal bag_is_full_true #背包满了，用于传递信号
signal energy_not_enough # 精力不够的信号
signal clothes_change # 更换服装的信号
signal speech_finish # 演讲结束
signal file_update_success # 文件上传成功
signal file_change_failed # 文件转换失败
signal file_update_failed # 文件上传失败
signal txt_update_success # 数据上传成功
signal txt_update_failed # 数据上传失败
signal saving_date # 保存数据中
signal off_duty # 下班了
signal cant_leave # 不能请假
signal work_table_change # 更换工作地点
signal player_sleep # 玩家睡觉
signal play_game # 打电动
signal read_tips # 阅读技巧
signal first_go_home # 没体力进行l1和l2了 提示
signal go_to_sleep # 没体力打电动 提示
signal go_to_work # 应该去上班 提示
signal cant_sleep # 白天不能睡觉 提示
signal game_pause # 用于家园系统的暂停信号
signal prize_draw # 抽奖信号，用于降低bgm音量
signal prize_fin # 抽奖结束，于降低bgm音量

var level_2_player_speed = 0 # 第二训练关卡玩家动速度
var player_name: String = "null" # 该游戏玩家名称 
var player_level = 1  # 该游戏玩家等级
var player_exp = 0 # 该戏玩家离升级差多少经验
var player_gold: int = 0 # 该游戏玩家金币
var office_situation: int = 0 #该游戏公司情况（-2为急速下跌，-1为下跌，0为不变，1为上涨，2为急速上涨）
var player_nickname: String = "实习生" # 该游戏玩家称号
var player_energy: int = 100 # 该游戏玩家精力
var player_max_energy: int = 100 # 该游戏玩家最大精力值
var player_recording_count = 0 # 录音文件计数

# 演讲玩家得分
var speech_score = 0 # 演讲得分
var player_total_score = 0# 总得分
var clothes_score = 0 # 服装得分
var energy_score # 状态得分
var tasks_num = 0 # 任务1计数器
var tasks_index: Array = [0, 0, 0, 0, 0] #各难度位置数组
var meeting_index: Array = [0, 0, 0, 0, 0] #各难度位置数组
var meeting_num = 0 # 任务2计数器
var hat_score = 0 # 帽子加分
var clothes_score_1 = 0 # 衣服加分
var pants_score = 0 # 裤子加分
var shoes_score = 0 # 鞋子加分
var suit_score = 0 # 套装加分
# 玩家特殊状态
var exp_buff = 1 # 经验buff
var gold_buff = 1 # 金币buff
var high_exp = 1 # 经验加成
var high_gold = 6 # 金币加成
var max_energy_count = 0 # 体力最大值提升回合计数器
var buff_count = 0 # buff提升回合计数器
var buff_sustain_rounds = 0 # buff可持续回合数
var ask_for_leave = 2 # 距离请假还差几次工作
var new_game: bool = true # 是否是新游戏

var time: String = "daytime"# 世界时间，用于main_page

# 玩家衣服参数
var head_index = 0
var clothes_index = 0
var pants_index = 0
var shoes_index = 0
var key_index = 0

var equipment_selecting = false # 判断所点击的物品是否是equipment
var current_grabbed_slot_data
var use_ui_is_visible = false # 使用界面显示中,用于隐藏介绍界面
var buy_ui_is_visible = false # 购买界面显示中，用于隐藏介绍界面

var player_inventory # 玩家背包参数
var equipment_inventory # 玩家装备参数

var true_new_game = true # 重新打开游戏的新游戏
var true_new_game_2 = true # 重新打开游戏新游戏，用于家园系统
var home_in = false # 是否进入家园系统
# 建筑状态
var shop_state = 0
var office_state = 0
var shop_inventory_state = 0 # 商店库存状态，用于翻页

var first_work: bool = true # 第一次上班
var first_home: bool = true # 第一次回家，只用于新手引导

var file_update_finished = false # 文件上传完毕

var office_interior_visible = false # 公司室内是否显示
var work_times = 2 # 一天内演讲最大次数

# 场景名称
var scene_name: String # 最后所在场景名称

# 家园仓库
var home_inventory # 仓库系统

# level_3关卡计数器
var level_3_num = 0
var go_from_level_3 = false

# 用于传递课程网址
var current_class_url

func _ready() -> void:
	clothes_change.connect(change_close)
	#buy_furniture.connect(buy_furniture_f)
func _input(event: InputEvent) -> void:
	'''
	if event.is_action_pressed("test"):
		#print("玩家名" + global.player_name)
		#print("玩家经验加成" + str(global.high_exp))
		#print("玩家经济加成" + str(global.high_gold))
		#print("玩家体力值" + str(global.player_energy))
		#print("玩家最大体力值" + str(global.player_max_energy))
		#print("玩家经验加成buff" + str(global.exp_buff))
		#print("玩家经济加成buff" + str(global.gold_buff))
		#print("玩家大体力值持续回合" + str(global.max_energy_count))
		#print("玩家buff加成续回合" + str(global.buff_sustain_rounds))
		#print("玩家当前buff回合数" + str(global.buff_count))
		print("玩家当前剩余工作次数" + str(global.work_times))
		print("当前服装得分" + str(global.clothes_score))
		global.player_energy += 10
		print(global.time)
	'''
	'''
	if event.is_action_pressed("test"):
		global.file_update_finished = true
		global.file_update_success.emit()
	'''

	if event.is_action_pressed("esc"):
		esc_close.emit()

func change_close(): # 装备后相应得分加成
	# 帽子
	if head_index == 5:
		hat_score = 20
	elif head_index == 2:
		hat_score = 5
	else:
		hat_score = 0
	# 衣服
	if clothes_index == 1 or clothes_index == 2 or clothes_index == 3 or clothes_index == 4:
		clothes_score_1 = 25
	elif clothes_index == 6 or clothes_index == 7 or clothes_index == 9:
		clothes_score_1 = 20
	elif clothes_index == 5 or clothes_index == 8:
		clothes_score_1 = 15
	else:
		clothes_score_1 = 0
	# 裤子
	if pants_index == 1 or pants_index == 2 or pants_index == 3:
		pants_score = 25
	elif pants_index == 4 or pants_index == 5 or pants_index == 6 or pants_index == 7:
		pants_score = 15
	else:
		pants_score = 0
	# 鞋子
	if shoes_index == 1 or shoes_index == 2 or shoes_index == 3 or shoes_index == 5:
		shoes_score = 25
	elif shoes_index == 4 or shoes_index == 6 or shoes_index == 7 or shoes_index == 8:
		shoes_score = 15
	else:
		shoes_score = 0
	# 套装
	if pants_index == shoes_index && clothes_index == pants_index && clothes_index == 1:
		suit_score = 50
	elif pants_index == shoes_index && clothes_index == pants_index && clothes_index == 2:
		suit_score = 75
	elif pants_index == shoes_index && clothes_index == pants_index && clothes_index == 3:
		suit_score = 75
	else:
		suit_score = 0
	# 载具
	if key_index == 5 or key_index == 6 or key_index == 7:
		gold_buff += 1.5
		
	clothes_score = hat_score + clothes_score_1 + pants_score + shoes_score + suit_score
#func buy_furniture_f(selected_slot, num):
	#if selected_slot != null:
	#	home_inventory.insert_item(selected_slot.item_data, num)
