# player_manager.gd
extends Node
class_name PlayerManagerClass

var players: Dictionary = {} # id -> PlayerData

func get_or_create_player(id: int) -> PlayerData:
	if not players.has(id):
		var pd := PlayerData.new()
		pd.id = id
		pd.new_run()
		players[id] = pd
	return players[id]

func has_player(id: StringName) -> bool:
	return players.has(id)

func remove_player(id: StringName) -> void:
	players.erase(id)

func reset_all_runs() -> void:
	for pd: PlayerData in players.values():
		pd.new_run()
