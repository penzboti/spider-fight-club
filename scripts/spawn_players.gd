extends Node2D

const player_scene := preload("res://scenes/player.tscn")

func _ready() -> void:
	spawn_player(0)
	spawn_player(1)
	# TODO: spawn a map ?
	for player in players:
		player.max_hp = max_hp
	pass

@onready var positions = [$"../PlayerSpawner", $"../PlayerSpawner2"]
var players = []

var max_hp = 1

func spawn_player(i: int) -> void:
	var player: Node2D
	player = player_scene.instantiate()
	player.index = i;

	# Set start position
	if player.has_method("set_global_position"):
		player.global_position = positions[i].position

	add_child(player)
	
	max_hp = max(max_hp, player.data.lives)

	if not player.data.death.is_connected(_on_death):
		player.data.death.connect(_on_death)

	players.append(player)

func _on_death(id):
	for player in players:
		if player.index != id:
			player.data.victories += 1
		player.data.new_run()
	get_tree().get_root().get_node("Audio/death").play()
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
