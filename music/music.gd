extends AudioStreamPlayer
class_name Music

func start() -> void:
	var fade_in_tween = create_tween()
	fade_in_tween.tween_property(self, "volume_db", 10, 5)
	play()

func end() -> void:
	var fade_in_tween = create_tween()
	fade_in_tween.tween_property(self, "volume_db", -30, 5)
	stop()


func _on_player_dead(_knife_kind: String) -> void:
	end()

func _on_finished() -> void:
	start()
