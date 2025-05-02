extends Camera2D
class_name PlayerCamera

@export var player: Player

@onready var health_hud = $Health
@onready var time = $Time
var game_time = 0

var health_hud_levels = ["empty", "half", "full"]

func _process(delta: float) -> void:
	game_time += delta
	var seconds = int(game_time)
	var minutes = (seconds/60)
	seconds -= minutes * 60
	time.text = "%s:%s" % [minutes, seconds]

func _ready() -> void:
	player.hurt.connect(_on_player_hurt)

func _on_player_hurt(new_health) -> void:
	health_hud.play(health_hud_levels[new_health])
