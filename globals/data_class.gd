# player_data.gd
extends Resource
class_name PlayerData

@export var id: int

@export var lives: int = 3
@export var inventory: Array[StringName] = []
@export var keymap: Dictionary = {}

const keymap_2 = {
	"up": "ui_up",
	"down": "ui_down",
	"left": "ui_left",
	"right": "ui_right"
}

const keymap_1 = {
	"up": "w",
	"down": "s",
	"left": "a",
	"right": "d"
}

signal lives_changed(new_lives: int)

func new_run() -> void:
	lives = 3
	inventory.clear()

func lose_life(count: int = 1) -> void:
	lives = max(0, lives - count)
	emit_signal("lives_changed", lives)
