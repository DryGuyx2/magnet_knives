extends Node2D
class_name DeathScreen

var death_cause: String
func _on_player_dead(knife_kind: String) -> void:
	death_cause = knife_kind
	play()

func play() -> void:
	$Background/Stats/DeathCause.text = death_cause
	$Background/Stats/TimeSurvived.text = get_parent().find_child("Camera").format_time()
	$Background/Stats/KnivesKilled.text = str(get_parent().knives_killed)
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1, 0.5)
	fade_tween.tween_callback(finished_fading)

func finished_fading() -> void:
	$DeathAnimation.play()
	await get_tree().create_timer(2.7).timeout
	$Death.play()

func _on_death_animation_animation_finished():
	var fade_tween = create_tween()
	fade_tween.tween_property($Background, "modulate:a", 1, 0.5)
