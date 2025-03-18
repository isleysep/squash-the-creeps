extends Label

var best_height = 0
var cur_height = 0

#func _on_player_height(num: Variant) -> void:
	#if int(num) > best_height:
		#best_height = int(num)
	#text = "%s" % best_height

func _on_player_height(num: Variant) -> void:
	text = "%s" % int(num)
