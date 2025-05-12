extends AudioStreamPlayer

func play_sound():
	#print(pitch_scale)
	play()
	pitch_scale += 0.01

func reset_pitch():
	pitch_scale = 1.0
