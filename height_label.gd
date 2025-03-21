extends Label3D

var best_height = 0
var cur_height = 0
var tween = create_tween()
signal score_pos(num)

#func _on_player_height(num: Variant) -> void:
	#if int(num) > best_height:
		#best_height = int(num)
	#text = "%s" % best_height

func _on_player_height(num: Variant) -> void:
	#position.y = num
	if cur_height > int(num) and PhaseTrack.get_phase() == 2:
		score_pos.emit(get_viewport().get_camera_3d().unproject_position(global_transform.origin))
		text = "%s" % cur_height
	cur_height = int(num)
	text = "%s" % int(num)


func _on_player_horizont(num: Variant) -> void:
	tween.set_ease(Tween.EASE_IN)
	var coeff = 3
	if position.x > 10:
		coeff = -3
	#print("pos x %s" % position.x)
	#print("num %s" % num)
	#print("coeff %s" % coeff)
	tween.tween_method(horizont_fade, offset.x, num + coeff, 0.25)
#
func horizont_fade(num: Variant) -> void:
	offset.x = num
