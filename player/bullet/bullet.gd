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
	set_collision_mask_value(Global.collision_layers["knife_detection"], true)
	set_collision_mask_value(Global.collision_layers["physics_walls_only"], true)

func _process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_area_entered(area: Area2D):
	if area.get_parent().has_method("damage"):
		area.get_parent().damage(damage, direction * knockback)
	queue_free()

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	queue_free()
