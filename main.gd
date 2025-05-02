extends Node2D
class_name Main

@onready var knife_intro: KnifeIntro = $Map/Player/KnifeIntro

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_1"):
		new_knife("walking")

func new_knife(kind: String) -> void:
	knife_intro.play_intro(kind)
	get_tree().paused = true

func _on_knife_intro_intro_finished() -> void:
	get_tree().paused = false
