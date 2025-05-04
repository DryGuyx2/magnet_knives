extends Camera2D
class_name PlayerCamera

signal difficulty_increase

@export var player: Player

@onready var health_hud = $Health
@onready var time = $Time
var game_time = 0

var health_hud_levels = ["empty", "half", "full"]

func _process(delta: float) -> void:
	game_time += delta
	time.text = format_time()
	
	if int(game_time) % 60 == 0:
		emit_signal("difficulty_increase")

func _ready() -> void:
	player.hurt.connect(_on_player_hurt)

func _on_player_hurt(new_health) -> void:
	health_hud.play(health_hud_levels[new_health])

func format_time() -> String:
	var seconds = int(game_time)
	var minutes = (seconds/60)
	seconds -= minutes * 60
	if len(str(seconds)) == 1:
		return "%s:0%s" % [minutes, seconds]
	return "%s:%s" % [minutes, seconds]
