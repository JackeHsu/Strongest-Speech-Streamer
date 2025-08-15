extends Node2D

@onready var player: CharacterBody2D = $CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		Dialogic.start("start_level_2")
		global.player_energy -= 30
