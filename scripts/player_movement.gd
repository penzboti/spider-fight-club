extends CharacterBody2D

# Player speed initially 0, can be increased by leg
var speed = 0

# HP is decreased when leg
# Set using set_hp(new_hp)
var hp = 10
func set_hp(new_hp):
	hp = new_hp
	$"../Control/HP".text = "HP: " + str(hp)

var hp_label

func _on_ready() -> void:
	set_hp(hp)  # Set initial HP value

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	var direction_y := Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * speed * delta
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	if direction_x!=0 and direction_y!=0:
		velocity.x /= 2**0.5
		velocity.y /= 2**0.5

	move_and_slide()

func _on_leg_pressed() -> void:
	speed += 5000  # Get speed from leg
	set_hp(hp-1)  # Buy leg with hp
	# If hp is 0, die.
	if hp<=0:  # Should not be less than 0, but who knows...
		get_tree().reload_current_scene() # Die.

func _on_hand_pressed() -> void:
	# TODO
	print("Handy")
