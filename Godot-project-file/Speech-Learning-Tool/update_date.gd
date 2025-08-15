extends Node2D

@onready var get_url: HTTPRequest = $get_url
@onready var upload_txt: HTTPRequest = $upload_txt
@onready var button: Button = $"../ui/Button"




var current_url


func get_upload_txt_url() -> void:
	var url = "http://49.235.148.178:8000/generate_url?object_name=" + global.player_name + ".txt"
	var error = get_url.request(url)
	if error != OK:
		print("获取Token连接HTTP 请求失败")
	else:
		print("获取Token连接请求成功")


func _on_get_url_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
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
		upload_player_data()
	else:
		print("失败")

func upload_player_data() -> void:
	var file1_path := "user://player_data/player_data.txt"
	var file2_path := "user://player_data/player_data2.txt"
	
	var content1 := ""
	var content2 := ""
	
	if FileAccess.file_exists(file1_path):
		var f1 = FileAccess.open(file1_path, FileAccess.READ)
		var bytes1 = f1.get_buffer(f1.get_length())  # PackedByteArray
		content1 = bytes1.get_string_from_utf8()     # 转为 String
		f1.close()

	if FileAccess.file_exists(file2_path):
		var f2 = FileAccess.open(file2_path, FileAccess.READ)
		var bytes2 = f2.get_buffer(f2.get_length())
		content2 = bytes2.get_string_from_utf8()
		f2.close()
		
	var merged_content = content1 + "\n" + content2
	# 转成 PackedByteArray
	var byte_content = merged_content.to_utf8_buffer()
	
	var headers := [
	]
	upload_txt.request_raw(current_url, headers, HTTPClient.METHOD_PUT, byte_content)
		


func _on_update_txt_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		print("文件上传成功")
		button.text = "数据上传成功！"
	else:
		print("文件上传失败，状态码：", response_code)


func _on_button_pressed() -> void:
	get_upload_txt_url()
