extends Node2D

@export var index: int;
var data: PlayerData

func _ready() -> void:
	data = PlayerManager.get_or_create_player(index)
	display_hp()
	display_binds()

func display_hp():
	$Control/HP.text = "HP: " + str(data.lives)

func display_binds():
	var movetype = "none"
	var usetype = "none"
	if data.keymap.get("up") == "w":
		movetype = "WASD"
		usetype = "E"
	else:
		movetype = "arrow keys"
		usetype = "."
	$Control/Binds.text = "Move with " + movetype + ", and use/press with '" + usetype + "'
	Change the limb counts with horizontal movement keys"
