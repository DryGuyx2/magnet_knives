extends VisibleOnScreenNotifier2D
class_name KnifeSpawner

var player: Player
var spawn_node: Node2D

var KNIFE_SCENES = {
	"simple": preload("res://knives/simple/simple_knife.tscn"),
	"jpeg": preload("res://knives/jpeg/jpeg_knife.tscn"),
	"walking": preload("res://knives/walking/walking_knife.tscn"),
}

func spawn(kind: String) -> void:
	var knife = KNIFE_SCENES[kind].instantiate()
	knife.player = player
	knife.global_position = global_position
	knife.connect("entered_view", player.knife_entered_view)
	spawn_node.add_child(knife)
