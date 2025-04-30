extends Camera2D
class_name PlayerCamera

@export var player: Player

@onready var health_hud = $Health

var health_hud_levels = ["empty", "half", "full"]

func _ready() -> void:
	player.hurt.connect(_on_player_hurt)

func _on_player_hurt(new_health) -> void:
	health_hud.play(health_hud_levels[new_health])
