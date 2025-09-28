extends Label

var number: int = 0

func _ready() -> void:
	for child in $"../../".get_children():
		if child is Node2D and child is not Sprite2D:
			var children = child.get_node("Control/Ready")
			if not children.toggled.is_connected(_on_toggled):
				children.toggled.connect(_on_toggled)

func _on_toggled(toggled_on: bool):
	var delta = -1
	if toggled_on:
		delta = 1
	number += delta
	$".".text = "Ready? " + str(number) + "/2"
	if number == 2:
		get_tree().change_scene_to_file("res://scenes/test.tscn")
