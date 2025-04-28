extends CharacterBody2D
class_name Knife

@export var move_speed: int = 40
@export var health: int = 3
var player: Player

func _ready() -> void:
	set_collision_layer_value(Global.collision_layers["physics"], true)
	set_collision_mask_value(Global.collision_layers["physics"], true)
	
	set_collision_layer_value(Global.collision_layers["knife_detection"], true)
	set_collision_mask_value(Global.collision_layers["player_detection"], true)

var knockback_buffer: Vector2 = Vector2.ZERO
func _physics_process(delta: float) -> void:
	look_at(player.global_position)
	velocity = (player.global_position - global_position) * move_speed * delta + knockback_buffer * delta
	knockback_buffer = lerp(knockback_buffer, Vector2.ZERO, 0.1)
	move_and_slide()

func damage(amount: int, knockback: Vector2) -> void:
	health -= amount
	knockback_buffer = knockback
	
	if health < 1:
		queue_free()
