extends Control

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var player_rank: Control = $"."
@onready var ranks: Label = $HBoxContainer/Rank
@onready var names: Label = $HBoxContainer/Name
@onready var scores: Label = $HBoxContainer/Score/Score2
@onready var level: Label = $HBoxContainer/Level/Level2
@onready var achi: Label = $HBoxContainer/Achi
@onready var times: Label = $HBoxContainer/Times/Times2


var rank_list: Dictionary = {}
var fetched_rank_types = {}  # 记录哪些排行榜已获取
var rank_types = ["Score", "Level", "Achi", "Times"]  # 你需要的排行榜


func _ready() -> void:
	fetch_leancloud()
		
func show_result():
	var dict = { "Score": global.player_total_score, "Level": global.player_level, "Achi": AchiManager.achi_num, "Times": global.player_recording_count}
	rank_list.merge({global.player_name: dict}, true)
	var player_names = rank_list.keys()
	player_names.sort_custom(func(a, b): return rank_list[a]["Score"] > rank_list[b]["Score"])
	
	#print(rank_list)
	ranks.text = "排名\n"
	names.text = "名称\n"
	scores.text = "\n"
	level.text = "\n"
	achi.text = "成就\n"
	times.text = "\n"
	
	for i in range(min(10, len(player_names))):  # 只显示前 10 名
		var player_name = player_names[i]
		ranks.text += "%d\n" % (i + 1)
		names.text += "%s\n" % player_name
		scores.text += "%d\n" % rank_list[player_name]["Score"]
		level.text += "%d\n" % rank_list[player_name]["Level"]
		achi.text += "%d\n" % rank_list[player_name]["Achi"]
		times.text += "%d\n" % rank_list[player_name]["Times"]
		
func fetch_leancloud():
	for rank_type in rank_types:
		fetched_rank_types[rank_type] = false
		_fetch_rank(rank_type)
	
func _fetch_rank(rank_type: String):
	var url = "https://k7lapuwt.lc-cn-n1-shared.com/1.1/leaderboard/leaderboards/user/%s/ranks" % rank_type
	var headers := [
		"X-LC-Id: k7lApuwToucq1BoE9U41SZAp-gzGzoHsz",
		"X-LC-Key: bgkd3NSWnQPpGkjZNrxfQXR4"
	]
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(
		func(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
			http_request.queue_free()  # 释放 HTTPRequest 资源
			if response_code != 200:
				print("Error fetching leaderboard: ", rank_type)
				return
			var data = JSON.parse_string(body.get_string_from_utf8())
			if not data or not data is Dictionary or not data.has("results"):
				print("Invalid JSON for leaderboard: ", rank_type)
				return
				
			var results := data["results"] as Array
			for r in results:
				var player_name = r["entity"]
				var value = r["statisticValue"]

				# 初始化 rank_list[player_name] 为空字典
				if not rank_list.has(player_name):
					rank_list[player_name] = {"Score": 0, "Level": 0, "Achi": 0, "Times": 0}

				rank_list[player_name][rank_type] = value  # 记录该排行榜数据
				
			# 记录该排行榜已完成
			fetched_rank_types[rank_type] = true
			
			# 检查是否所有排行榜都获取完毕
			#if fetched_rank_types.values().all(func(x): return x):
				#show_result()

	)
	http_request.request(url, headers, HTTPClient.METHOD_GET)


func _on_back_pressed() -> void:
	player_rank.hide()
