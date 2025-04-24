extends CharacterBody2D
class_name Player

enum State {
	IDLE,
	MOVING,
}

@export var move_speed: int = 10000;
@export var initial_state: State = State.IDLE

@onready var animation_component: AnimatedSprite2D = $AnimatedSprite2D

var move_direction: Vector2 = Vector2.ZERO

var current_state: State = initial_state

func _physics_process(delta: float) -> void:
	handle_input(delta)
	update_state()
	velocity = move_direction * move_speed * delta
	handle_animations()
	move_and_slide()

func update_state() -> void:
	if move_direction != Vector2.ZERO:
		current_state = State.MOVING
		return
	current_state = State.MOVING

func handle_input(delta: float) -> void:
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func handle_animations():
	if move_direction.x > 0:
		animation_component.flip_h = true
	else:
		animation_component.flip_h = false
	
	if current_state == State.MOVING:
		animation_component.play("moving")
	elif current_state == State.IDLE:
		animation_component.play("idle")
