extends Node2D
class_name Main

@onready var knife_intro: KnifeIntro = $Map/Player/KnifeIntro

func _on_knife_intro_intro_finished() -> void:
	get_tree().paused = false

func _on_player_new_knife_discovered(kind: String) -> void:
	knife_intro.play_intro(kind)
	get_tree().paused = true
