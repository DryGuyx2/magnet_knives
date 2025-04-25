extends CharacterBody2D
class_name Knife

@export var move_speed: int = 40
var player: Player

func _physics_process(delta) -> void:
	look_at(player.global_position)
	velocity = (player.global_position - global_position) * move_speed * delta
	move_and_slide()
