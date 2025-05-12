extends MeshInstance3D

var best_height = 0
var last_height = 0
var falling = false
var phase_one = true
var onscreen = true
var first = 0
var second = 0

func _process(_delta: float) -> void:
	global_position.y = 0


func _on_player_height(num: Variant) -> void:
	if num == last_height:
		pass
	if num < 30:
		onscreen = true
		falling = false
		visible = false
		best_height = 0
	if num > best_height:
		best_height = num
	if PhaseTrack.get_phase() == 2:
		visible = true
	if PhaseTrack.get_phase() == 1 and not onscreen:
		first = best_height*0.66
		second = best_height*0.33
		if num < first and num > second:
			var mat = self.get_surface_override_material(0)
			mat.albedo_color = Color("ffff00")
			self.set_surface_override_material(0, mat)
			#print("yellow")
		if num < second:
			var mat = self.get_surface_override_material(0)
			mat.albedo_color = Color("ff0000")
			self.set_surface_override_material(0, mat)
			#print("red")
		if num > first:
			#print("green %s" % first)
			var mat = self.get_surface_override_material(0)
			mat.albedo_color = Color("00ff00")
			self.set_surface_override_material(0, mat)
	if num < last_height:
		falling = true
		onscreen = false
	if not falling:
		last_height = num
