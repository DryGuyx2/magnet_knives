extends AnimatedSprite2D
class_name KnifeIntro

signal intro_finished

@onready var description_label = $Description

var knife_kind: String

func play_intro(kind: String) -> void:
	modulate.a = 1.
	knife_kind = kind
	play()

const KNIFE_TEXTS: Dictionary = {
	"walking": "He got feet???",
	"simple": "Just an average knife",
	"jpeg": "Darn it, wasn't a png",
}

func _on_animation_finished() -> void:
	match knife_kind:
		"walking": walking_intro()
		"simple": simple_intro()
		"jpeg": jpeg_intro()

func finished_intro() -> void:
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property(self, "modulate:a", 0, 1)
	fade_out_tween.tween_callback(exit)

func exit() -> void:
	emit_signal("intro_finished")

func walking_intro() -> void:
	$WalkingKnifeBody.visible = true
	$WalkingKnifeBody/WalkingKnifeLegs.play()
	var walk_tween = create_tween()
	walk_tween.tween_property($WalkingKnifeBody, "global_position", $WalkingKnifeEndPoint.global_position, 1)
	walk_tween.tween_callback(write_text)

func simple_intro() -> void:
	pass

func jpeg_intro() -> void:
	pass


func write_text() -> void:
	var text = KNIFE_TEXTS[knife_kind]
	var displayed_text: String
	for character in text:
		displayed_text = "%s%s" % [displayed_text, character]
		description_label.text = displayed_text
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(2).timeout
	finished_intro()
