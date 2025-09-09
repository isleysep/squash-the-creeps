extends AudioStreamPlayer

enum DrummerState { IDLE, ROLL_FAST, ROLL, FILL, END }
var state = DrummerState.IDLE
var time_since_last_hit = 0.0
var roll_interval = 0.075
var last_height = 0
var fill_started = false
var height = 0

#func _ready():
	#set_max_polyphony(3)

func _process(delta):
	if state == DrummerState.ROLL_FAST:
		time_since_last_hit += delta
		if time_since_last_hit > roll_interval:
			pitch_scale = randf_range(0.98, 1.02)
			set_volume_linear(randf_range(0.8, 1.2))
			play()
			time_since_last_hit = 0.0

func play_sound():
	state = DrummerState.ROLL_FAST

func play_fill():
	state = DrummerState.ROLL

func stop_sound():
	state = DrummerState.IDLE


func _on_player_height(num: Variant) -> void:
	
	if state == DrummerState.ROLL and int(num) > last_height:
		pitch_scale = randf_range(0.98, 1.02)
		set_volume_linear(randf_range(0.8, 1.2))
		play()
		last_height = int(num)
	if num < 30:
		last_height = 0
		fill_started = false
	else:
		if num > height + 1:
			height = num
		elif !fill_started:
			play_fill()
			fill_started = true
