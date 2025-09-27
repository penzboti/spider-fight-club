extends RigidBody2D
@export var segment_length: float = 100.0
@export var segment_width: float = 0
@export var segment_mass: float = 0

func _ready():
	# ensure sizes are valid integers for image creation and shape
	if segment_length <= 0:
		segment_length = 1.0
	if segment_width <= 0:
		segment_width = 1.0
	# continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	# contact_monitor = true
	# max_contacts_reported = 5
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
	image.fill(Color(1, 1, 1, 1))
	$SegmentSprite.texture = ImageTexture.create_from_image(image)
	

func fling(force: Vector2):
	var end_point = Vector2(segment_length, 0)
	apply_impulse(force, end_point)
