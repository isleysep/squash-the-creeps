extends StaticBody3D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var target_rotation = rotation
	
	if PhaseTrack.get_phase() == 1:
		if Input.is_action_pressed("ground_right"):
			target_rotation.z = -PI/12
		if Input.is_action_pressed("ground_left"):
			target_rotation.z = PI/12
		if Input.is_action_pressed("ground_back"):
			target_rotation.x = PI/12
		if Input.is_action_pressed("ground_forward"):
			target_rotation.x = -PI/12
		
		if not (Input.is_action_pressed("ground_forward") or
			Input.is_action_pressed("ground_back")):
			target_rotation.x = 0
		if not (Input.is_action_pressed("ground_left") or
			Input.is_action_pressed("ground_right")):
			target_rotation.z = 0
		rotation = lerp(rotation, target_rotation, 0.2)
	
