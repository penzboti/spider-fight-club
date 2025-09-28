extends Node2D
@export var segment_count: int = 3
@export var segment_length: float = 100
@export var segment_width: float = 11
@export var type: String
@export var color: Color = Color(1, 1, 1, 1)
@export var attachment_point: Node2D = null

const segment = preload("res://scenes/limb_segment.tscn")

func base(settype, setcolor: Color=Color(1, 1, 1, 1), setsegment_count: int=3, setsegment_length: float=100, setsegment_width: float=11, setattachment_point: Node2D=null) -> void:
	type = settype
	color = setcolor
	segment_count = setsegment_count
	segment_length = setsegment_length
	segment_width = setsegment_width
	attachment_point = setattachment_point

func _ready():
	# assume the first child is the StaticBody2D anchor from the scene
	var prev_segment = get_child(0)
	for i in range(segment_count):
		var new_segment = segment.instantiate()
		var j:float=0
		if i != 0:
			j = segment_length
		
		var new_segment_rel_pos = Vector2(j, 0)
		# set size before adding so the segment's internal nodes are updated on _ready
		new_segment.segment_length = segment_length
		new_segment.segment_width = segment_width
		new_segment.position = prev_segment.position + new_segment_rel_pos
		add_child(new_segment)
		new_segment._set_color(color)

		# create joint at the connecting edge between prev and new segment
		var joint = PinJoint2D.new()
		joint.node_a = prev_segment.get_path()
		joint.node_b = new_segment.get_path()
		if i == 0:
			joint.bias = 1.0
			joint.softness = 0.0
		# position joint at the connecting edge between segments (new segment origin)
		# this places the pin at the right edge of the previous segment / left edge of the new
		joint.position = new_segment.position
		add_child(joint)
		prev_segment = new_segment
	

	

func _physics_process(_delta: float) -> void:
	get_child(0).position = attachment_point.position

func _set_color(new_color: Color) -> void:
	color = new_color
	for i in get_children():
		if i is RigidBody2D:
			i._set_color(color)
