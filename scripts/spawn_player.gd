extends Node2D

const player_scene := preload("res://scenes/player.tscn")

func _ready() -> void:
	spawn_player(get_child_count())
	spawn_player(get_child_count())
	#spawn_player(get_child_count())
	pass

func spawn_player(i: int) -> void:
	var player: Node2D
	player = player_scene.instantiate()
	player.index = i;
	
	print(i)
	
	# Set start position
	if player.has_method("set_global_position"):
		player.global_position = Vector2(300*i, 300*i)
	
	add_child(player)
	
