extends Node2D
class_name DeathScreen

signal restart

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

func _on_death_animation_animation_finished() -> void:
	var fade_tween = create_tween()
	fade_tween.tween_property($Background, "modulate:a", 1, 0.5)

var restart_button_hovered: bool = false
func _on_hover_area_mouse_entered() -> void:
	$Background/RestartButton.play("hovered")
	restart_button_hovered = true

func _on_hover_area_mouse_exited():
	$Background/RestartButton.play("default")
	restart_button_hovered = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and restart_button_hovered and modulate.a == 1:
		emit_signal("restart")
		reset()

func reset() -> void:
	modulate.a = 0
	$Background.modulate.a = 0
	$DeathAnimation.frame = 0
