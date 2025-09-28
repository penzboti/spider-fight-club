extends Node2D

@export var index: int;
var data: PlayerData

var hp
var max_hp = 1

func display_hp():
	$CharacterBody2D/Control/Red_hp_bar.position = $CharacterBody2D.position + Vector2(-max_hp*20, -160)
	$CharacterBody2D/Control/Red_hp_bar.scale.x = max_hp
	$CharacterBody2D/Control/Green_hp_bar.scale.x = hp
	$CharacterBody2D/Control/Green_hp_bar.position = $CharacterBody2D/Control/Red_hp_bar.position

func _ready() -> void:
	data = PlayerManager.get_or_create_player(index)
	hp = data.lives

	#display_hp()
	
	# Hook signals
	if not data.lives_changed.is_connected(_on_lives_changed):
		data.lives_changed.connect(_on_lives_changed)


func _process(_delta: float) -> void:
	display_hp()

func take_damage() -> void:
	data.lose_life(1)


func _on_lives_changed(v: int) -> void:
	hp = v
	#display_hp()
	
