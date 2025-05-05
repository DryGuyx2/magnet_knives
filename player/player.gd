extends CharacterBody2D
class_name Player

signal dead(knife_kind: String)
signal hurt(health: int)
signal new_knife_discovered(kind: String)

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
@onready var hand_pivot: Node2D = $Body/HandPivot
@onready var gun_animations: AnimatedSprite2D = $Body/HandPivot/Hands/Gunpivot/Gun
@onready var gun_pivot: Node2D = $Body/HandPivot/Hands/Gunpivot
@onready var hands: AnimatedSprite2D = $Body/HandPivot/Hands
@onready var muzzle: Node2D = $Body/HandPivot/Hands/Gunpivot/Gun/Muzzle
@export var cursor: Cursor
@onready var step_sound: AudioStreamPlayer = $Step

var BULLET_SCENE = preload("res://player/bullet/bullet.tscn")

var move_direction: Vector2 = Vector2.ZERO 
var last_moved_direction: Vector2 = Vector2.LEFT
var dash_direction: Vector2 = Vector2.ZERO

var health: int = max_health
var current_state: State = initial_state
var invincible: bool = false

func _ready() -> void:
	set_collision_mask_value(Global.collision_layers["physics"], true)
	
	$HurtBox.set_collision_layer_value(Global.collision_layers["player_detection"], true)
	hands.play()

var played_step: bool = false

func _physics_process(delta: float) -> void:
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down") 
	if move_direction != Vector2.ZERO:
		last_moved_direction = move_direction
	update_state() 
	if current_state == State.MOVING:
		velocity = move_direction * move_speed * delta + knockback_buffer * delta
		if player_animations.frame == 1 or player_animations.frame == 3:
			if not played_step:
				step_sound.play()
				played_step = true
		else:
			played_step = false
	elif current_state == State.IDLE:
		velocity = knockback_buffer * delta 
	elif current_state == State.DASHING:
		velocity = dash_direction * dash_speed * delta
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
	dash_direction = move_direction
	
	$Dash.play()
	var string_dash_direction = direction_to_string(dash_direction)
	player_animations.flip_h = string_dash_direction == "right"
	if string_dash_direction in ["left", "right"]:
		string_dash_direction = "sideways"
		
	player_animations.play("dash_%s" % string_dash_direction)

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

var flashing = false
func handle_animations() -> void:
	if invincible:
		var flash_tween = create_tween()
		flash_tween.tween_property(player_animations, "modulate:a", 0, 0.2)
		flash_tween.tween_callback(deflash)
	if current_state == State.DASHING:
		return
	
	var mouse_direction = get_mouse_string_direction()
	
	player_animations.flip_h = mouse_direction == "right"
	
	if mouse_direction in ["left", "right"]:
		mouse_direction = "sideways"
	
	gun_animations.z_index = int(mouse_direction == "up") + 1
	hands.z_index = int(mouse_direction != "up") + 2
	
	if current_state == State.MOVING:
		player_animations.play("moving_%s" % mouse_direction)
	elif current_state == State.IDLE:
		player_animations.play("idle_%s" % mouse_direction)

func deflash() -> void:
	var deflash_tween = create_tween()
	deflash_tween.tween_property(player_animations, "modulate:a", 1, 0.2)
	deflash_tween.tween_callback(finish_flash)

func finish_flash() -> void:
	flashing = false

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
	
	if Input.is_action_pressed("shoot") and not gun_on_cooldown and not current_state == State.DASHING:
		gun_animations.play()
		$Body/HandPivot/Hands/Gunpivot/Gun/GunFire.play()
		var bullet = BULLET_SCENE.instantiate()
		bullet.global_position = muzzle.global_position
		bullet.target = cursor.position
		main_scene.add_child(bullet)
		gun_on_cooldown = true
		gun_cooldown_time_left = gun_cooldown_time

var knockback_buffer: Vector2 = Vector2.ZERO
func damage(amount: int, knockback: Vector2, knife_kind) -> void:
	if current_state == State.DASHING or invincible:
		return
	
	health -= amount
	knockback_buffer = knockback
	$DamageCooldown.start()
	$Hurt.play()
	invincible = true
	
	if health <= 0:
		emit_signal("dead", knife_kind)
	
	emit_signal("hurt", health)

var discovered_knives = []
func knife_entered_view(kind: String) -> void:
	if kind not in discovered_knives:
		discovered_knives.append(kind)
		emit_signal("new_knife_discovered", kind)

var knives_killed = 0
func knife_killed() -> void:
	knives_killed += 1

func _on_damage_cooldown_timeout() -> void:
	invincible = false

func reset() -> void:
	health = max_health
	knives_killed = 0
	current_state = State.IDLE
	emit_signal("hurt", health)
