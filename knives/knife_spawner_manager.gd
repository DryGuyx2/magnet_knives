extends Node2D
class_name KnifeSpawnerManager

@export var player: Player
@export var spawn_node: Node2D
@export var difficulty_increase: int = 1
@export var knife_spawn_time: float = 10

@onready var spawners: Array = get_children()
var off_screen_spawners: Array = []

var knife_types = ["jpeg", "simple", "walking"]

var difficulty = 1

func _ready() -> void:
	for spawner in spawners:
		spawner.player = player
		spawner.spawn_node = spawn_node

var spawn_time_left = knife_spawn_time

func _process(delta: float) -> void:
	spawn_time_left -= delta
	if spawn_time_left <= 0:
		spawn_time_left = knife_spawn_time
		for knife in range(0, difficulty):
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

func _on_camera_difficulty_increase() -> void:
	difficulty += difficulty_increase
