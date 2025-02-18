extends Node

var combo = 0

func increase_combo():
	combo += 1
	
func reset_combo():
	combo = 0
	
func get_combo():
	return combo
