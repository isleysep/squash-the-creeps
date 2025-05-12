extends ProgressBar

var best_height = 0

func _ready():
	visible = false

func _on_player_height(num: Variant) -> void:
	if num < 15:
		best_height = 0
		visible = false
	elif num > best_height:
		best_height = num
		visible = false
	elif num < best_height:
		value = (num/best_height)*100
		visible = false
