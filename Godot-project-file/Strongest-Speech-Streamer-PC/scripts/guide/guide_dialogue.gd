extends Control

@onready var label: Label = $Panel/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_text(data): # 设置内容
	label.text = str(data)
	
func monitor_signal(sig: Signal):
	sig.connect(queue_free)
