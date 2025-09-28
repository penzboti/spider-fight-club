extends CharacterBody2D

# Player speed initially 0, can be increased by more legs
var speed = 0
var inertia: float = float(1) / float(25)

func _ready() -> void:
	collision_layer = 1
	collision_mask = 1
	for i in %LimbAttachPoints.get_children() as Array[Marker2D]:
		var offset = i.position - position
		i.set_meta("offset", offset*scale.x)

func _physics_process(delta: float) -> void:
	var parent = get_parent()
	var data = parent.data
	var keymap = data.keymap

	speed = data.legs* 5000

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis(keymap.left, keymap.right)
	if direction_x:
		velocity.x = direction_x * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed * inertia)

	var direction_y := Input.get_axis(keymap.up, keymap.down)
	if direction_y:
		velocity.y = direction_y * speed * delta
	else:
		velocity.y = move_toward(velocity.y, 0, speed * inertia)

	if direction_x!=0 and direction_y!=0:
		velocity.x /= 2**0.5
		velocity.y /= 2**0.5

	move_and_collide(velocity * delta)
	for i in %LimbAttachPoints.get_children():
		i.position = position + i.get_meta("offset")
