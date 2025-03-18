extends Label

var combo = 0
var score = 0
var peak_height = 0
var score_got = false

func _on_mob_squashed():
	combo += 1
	#text = "Score: %s" % score


func _on_player_height(num: Variant) -> void:
	if int(num) >= peak_height:
		peak_height = int(num)
	elif not score_got:
		score += combo * peak_height
		text = "Score: %s" % score
		score_got = true
	if PhaseTrack.get_phase() == 1:
		peak_height = 0
		score_got = false
