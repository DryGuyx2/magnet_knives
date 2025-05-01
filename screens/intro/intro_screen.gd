extends AnimatedSprite2D
class_name IntroScreen

@onready var start_button: AnimatedSprite2D = $StartButton

func _ready() -> void:
	play()
	get_tree().paused = true

var hovered = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and hovered:
		get_tree().paused = false
		emit_signal("game_started")
		queue_free()

func _on_area_2d_mouse_entered() -> void:
	hovered = true
	start_button.play("hovered")


func _on_area_2d_mouse_exited() -> void:
	hovered = false
	start_button.play("default")
