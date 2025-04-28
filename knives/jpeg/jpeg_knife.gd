extends Knife
class_name JpegKnife

@onready var animation_component: AnimatedSprite2D = $AnimatedSprite2D

func damage(amount, knockback) -> void:
	animation_component.play("stage_%s" % (health - 1))
	super.damage(amount, knockback)
