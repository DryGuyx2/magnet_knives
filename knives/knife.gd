extends CharacterBody2D
class_name Knife

signal entered_view(kind: String)
signal killed

@export var move_speed: int = 10000
@export var health: int = 3
@export var attack: int = 1
@export var knockback: int = 100000
@export var kind: String
var player: Player

@onready var attack_box: Area2D = $AttackBox
@onready var hurt_box: Area2D = $HurtBox
@onready var on_screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	z_index = 3
	on_screen_notifier.connect("screen_entered", _on_screen_entered)
	set_collision_mask_value(Global.collision_layers["physics_walls_only"], true)
	
	hurt_box.set_collision_layer_value(Global.collision_layers["knife_detection"], true)
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
		emit_signal("killed")
		queue_free()

func _on_attack_box_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("damage"):
		area.get_parent().damage(attack, (player.global_position - global_position).normalized() * knockback, kind)

func _on_screen_entered() -> void:
	emit_signal("entered_view", kind)
