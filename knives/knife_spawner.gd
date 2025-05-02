extends VisibleOnScreenNotifier2D
class_name KnifeSpawner

var player: Player
var main_scene: Main

var KNIFE_SCENES = {
	"simple": preload("res://knives/simple/simple_knife.tscn"),
	"jpeg": preload("res://knives/jpeg/jpeg_knife.tscn"),
	"walking": preload("res://knives/walking/walking_knife.tscn"),
}

func spawn(kind: String) -> void:
	var knife = KNIFE_SCENES[kind].instantiate()
	knife.player = player
	knife.global_position = global_position
	main_scene.add_child(knife)

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
	if Input.is_action_just_pressed("test_3"):
		var knife = KNIFE_SCENES["walking"].instantiate()
		knife.player = player
		knife.global_position = global_position
		main_scene.add_child(knife)
