extends RigidBody2D
@export var segment_length: float = 100.0
@export var segment_width: float = 0.0
@export var color: Color = Color(1, 1, 1, 1)

func _ready():
	# Set collision layer for limbs (layer 2) and avoid players (layer 1)
	collision_layer = 2
	collision_mask = 1  # Only collide with other limbs, not players
	contact_monitor = true
	max_contacts_reported = 80	
	# ensure sizes are valid integers for image creation and shape
	if segment_length <= 0:
		segment_length = 1.0
	if segment_width <= 0:
		segment_width = 1.0
	# continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	# update collision shape size if it's a RectangleShape2D
	var shape = $SegmentCollision.shape
	if shape and shape is RectangleShape2D:
		shape.size = Vector2(segment_length *0.8 , segment_width)
	# elif shape and shape is CapsuleShape2D:
	# 	shape.height = segment_length
	# 	shape.radius = segment_width * 0.5

	# position collision and sprite so the RigidBody origin remains at the segment's left edge
	$SegmentCollision.position = Vector2(segment_length * 0.5, 0)
	$SegmentSprite.position = Vector2(segment_length * 0.5, 0)

	# create a simple texture sized to the segment
	var img_w = int(ceil(segment_length))
	var img_h = int(ceil(segment_width))
	var image = Image.create(img_w, img_h, false, Image.FORMAT_RGBA8)
	image.fill(color)
	$SegmentSprite.texture = ImageTexture.create_from_image(image)
	body_entered.connect(_on_body_entered)

func fling(force: Vector2):
	var end_point = Vector2(segment_length, 0)
	apply_impulse(force, end_point)

func _set_color(new_color: Color) -> void:
	color = new_color
	if $SegmentSprite.texture:
		var img_w = int(ceil(segment_length))
		var img_h = int(ceil(segment_width))
		var image = Image.create(img_w, img_h, false, Image.FORMAT_RGBA8)
		image.fill(color)
		$SegmentSprite.texture = ImageTexture.create_from_image(image)

func _on_body_entered(body):
	if get_parent() and get_parent().has_method("_on_collision"):
		get_parent()._on_collision(body)

func _set_alpha(a: float) -> void:
	color.a = a
	_set_color(color)