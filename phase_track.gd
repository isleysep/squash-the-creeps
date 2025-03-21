extends Node

#signal phase(num)

var cur_phase = 1

func get_phase():
	return cur_phase

func set_phase(num):
	cur_phase = num
	#phase.emit(cur_phase)
