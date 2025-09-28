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

const arm_uses = 2

signal lives_changed(new_lives: int)
signal death(dead_player: int)

func new_run() -> void:
	if lives <= 0:
		arms.clear()
		legs = 0
		lives = 5
	else:
		remove_limb("arm", true)
		for arm in arms:
			arm = arm_uses
		lives += 2

func new_limb(type) -> bool:
	var n = len(arms) + legs
	if n >= 8:
		return false
	if n < 0:
		return false
	if lives <= 1:
		return false
	
	if type == "arm":
		arms.append(arm_uses)
	if type == "leg":
		legs += 1
	lives -= 1
	return true

func remove_limb(part: String, truncate: bool):
	if truncate:
		for i in range(len(arms)):
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
