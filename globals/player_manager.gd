extends Node
class_name PlayerManagerClass

var players: Dictionary = {} # id -> PlayerData

func get_or_create_player(id: int) -> PlayerData:
	if not players.has(id):
		var pd := PlayerData.new()
		if id == 0:
			pd.keymap = pd.keymap_1
		elif id == 1:
			pd.keymap = pd.keymap_2
		pd.id = id
		pd.new_run()
		players[id] = pd
	return players[id]

#func reset_all_runs() -> void:
	#for pd: PlayerData in players.values():
		#pd.new_run()
