extends Control
class_name Pointer

@onready var hand: TextureRect = $hand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pointer_anim():
	var tween = create_tween()
	tween.tween_property(hand, "scale", Vector2(1.5, 1.5), 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property(hand, "scale", Vector2(1.0, 1.0), 0.5).set_ease(Tween.EASE_OUT)

func _on_timer_timeout() -> void:
	pointer_anim()
