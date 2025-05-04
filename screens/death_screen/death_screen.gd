extends Node2D
class_name DeathScreen

var death_cause: String
func _on_player_dead(knife_kind: String) -> void:
	print("AAA")
	death_cause = knife_kind
	play()

func play() -> void:
	$DeathCause.text = death_cause
	$TimeSurvived.text = get_parent().find_child("Camera").format_time()
	$KnivesKilled.text = str(get_parent().knives_killed)
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1, 1)
	#fade_tween.tween_callback(finished_fading)
