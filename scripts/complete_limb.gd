extends Node2D
@export var segment_scene: PackedScene
@export var segment_count: int = 3
@export var segment_length: float = 100
@export var segment_width: float = 11

const segment = preload("res://scenes/limb_segment.tscn")
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
	

	get_child(0).position = Vector2(400, 400)

func _physics_process(_delta: float) -> void:
	get_child(0).position = get_global_mouse_position()
