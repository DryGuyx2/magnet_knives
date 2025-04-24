extends CharacterBody2D
class_name Player

@export var move_speed: int = 10000;

@onready var animation_component: AnimatedSprite2D = $AnimatedSprite2D

var move_direction: Vector2 = Vector2.ZERO
func _physics_process(delta: float) -> void:
	handle_input(delta)
	velocity = move_direction * move_speed * delta
	handle_animations()
	move_and_slide()


func handle_input(delta: float) -> void:
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func handle_animations():
	if move_direction.x > 0:
		animation_component.flip_h = true
	else:
		animation_component.flip_h = false
	
	if move_direction != Vector2.ZERO:
		animation_component.play("moving")
		return
	
	animation_component.play("idle")
