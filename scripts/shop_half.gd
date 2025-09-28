extends Node2D

@export var index: int;
var data: PlayerData

@onready var ui = [$Control/Leg, $Control/Arm, $Control/Ready]
var ui_index = 0

@export var invincibility_duration: float = 1
var _inv_timer: float = 0.0

func _ready() -> void:
	data = PlayerManager.get_or_create_player(index)
	display_hp()
	display_limb()
	display_binds()
	$Control/Wins.text = "Wins: " + str(data.victories)
	start_invincibility()

func _process(delta: float) -> void:
	var keymap = data.keymap
	_update_invincibility(delta)
	if is_invincible():
		return
	
	if Input.is_action_just_pressed(keymap.up):
		ui_index -= 1
		if ui_index < 0:
			ui_index = len(ui)-1
		$ColorRect.global_position.y = ui[ui_index].global_position.y -15
	if Input.is_action_just_pressed(keymap.down):
		ui_index += 1
		if ui_index >= len(ui):
			ui_index = 0
		$ColorRect.global_position.y = ui[ui_index].global_position.y -15

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
				$Ready.play()
				$Control/Ready.text = "Cancel"
			else:
				$Control/Ready.text = "Ready"

func _on_ready_pressed() -> void:
	if $Control/Ready.button_pressed:
		$Ready.play()
		$Control/Ready.text = "Cancel"
	else:
		$Control/Ready.text = "Ready"

func apply_buy(part, change):
	#print(part, change)
	var number: int
	if part == "leg":
		number = data.legs + change
	if part == "arm":
		number = len(data.arms) + change

	if number < 0:
		return
	if change < 0:
		data.remove_limb(part, false)
		$RemoveLimb.play()
	else:
		var res = data.new_limb(part)
		if res:
			$AddLimb.play()
	#print(data.arms, data.legs, data.lives)
	
	display_hp()
	display_limb()

func display_hp():
	$Control/HP.text = "HP: " + str(data.lives)

func display_limb():
	$Control/Leg/Number.text = str(data.legs)
	$Control/Arm/Number.text = str(len(data.arms))
	pass

func display_binds():
	var movetype = "none"
	var usetype = "none"
	if data.keymap.get("up") == "w":
		movetype = "'a' / 'd'"
		usetype = "'w' / 's'"
	else:
		movetype = "left / right"
		usetype = "up / down"
	$Control/Binds.text = "navigate with " + usetype + "\nadd / remove limbs with "+ movetype

func start_invincibility() -> void:
	_inv_timer = invincibility_duration # extend if currently invincible

func is_invincible() -> bool:
	return _inv_timer > 0.0

func _update_invincibility(delta: float) -> void:
	if _inv_timer > 0.0:
		_inv_timer -= delta
		if _inv_timer <= 0.0:
			_inv_timer = 0.0
