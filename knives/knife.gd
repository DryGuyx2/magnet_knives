extends CharacterBody2D
class_name Knife

@export var move_speed: int = 10000
@export var health: int = 3
@export var attack: int = 1
@export var knockback: int = 100000
var player: Player

@onready var attack_box: Area2D = $AttackBox

func _ready() -> void:
	set_collision_mask_value(Global.collision_layers["physics"], true)
	
	set_collision_layer_value(Global.collision_layers["knife_detection"], true)
	attack_box.set_collision_mask_value(Global.collision_layers["player_detection"], true)

var knockback_buffer: Vector2 = Vector2.ZERO
func _physics_process(delta: float) -> void:
	look_at(player.global_position)
	velocity = (player.global_position - global_position).normalized() * move_speed * delta + knockback_buffer * delta
	knockback_buffer = lerp(knockback_buffer, Vector2.ZERO, 0.1)
	move_and_slide()

func damage(amount: int, knockback: Vector2) -> void:
	health -= amount
	knockback_buffer = knockback
	
	if health < 1:
		queue_free()

func _on_attack_box_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("damage"):
		body.damage(attack, (player.global_position - global_position).normalized() * knockback)
