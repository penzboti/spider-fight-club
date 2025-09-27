extends Resource
class_name PlayerData

@export var id: int

@export var lives: int
@export var victories: int
@export var arms: Array[int]
@export var legs: int
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
		arms.clear()
		lives = 9
	else:
		for arm in arms:
			arm = 3 # max uses
		lives = 5

func new_limb(type):
	var n = len(arms) + legs
	if n >= 8:
		return
	if n < 0:
		return
	if lives <= 1:
		return
	
	if type == "arm":
		arms.append(3)
	if type == "leg":
		legs += 1
	lives -= 1
	print("change")

func remove_limb(part: String, truncate: bool):
	if truncate:
		for i in range(arms):
			if arms[i] == 0:
				arms.remove_at(i)
				return
	
	if part == "leg":
		legs -= 1
	if part == "arm":
		arms.pop_back()
	lives += 1

func lose_life(count: int = 1) -> void:
	lives = lives-count
	emit_signal("lives_changed", lives)
	if lives < 1:
		emit_signal("death", id)
