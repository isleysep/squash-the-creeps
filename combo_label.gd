extends Label

var combo = 0
var best_combo = 0

#func _on_mob_squashed():
	#combo += 1
	#text = "Combo: %s" % combo


func _on_player_combo(num: Variant) -> void:
	best_combo = max(best_combo, num)
	text = "Combo: %s\nBest: %s" % [num, best_combo]
