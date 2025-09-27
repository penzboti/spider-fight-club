extends CharacterBody2D


var speed = 300
var inertia: float = float(1) / float(25)


func _physics_process(_delta: float) -> void:

	var keymap = get_parent().data.keymap
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis(keymap.left, keymap.right)
	if direction_x:
		velocity.x = direction_x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * inertia)
	
	var direction_y := Input.get_axis(keymap.up, keymap.down)
	if direction_y:
		velocity.y = direction_y * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed * inertia)
	
	if direction_x!=0 and direction_y!=0:
		velocity.x /= 2**0.5
		velocity.y /= 2**0.5

	move_and_slide()
#
#func _on_leg_pressed() -> void:
	#speed += 100
#
#func _on_hand_pressed() -> void:
	#print("Handy")
