extends Node2D

@export var index: int;
var data: PlayerData

@onready var ui = [$Control/Leg, $Control/Arm, $Control/Ready]
var ui_index = 0

func _ready() -> void:
	data = PlayerManager.get_or_create_player(index)
	display_hp()
	display_binds()

func _process(_delta: float) -> void:
	var keymap = data.keymap
	
	if Input.is_action_just_pressed(keymap.up):
		ui_index -= 1
		if ui_index < 0:
			ui_index = len(ui)-1
		$ColorRect.global_position = ui[ui_index].global_position + Vector2(-30,-30)
	if Input.is_action_just_pressed(keymap.down):
		ui_index += 1
		if ui_index >= len(ui):
			ui_index = 0
		$ColorRect.global_position = ui[ui_index].global_position + Vector2(-30,-30)

	if Input.is_action_just_pressed(keymap.left):
		if ui_index == 0:
			apply_buy("leg", -1)
		if ui_index == 1:
			apply_buy("arm", -1)
	if Input.is_action_just_pressed(keymap.right):
		if ui_index == 0:
			apply_buy("leg", 1)
		if ui_index == 1:
			apply_buy("arm", 1)

	if Input.is_action_just_pressed(keymap.use):
		if ui_index == len(ui)-1:
			#$Control/Ready.emit_signal("toggled", not $Control/Ready.button_pressed)
			$Control/Ready.button_pressed = not $Control/Ready.button_pressed
			if $Control/Ready.button_pressed:
				$Control/Ready.text = "Cancel"
			else:
				$Control/Ready.text = "Ready"

func apply_buy(part, change):
	#print(part, change)
	var node: Label
	if part == "leg":
		node = $Control/Leg/Number
	if part == "arm":
		node = $Control/Arm/Number

	var number = int(node.text) + change
	if number < 0:
		return
	else:
		if data.lives > 1 || change < 0:
			data.lives -= change
		else:
			return
		
	node.text = str(number)
	display_hp()

func display_hp():
	$Control/HP.text = "HP: " + str(data.lives)

func display_limb():
	#$Control/Leg/Number.text = 0
	#$Control/Arm/Number.text = 0
	pass

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
