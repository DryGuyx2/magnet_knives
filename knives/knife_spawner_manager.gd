extends Node2D
class_name KnifeSpawnerManager

@export var player: Player
@export var spawn_node: Node2D

@onready var spawners: Array = get_children()
var off_screen_spawners: Array = []

var knife_types = ["jpeg", "simple", "walking"]

func _ready() -> void:
	for spawner in spawners:
		spawner.player = player
		spawner.spawn_node = spawn_node

func _process(delta):
	if Input.is_action_just_pressed("test_4"):
		spawn_knife()

func spawn_knife() -> void:
	off_screen_spawners = []
	for spawner in spawners:
		if not spawner.is_on_screen():
			off_screen_spawners.append(spawner)
	
	var chosen_spawner = off_screen_spawners.pick_random()
	if not chosen_spawner:
		return
	chosen_spawner.spawn(knife_types.pick_random())
