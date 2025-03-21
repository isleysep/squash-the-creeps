extends Node3D

var last_score = 0
var last_x = 0
@onready var blocks = [$Digit1, $Digit2, $Digit3, $Digit4, $Digit5]


func on_score(num: int):
	#print("score: %s" % num)
	var num_str = str(num)  # Convert score to string to access each digit
	var num_digits = num_str.length()
	var last_digits = str(last_score).length()

	# If the number of digits increased, instantiate a new block
	if num_digits > last_digits:
		blocks[num_digits]
	# Assign each block its respective digit
	for i in range(5):
		if i < num_digits + 1:
			blocks[i].change_digit(int(num_str[-i]))

	# Update last_score
	last_score = num
