extends Node2D
class_name Main

@onready var knife_intro: KnifeIntro = $Map/Player/KnifeIntro

func _on_knife_intro_intro_finished() -> void:
	get_tree().paused = false

func _on_player_new_knife_discovered(kind: String) -> void:
	knife_intro.play_intro(kind)
	get_tree().paused = true

func _on_player_dead(_knife_kind: String) -> void:
	get_tree().paused = true

@onready var master_bus = AudioServer.get_bus_index("Master")
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("volume_up"):
		AudioServer.set_bus_volume_db(master_bus, AudioServer.get_bus_volume_db(master_bus) + 10)
	if Input.is_action_just_pressed("volume_down"):
		AudioServer.set_bus_volume_db(master_bus, AudioServer.get_bus_volume_db(master_bus) - 10)

func _on_death_screen_restart() -> void:
	get_tree().paused = false
	$Map/Player.reset()
	$Map/KnifeSpawnerManager.reset()
	$Map/Player/Camera.reset()
	$Music.start()
