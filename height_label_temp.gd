extends Label

var best_height = 0
var cur_height = 0
#var tween = create_tween()

#func _on_player_height(num: Variant) -> void:
	#if int(num) > best_height:
		#best_height = int(num)
	#text = "%s" % best_height

func _on_player_height(num: Variant) -> void:
	#position.y = num
	if cur_height > int(num):
		text = "%s" % cur_height
		return
	cur_height = int(num)
	text = "%s" % int(num)

func _on_height_label_score_pos(num: Variant) -> void:
	position = num
