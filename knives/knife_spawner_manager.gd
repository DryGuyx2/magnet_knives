extends Node2D
class_name KnifeSpawnerManager

@export var player: Player
@export var spawn_node: Node2D
@export var difficulty_increase: int = 3
@export var knife_spawn_time: float = 5

@onready var spawners: Array = get_children()
var off_screen_spawners: Array = []

var knife_types = ["jpeg", "simple", "walking"]

var difficulty = 6

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
	
	off_screen_spawners.sort_custom(distance_from_player)
	var top_3_spawners = [off_screen_spawners[0], off_screen_spawners[1], off_screen_spawners[2]]
	
	var chosen_spawner = top_3_spawners.pick_random()
	chosen_spawner.spawn(knife_types.pick_random())

func _on_camera_difficulty_increase() -> void:
	difficulty += difficulty_increase

func distance_from_player(spawner_a: VisibleOnScreenNotifier2D, spawner_b: VisibleOnScreenNotifier2D) -> int:
	var distance_a = spawner_a.global_position - player.global_position
	var total_distance_a = distance_a.abs().x + distance_a.abs().y
	
	var distance_b = spawner_b.global_position - player.global_position
	var total_distance_b = distance_b.abs().x + distance_b.abs().y
	
	return total_distance_a < total_distance_b
