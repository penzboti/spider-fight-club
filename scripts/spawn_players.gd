extends Node2D

const player_scene := preload("res://scenes/player.tscn")

func _ready() -> void:
	spawn_player(get_child_count())
	spawn_player(get_child_count())
	# TODO: spawn a map
	pass

var players = []

func spawn_player(i: int) -> void:
	var player: Node2D
	player = player_scene.instantiate()
	player.index = i;
	
	player.get_node("CharacterBody2D/Control/Name").text = "player " + str(i);
	
	# Set start position
	if player.has_method("set_global_position"):
		player.global_position = Vector2(300*(i+1), 300)
	
	add_child(player)
	
	if not player.data.death.is_connected(_on_death):
		player.data.death.connect(_on_death)
	
	players.append(player)

func _on_death(id):
	for player in players:
		if player.index != id:
			player.data.victories += 1
		player.data.new_run()
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
