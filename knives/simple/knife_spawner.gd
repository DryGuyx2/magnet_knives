extends Node2D
class_name knife_spawner

@onready var player = get_parent()
@onready var main_scene = player.get_parent()

var KNIFE_SCENES = {
	"simple": preload("res://knives/simple/simple_knife.tscn"),
	"jpeg": preload("res://knives/jpeg/jpeg_knife.tscn"),
}

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_1"):
		var knife = KNIFE_SCENES["simple"].instantiate()
		knife.player = player
		knife.global_position = global_position
		main_scene.add_child(knife)
	if Input.is_action_just_pressed("test_2"):
		var knife = KNIFE_SCENES["jpeg"].instantiate()
		knife.player = player
		knife.global_position = global_position
		main_scene.add_child(knife)
