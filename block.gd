extends Node3D

@onready var top = $Top.get_surface_override_material(0)
@onready var bottom = $Bottom.get_surface_override_material(0)
@onready var anim = $AnimationPlayer
@onready var digit_node = $Bottom

var bot_digit = 0
var top_digit = 1

var last_score = 0
var last_update_time = 0.0
var base_anim_time = 0.2  # Base duration of the animation

func spawn():
	anim.play("spawn")

func change_digit(new_digit: int, current_score: int):
	
	# Calculate the speed multiplier based on the score change rate
	var current_time = Time.get_ticks_msec() / 1000.0  # Current time in seconds
	var delta_time = max(current_time - last_update_time, 0.01)  # Prevent division by zero
	var score_change_rate = abs(current_score - last_score) / delta_time  # How fast the score is changing
	
	if new_digit == bot_digit or anim.is_playing():
		return
	
	last_score = current_score
	last_update_time = current_time
	
	print(score_change_rate)
	# Normalize the speed factor (higher rate = faster animation)
	var speed_factor = clamp(score_change_rate / 50.0, 1.0, 10.0)  # Tune divisor (50.0) for balance
	if last_score < 40:
		speed_factor = 10
	anim.speed_scale = speed_factor
	
	top.uv1_offset = Vector3(new_digit * 0.1, 1.0, 0)
	anim.play("rotate")
	
	bot_digit = new_digit
	await anim.animation_finished  # Wait for animation to complete
	bottom.uv1_offset = Vector3(new_digit * 0.1, 1.0, 0)
	top.uv1_offset = Vector3(((new_digit + 1) % 10) * 0.1, 1.0, 0)
	anim.play("rotate_past")
