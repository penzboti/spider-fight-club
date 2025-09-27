extends Node2D

@export var index: int = 1;
var data: PlayerData

func _ready() -> void:
	data = PlayerManager.get_or_create_player(index)
	# Hook signals to update UI
	if not data.lives_changed.is_connected(_on_lives_changed):
		data.lives_changed.connect(_on_lives_changed)
	_on_lives_changed(data.lives)


func take_damage() -> void:
	data.lose_life(1)


func _on_lives_changed(v: int) -> void:
	print("lives: " + str(v))
