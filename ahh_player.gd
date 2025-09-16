extends AudioStreamPlayer

var height = 0
var ahhed = false

func _on_player_height(num: Variant) -> void:
	if num < 30:
		height = 0
		ahhed = false
	else:
		if num > height + 1:
			height = num
		elif !ahhed:
			ahhed = true
