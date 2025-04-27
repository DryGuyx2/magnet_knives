extends Area2D
class_name Bullet

@export var speed: int = 1000
@export var damage: int = 1
var target: Vector2
@onready var direction: Vector2 = (target - position).normalized()

func _enter_tree() -> void:
	look_at(target)

func _process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("damage"):
		area.damage(damage)
	queue_free()
