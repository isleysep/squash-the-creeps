extends AudioStreamPlayer3D


#func _on_player_combo(num: Variant) -> void:
	#if num > 0:
		#set_pitch_scale(1+(0.1*(num - 1)))
		#play(1.5)


func _on_player_stunt() -> void:
	play()
