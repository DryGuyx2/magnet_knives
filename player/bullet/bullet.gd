extends Area2D
class_name Bullet

@export var speed: int = 1000
@export var damage: int = 1
@export var knockback: int = 10000
var target: Vector2
@onready var direction: Vector2 = (target - position).normalized()

func _enter_tree() -> void:
	look_at(target)

func _ready() -> void:
	set_collision_layer_value(Global.collision_layers["physics"], true)
	set_collision_mask_value(Global.collision_layers["physics"], true)
	
	set_collision_mask_value(Global.collision_layers["knife_detection"], true)

func _process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_body_entered(body: CharacterBody2D):
	if body.has_method("damage"):
		body.damage(damage, direction * knockback)
	queue_free()
