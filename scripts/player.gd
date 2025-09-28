extends Node2D

@export var index: int;
const limb = preload("res://scenes/complete_limb.tscn")
var data: PlayerData
var legInstances: Dictionary = {}
var armInstances: Dictionary = {}

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

	# Spawn limbs for debugging
	# spawn_limb("leg")
	# spawn_limb("arm")
	# spawn_limb("leg")
	# spawn_limb("arm")


func _process(_delta: float) -> void:
	display_hp()

func take_damage() -> void:
	data.lose_life(1)


func _on_lives_changed(v: int) -> void:
	print("lives: " + str(v))
  hp = v
	#display_hp()
 
func spawn_limb(type) -> bool:
	var filled_slots = legInstances.keys()
	filled_slots.append_array(armInstances.keys())
	filled_slots.shuffle()
	var available_slots = []
	for i in range(8):
		if i not in filled_slots:
			available_slots.append(i)
	if available_slots.size() == 0:
		print("No available limb slots")
		return false
	match type:
		"leg":
			var new_leg = limb.instantiate()

			new_leg.base("leg", Color(0.8, 0.8, 0.2, 1), 3, 20, 5, %LimbAttachPoints.get_child(available_slots[0]))
			legInstances[available_slots[0]] = new_leg

			add_child(new_leg)
			return true
		"arm":
			var new_arm = limb.instantiate()
			new_arm.base("arm", Color(0.2, 0.8, 0.2, 1), 4, 18, 5, %LimbAttachPoints.get_child(available_slots[0]))
			armInstances[available_slots[0]] = new_arm
			add_child(new_arm)
			return true

		_:
			print("Unknown limb type: " + str(type))
			return false
