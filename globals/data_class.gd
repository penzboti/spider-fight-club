extends Resource
class_name PlayerData

@export var id: int

@export var lives: int
@export var victories: int
@export var inventory: Array[StringName]
@export var keymap: Dictionary

const keymap_2 = {
	"up": "ui_up",
	"down": "ui_down",
	"left": "ui_left",
	"right": "ui_right",
	"use": "use2"
}

const keymap_1 = {
	"up": "w",
	"down": "s",
	"left": "a",
	"right": "d",
	"use": "use"
}

signal lives_changed(new_lives: int)
signal death(dead_player: int)

func new_run() -> void:
	if lives <= 0:
		inventory.clear()
	lives = 10

func lose_life(count: int = 1) -> void:
	lives = lives-count
	emit_signal("lives_changed", lives)
	if lives < 1:
		emit_signal("death", id)
