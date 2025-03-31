extends Node3D

var last_score = 0
var dormant = true
@onready var blocks = [$Digit1, $Digit2, $Digit3, $Digit4, $Digit5]

func on_score(num: int):
	if dormant or num < last_score:
		return
	var num_str = str(num)  # Convert score to string to access each digit
	var num_digits = num_str.length()

	# Ensure visibility of necessary digits and hide the unused ones
	for i in range(5):
		if i < num_digits:
			blocks[i].visible = true
			blocks[i].change_digit(int(num_str[num_digits - 1 - i]), num)  # Reverse order for places
			if i == 2:
				print("digit 3: %s digit 2: %s" % [num_str[num_digits - 1 - i],num_str[num_digits - 1 - 1]])
		else:
			blocks[i].visible = false  # Hide unused digits

	# Update last_score
	last_score = num

func wake():
	dormant = false

func reset():
	if dormant:
		pass
	for i in range(5):
		blocks[i].change_digit(0, 0)
		blocks[i].visible = false
	dormant = true
	last_score = 0
