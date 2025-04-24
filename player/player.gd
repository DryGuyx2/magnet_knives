extends CharacterBody2D
class_name Player

enum State {
	IDLE,
	MOVING,
	DASHING,
}

@export var move_speed: int = 10000;
@export var initial_state: State = State.IDLE;
@export var dash_distance: int = 300;
@export var dash_duration: float = 1;

@onready var animation_component: AnimatedSprite2D = $AnimatedSprite2D;

var move_direction: Vector2 = Vector2.ZERO;

var current_state: State = initial_state;

var facing_left: bool = false;

func _physics_process(delta: float) -> void:
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	if move_direction.x != 0:
		facing_left = move_direction.x > 0
	update_state();
	velocity = move_direction * move_speed * delta;
	handle_animations();
	move_and_slide();

func engage_dash() -> void:
	var dash_destination = global_position + move_direction * dash_distance
	print(dash_destination)
	var dash_tween = create_tween()
	dash_tween.tween_property(self, "position", dash_destination, dash_duration).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	
func update_state() -> void:
	if current_state == State.DASHING:
		return
	if Input.is_action_just_pressed("dash"):
		current_state = State.DASHING
		engage_dash()
	if move_direction != Vector2.ZERO:
		current_state = State.MOVING
		return
	current_state = State.MOVING

func handle_animations():
	animation_component.flip_h = facing_left
	
	if current_state == State.MOVING:
		animation_component.play("moving")
	elif current_state == State.IDLE:
		animation_component.play("idle")
