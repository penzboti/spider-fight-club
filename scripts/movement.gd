extends CharacterBody2D

# Player speed initially 0, can be increased by more legs
var speed = 0
var inertia: float = float(1) / float(25)

@export var push_strength: int = 3500
var knockback := Vector2.ZERO

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

	var c := move_and_collide(velocity * delta)
	if c:
		var other := c.get_collider()
		if other is CharacterBody2D:
			if $"..".is_invincible():
				return
			$"..".take_damage()
			other.get_node("..").take_damage()
			#if get_instance_id() < other.get_instance_id():
			#print("very bumm")
			var n := c.get_normal()              # normal points from other -> self
			var self_push  :=  push_strength * n
			var other_push :=  push_strength * -n

			apply_knockback(self_push)
			if other.has_method("apply_knockback"):
				other.apply_knockback(other_push)
	
	for i in %LimbAttachPoints.get_children():
		i.position = position + i.get_meta("offset")
		

func apply_knockback(impulse: Vector2) -> void:
	#print("kb")
	velocity += impulse
