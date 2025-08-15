extends Node2D

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var url_update: HTTPRequest = $url_update



var current_url


func _ready() -> void:
	var url = "http://49.235.148.178:8000/generate_url?object_name=" + global.player_name + ".wav"
	var error = url_update.request(url)
	if error != OK:
		print("获取Token连接HTTP 请求失败")
	else:
		print("获取Token连接请求成功")



func upload_recording() -> void:
	var file_path := "user://output_mono.wav"
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var file_size = file.get_length()
		var audio_data = file.get_buffer(file.get_length())
		#var base64_data = Marshalls.raw_to_base64(audio_data)
		file.close()
	
		var headers := [
		]
		http_request.request_raw(current_url, headers, HTTPClient.METHOD_PUT, audio_data)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		print("文件上传成功")
		global.file_update_finished = true
		global.file_update_success.emit()
	else:
		print("文件上传失败，状态码：", response_code)
		global.file_update_failed.emit()


func _on_url_update_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	# 处理响应
	if response_code == 200:
		# 获取返回的签名 URL
		var body_string = body.get_string_from_utf8()
		print("响应内容：", body_string)
		var json_data = JSON.parse_string(body_string)
		if typeof(json_data) == TYPE_DICTIONARY and json_data.has("url"):
			current_url = json_data["url"]
			print("提取的 URL：", current_url)
		else:
			print("返回的数据不包含 url 字段")
	else:
		("失败")
