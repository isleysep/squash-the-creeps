extends GPUParticles3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var material = process_material
	var red = Color(0.9017, 0.3173, 0.2187, 0.851)
	var orange = Color(0.8117, 0.4153, 0.2306, 0.851)
	var yellow = Color(0.7559, 0.4633, 0.1603, 0.851)
	var blue = Color(0.4164, 0.5444, 0.76, 0.851)
