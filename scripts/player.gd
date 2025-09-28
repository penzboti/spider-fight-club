extends Node2D
@export var index: int;
var data: PlayerData

var hp
var max_hp = 1

const limb = preload("res://scenes/complete_limb.tscn")
var legInstances: Dictionary = {}
var armInstances: Dictionary = {}

func display_hp():
	$CharacterBody2D/Control/Red_hp_bar.position =  Vector2(-max_hp*20, -160)
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


	for i in range(data.legs):
		var leg = spawn_limb("leg")
		leg.identifier = "{data.id}_leg_{i}"
	for i in data.arms:
		var arm = spawn_limb("arm")
		arm.identifier = "{data.id}_arm_{i}"

	set_meta("id", data.id)
	$CharacterBody2D.set_meta("id", data.id)

func _process(_delta: float) -> void:
	display_hp()
	if Input.is_action_just_pressed(data.keymap.use):
		take_damage()


func take_damage(i: int = 1) -> void:
	data.lose_life(i)
	$damage.play()


func _on_lives_changed(v: int) -> void:
	hp = v
	#display_hp()
	
func spawn_limb(type) -> Node2D:
	var filled_slots = legInstances.keys()
	filled_slots.append_array(armInstances.keys())
	filled_slots.shuffle()
	var available_slots = []
	for i in range(8):
		if i not in filled_slots:
			available_slots.append(i)
	if available_slots.size() == 0:
		print("No available limb slots")
		return null
	match type:
		"leg":
			var new_leg = limb.instantiate()

			new_leg.base("leg", Color(0.8, 0.8, 0.2, 1), 3, 20, 5, %LimbAttachPoints.get_child(available_slots[0]))
			legInstances[available_slots[0]] = new_leg

			add_child(new_leg)
			return new_leg
		"arm":
			var new_arm = limb.instantiate()
			new_arm.base("arm", Color(0.2, 0.8, 0.2, 1), 4, 18, 5, %LimbAttachPoints.get_child(available_slots[0]))
			armInstances[available_slots[0]] = new_arm
			add_child(new_arm)
			return new_arm

		_:
			print("Unknown limb type: " + str(type))
			return null

func handle_arm_collision(arm: Node2D, body: Node) -> bool:
	# Called when an arm collides with something

	if body.has_meta("id") and body.get_meta("id") != self.get_meta("id"):
		var other_player = body
		other_player.get_parent().take_damage(1)
		data.arms[int(arm.identifier[-1])] -= 1
		if data.arms[int(arm.identifier[-1])] <= 0:
			data.arms.remove_at(int(arm.identifier[-1]))
			arm.queue_free()
			armInstances.erase(int(arm.identifier[-1]))
		return true
	else:
		return false
