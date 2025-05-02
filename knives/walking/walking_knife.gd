extends Knife
class_name WalkingKnife

func _ready() -> void:
	$Legs.play()
	super()

func _process(delta: float) -> void:
	$Legs.global_rotation = 0
	$Legs.flip_h = (player.global_position - global_position).x > 0
