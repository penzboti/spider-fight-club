# player_data.gd
extends Resource
class_name PlayerData

@export var id: int

@export var score: int = 0
@export var lives: int = 3
@export var inventory: Array[StringName] = []

#signal score_changed(new_score: int)
signal lives_changed(new_lives: int)

func new_run() -> void:
	score = 0
	lives = 3
	inventory.clear()

func lose_life(count: int = 1) -> void:
	lives = max(0, lives - count)
	emit_signal("lives_changed", lives)
