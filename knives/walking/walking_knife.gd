extends Knife
class_name WalkingKnife

func _ready() -> void:
	$Legs.play()
	super()
	set_collision_mask_value(Global.collision_layers["physics_walls_only"], false)
	set_collision_mask_value(Global.collision_layers["physics"], true)
	z_index = 1

func _process(delta: float) -> void:
	$Legs.global_rotation = 0
	$Legs.flip_h = (player.global_position - global_position).x > 0
