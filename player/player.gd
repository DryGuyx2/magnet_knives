extends CharacterBody2D
class_name Player

signal dead
signal hurt(health: int)

enum State {
	IDLE,
	MOVING,
	DASHING,
}

@export var main_scene: Node2D
@export var move_speed: int = 20000
@export var initial_state: State = State.IDLE
@export var dash_speed: int = 30000
@export var dash_duration: float = 1
@export var gun_cooldown_time: float = 0.5
@export var max_health: int = 2

@onready var player_animations: AnimatedSprite2D = $Body
@onready var hand_pivot: Node2D = $HandPivot
@onready var gun_animations: AnimatedSprite2D = $HandPivot/Hands/Gunpivot/Gun
@onready var gun_pivot: Node2D = $HandPivot/Hands/Gunpivot
@onready var hands: AnimatedSprite2D = $HandPivot/Hands
@onready var muzzle: Node2D = $HandPivot/Hands/Gunpivot/Gun/Muzzle
@export var cursor: Cursor

var BULLET_SCENE = preload("res://player/bullet/bullet.tscn")

var move_direction: Vector2 = Vector2.ZERO 
var last_moved_direction: Vector2 = Vector2.LEFT

var health: int = max_health
var current_state: State = initial_state 

func _ready() -> void:
	set_collision_layer_value(Global.collision_layers["physics"], true)
	set_collision_mask_value(Global.collision_layers["physics"], true)
	
	set_collision_layer_value(Global.collision_layers["player_detection"], true)
	hands.play()

func _physics_process(delta: float) -> void:
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down") 
	if move_direction != Vector2.ZERO:
		last_moved_direction = move_direction
	update_state() 
	if current_state == State.MOVING:
		velocity = move_direction * move_speed * delta + knockback_buffer * delta 
	elif current_state == State.IDLE:
		velocity = knockback_buffer * delta 
	elif current_state == State.DASHING:
		velocity = move_direction * dash_speed * delta
		dash_time_left -= delta
		if dash_time_left <= 0:
			exit_dash()
	knockback_buffer = lerp(knockback_buffer, Vector2.ZERO, 0.1)
	handle_gun(delta)
	handle_animations()
	move_and_slide()

var dash_time_left: float = dash_duration 
func engage_dash() -> void:
	hands.visible = false
	dash_time_left = dash_duration
	current_state = State.DASHING

func exit_dash() -> void:
	hands.visible = true
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
	var mouse_direction = get_mouse_string_direction()
	
	player_animations.flip_h = mouse_direction == "right"
	
	if mouse_direction in ["left", "right"]:
		mouse_direction = "sideways"
	
	gun_animations.z_index = int(mouse_direction == "up") + 1
	
	if current_state == State.MOVING:
		player_animations.play("moving_%s" % mouse_direction)
	elif current_state == State.IDLE:
		player_animations.play("idle_%s" % mouse_direction)
	elif current_state == State.DASHING:
		var dash_direction = direction_to_string(move_direction)
		player_animations.flip_h = dash_direction == "right"
		if dash_direction in ["left", "right"]:
			dash_direction = "sideways"
		
		player_animations.play("dash_%s" % dash_direction)

func get_mouse_string_direction() -> String:
	var mouse_position = get_local_mouse_position()
	if mouse_position.abs().x > mouse_position.abs().y:
		if mouse_position.x < 0:
			return "left"
		if mouse_position.x > 0:
			return "right"
	
	if mouse_position.y > 0:
		return "down"
	
	if mouse_position.y < 0:
		return "up"
	
	# If the mouse is at dead center we default to left
	return "left"

func direction_to_string(direction: Vector2) -> String:
	if direction.x > 0:
		return "right"
	
	if direction.x < 0:
		return "left"
	
	if direction.y > 0:
		return "down"
	
	if direction.y < 0:
		return "up"
	
	return "left"

var gun_cooldown_time_left: float = gun_cooldown_time
var gun_on_cooldown = false

func handle_gun(delta: float) -> void:
	if cursor.global_position.x < global_position.x:
		hand_pivot.scale.x = -1
	elif cursor.global_position.x > global_position.x:
		hand_pivot.scale.x = 1
	
	gun_animations.look_at(cursor.position)
	
	if gun_on_cooldown:
		gun_cooldown_time_left -= delta
	if gun_cooldown_time_left <= 0:
		gun_on_cooldown = false
	
	if Input.is_action_pressed("shoot") and not gun_on_cooldown:
		gun_animations.play()
		var bullet = BULLET_SCENE.instantiate()
		bullet.global_position = muzzle.global_position
		bullet.target = cursor.position
		main_scene.add_child(bullet)
		gun_on_cooldown = true
		gun_cooldown_time_left = gun_cooldown_time

var knockback_buffer: Vector2 = Vector2.ZERO
func damage(amount: int, knockback: Vector2) -> void:
	health -= amount
	knockback_buffer = knockback
	
	if health < 1:
		emit_signal("dead")
		queue_free()
	
	emit_signal("hurt", health)
