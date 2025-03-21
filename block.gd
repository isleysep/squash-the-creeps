extends Node3D

@onready var top = $Top.get_surface_override_material(0)
@onready var bottom = $Bottom.get_surface_override_material(0)
@onready var anim = $AnimationPlayer

var bot_digit = 1
var top_digit = 2

func spawn():
	anim.play("spawn")

func change_digit(new_digit: int):
	print(new_digit)
	if new_digit == bot_digit:
		return
	if anim.is_playing():
		await anim.animation_finished
	top.uv1_offset = Vector3(new_digit*0.1, 1.0, 0)
	anim.play("rotate")
	await get_tree().create_timer(0.19).timeout
	bottom.uv1_offset = Vector3(new_digit/10, 1.0, 0)
