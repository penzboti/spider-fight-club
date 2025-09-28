extends Node2D
@export var index: int;
var data: PlayerData

var hp
var max_hp = 1

const limb = preload("res://scenes/complete_limb.tscn")
var legInstances: Dictionary = {}
var armInstances: Dictionary = {}

@export var invincibility_duration: float = 0.6
var _inv_timer: float = 0.0

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
	for i in range(len(data.arms)):
		var arm = spawn_limb("arm")
		arm.identifier = "{data.id}_arm_{i}"

	set_meta("id", data.id)
	$CharacterBody2D.set_meta("id", data.id)
	
	# Add to players group for easy enemy detection
	add_to_group("players")

func _process(delta: float) -> void:
	display_hp()
	if Input.is_action_just_pressed(data.keymap.use):
		flail_arms_toward_enemies()

func flail_arms_toward_enemies() -> void:
	# Find any other player
	var enemy = null
	var all_players = get_tree().get_nodes_in_group("players")
	for player in all_players:
		if player != self:
			enemy = player
			break
	
	# Flail all arms
	if enemy:
		for arm in armInstances.values():
			if arm:
				for child in arm.get_children():
					if child.has_method("fling"):
						var direction = (enemy.global_position - child.global_position).normalized()
						child.fling(direction * 500)
	_update_invincibility(delta)

func take_damage() -> void:
	if is_invincible():
		return
	start_invincibility()
	data.lose_life(1)
	$damage.play()

func start_invincibility() -> void:
	_inv_timer = invincibility_duration # extend if currently invincible

func is_invincible() -> bool:
	return _inv_timer > 0.0

func _update_invincibility(delta: float) -> void:
	if _inv_timer > 0.0:
		_inv_timer -= delta
		if _inv_timer <= 0.0:
			_inv_timer = 0.0

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

			new_leg.base("leg", Color(0.8, 0.8, 0.2, 1), 3, 30.0, 7.0, %LimbAttachPoints.get_child(available_slots[0]))
			legInstances[available_slots[0]] = new_leg

			add_child(new_leg)
			return new_leg
		"arm":
			var new_arm = limb.instantiate()
			new_arm.base("arm", Color(0.2, 0.8, 0.2, 1), 4, 30.0, 7.0, %LimbAttachPoints.get_child(available_slots[0]))
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
		other_player.get_parent().take_damage()
		var arm_index = int(arm.identifier[-1])
		
		# Check if the arm index is valid
		if arm_index >= 0 and arm_index < len(data.arms):
			data.arms[arm_index] -= 1
			if data.arms[arm_index] <= 0:
				# Set to 0 instead of removing to maintain array indices
				data.arms[arm_index] = 0
				arm.queue_free()
				armInstances.erase(arm_index)
		return true
	else:
		return false
