extends AnimatedSprite2D
class_name IntroScreen

@onready var start_button: AnimatedSprite2D = $StartButton
@onready var cartoon: Sprite2D = $Cartoon
@onready var cartoon_end_position: Node2D = $CartoonEndPosition

func _ready() -> void:
	play()
	get_tree().paused = true

var hovered: bool = false
var cartoon_playing: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and hovered and not cartoon_playing:
		show_cartoon()

func _on_area_2d_mouse_entered() -> void:
	hovered = true
	start_button.play("hovered")

func _on_area_2d_mouse_exited() -> void:
	hovered = false
	start_button.play("default")

func show_cartoon() -> void:
	cartoon_playing = true
	var cartoon_fade_tween = create_tween()
	cartoon_fade_tween.tween_property(cartoon, "modulate:a", 1, 1)
	cartoon_fade_tween.tween_callback(move_cartoon)

func move_cartoon() -> void:
	self_modulate.a = 0
	start_button.modulate = 0
	$Keys.modulate = 0
	var cartoon_move_tween = create_tween()
	cartoon_move_tween.tween_property(cartoon, "global_position", cartoon_end_position.global_position, 10)
	cartoon_move_tween.tween_callback(finished_move)

func finished_move() -> void:
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property(cartoon, "modulate:a", 0, 1)
	fade_out_tween.tween_callback(finish_cartoon)

func finish_cartoon() -> void:
	get_tree().paused = false
	queue_free()
