extends CharacterBody2D

var speed = 0
var hp = 10
var hp_label

func _on_ready() -> void:
	hp_label = $"../Control/HP"
	hp_label.text = "HP: " + str(hp)

func _physics_process(_delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	var direction_y := Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	if direction_x!=0 and direction_y!=0:
		velocity.x /= 2**0.5
		velocity.y /= 2**0.5

	move_and_slide()

func _on_leg_pressed() -> void:
	speed += 100
	hp -= 1
	hp_label.text = "HP: " + str(hp)
	if hp<=0:
		get_tree().reload_current_scene()

func _on_hand_pressed() -> void:
	print("Handy")
