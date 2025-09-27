extends Node2D

const shop_scene := preload("res://scenes/shop_half.tscn")

func _ready() -> void:
	spawn_half(0)
	spawn_half(1)

func spawn_half(i: int) -> void:
	var shop: Node2D
	shop = shop_scene.instantiate()
	shop.index = i;
	
	#shop.get_node("CharacterBody2D/Control/Name").text = "player " + str(i);
	print("shop " + str(i))
	
	# Set start position
	if shop.has_method("set_global_position"):
		shop.global_position = Vector2(i*get_viewport_rect().size.x / 2, 0)
	
	add_child(shop)
	
