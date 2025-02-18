extends Camera3D

var last_height = 0
var falling = false

func _on_player_height(num: Variant) -> void:
	if int(num) < last_height:
		last_height = 0
		rotation.x = 0
		position.y = 0
		falling = true
	if int(num) > 30 and not falling:
		position.y = (num-30)# * smoothstep(0, 1, 0.8)
		rotation.x = 45# * smoothstep(0, 1, 0.8)
		last_height = int(num)
		print(last_height)
		
	if int(num) <= 30:
		falling = false
