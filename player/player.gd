extends CharacterBody2D
class_name Player

enum State {
	IDLE,
	MOVING,
	DASHING,
}

@export var main_scene: Node2D
@export var move_speed: int = 10000 
@export var initial_state: State = State.IDLE 
@export var dash_distance: int = 300 
@export var dash_duration: float = 1 

@onready var player_animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var hand_pivot: Node2D = $HandPivot
@onready var gun_animations: AnimatedSprite2D = $HandPivot/Hands/Gunpivot/Gun
@onready var gun_pivot: Node2D = $HandPivot/Hands/Gunpivot
@onready var hands: AnimatedSprite2D = $HandPivot/Hands
@onready var muzzle: Node2D = $HandPivot/Hands/Gunpivot/Gun/Muzzle
@export var cursor: Cursor

const HAND_1_GUN_POSITION = Vector2(1.807, -2.461)
const HAND_2_GUN_POSITION = Vector2(-5.6, -2.2)

var BULLET_SCENE = preload("res://player/bullet/bullet.tscn")

var move_direction: Vector2 = Vector2.ZERO 

var current_state: State = initial_state 

var facing_left: bool = false 

func _ready() -> void:
	hands.play()

func _physics_process(delta: float) -> void:
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down") 
	if move_direction.x != 0:
		facing_left = move_direction.x > 0
	update_state() 
	if current_state == State.MOVING:
		velocity = move_direction * move_speed * delta 
	elif current_state == State.IDLE:
		velocity = Vector2.ZERO
	handle_gun()
	handle_animations()
	move_and_slide()

func engage_dash() -> void:
	var dash_destination = global_position + move_direction * dash_distance
	var dash_tween = create_tween()
	dash_tween.tween_property(self, "position", dash_destination, dash_duration).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	dash_tween.play()
	dash_tween.tween_callback(exit_dash)

func exit_dash() -> void:
	current_state = State.IDLE

func update_state() -> void:
	if current_state == State.DASHING:
		return
	if Input.is_action_just_pressed("dash") and current_state == State.MOVING:
		current_state = State.DASHING
		engage_dash()
		return
	if move_direction != Vector2.ZERO:
		current_state = State.MOVING
		return
	current_state = State.IDLE

func handle_animations() -> void:
	player_animations.flip_h = facing_left
	
	var string_direction = get_string_direction()
	player_animations.z_index = int(string_direction == "up")
	
	if current_state == State.MOVING:
		player_animations.play("moving_%s" % string_direction)
	elif current_state == State.IDLE:
		player_animations.play("idle_%s" % string_direction)

func get_string_direction() -> String:
	if move_direction.x != 0:
		return "sideways"
	
	if move_direction.y > 0:
		return "down"
	
	if move_direction.y < 0:
		return "up"
	
	return "none"

func handle_gun() -> void:
	if cursor.global_position.x < global_position.x:
		hand_pivot.scale.x = 1
	elif cursor.global_position.x > global_position.x:
		hand_pivot.scale.x = -1
	
	gun_animations.look_at(cursor.position)
	
	if Input.is_action_just_pressed("shoot"):
		var bullet = BULLET_SCENE.instantiate()
		bullet.global_position = muzzle.global_position
		bullet.target = cursor.position
		main_scene.add_child(bullet)
