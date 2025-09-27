extends Node2D

const player_scene := preload("res://scenes/player.tscn")
@onready var players_root = $Players

var player: Node2D

func _ready() -> void:
	#spawn_player(players_root.get_child_count())
	pass

func count_players() -> int:
	var n := 0
	for c in get_children():
		if c is Sprite2D and c.name == "Player":
			print("spawn")
			n += 1
	return n

func spawn_player(i: int) -> void:
	player = player_scene.instantiate()
	player.number = i
	
	add_child(player)
	# Set start position
	if player.has_method("set_global_position"):
		player.global_position = Vector2(0, 0)
