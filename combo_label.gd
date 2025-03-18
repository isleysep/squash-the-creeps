extends Label

var combo = 0

#func _on_mob_squashed():
	#combo += 1
	#text = "Combo: %s" % combo


func _on_player_combo(num: Variant) -> void:
	text = "Combo: %s" % num
