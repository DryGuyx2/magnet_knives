extends Node2D
class_name knife_spawner

@onready var player = get_parent()
@onready var main_scene = player.get_parent()

var KNIFE_SCENE = preload("res://knife/knife.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_1"):
		var knife = KNIFE_SCENE.instantiate()
		knife.player = player
		knife.global_position = global_position
		main_scene.add_child(knife)
