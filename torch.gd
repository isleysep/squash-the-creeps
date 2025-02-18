extends CharacterBody3D

var red = Color(0.9017, 0.3173, 0.2187, 0.851)
var orange = Color(0.8117, 0.4153, 0.2306, 0.851)
var yellow = Color(0.7559, 0.4633, 0.1603, 0.851)
var blue = Color(0.4164, 0.5444, 0.76, 0.851)

# Define speed thresholds (adjust as needed)
var speed_min = 10.0
var speed_max = 30.0  # Adjust based on your game

@export var speed := 30.0  # Speed of movement
var dragging := false
var target_position: Vector3
var target_velocity = Vector3.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var material = $TorchParticles.process_material
	var direction = Vector3.ZERO
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("torch_right"):
		direction.x += Input.get_action_strength("torch_right")
	if Input.is_action_pressed("torch_left"):
		direction.x -= Input.get_action_strength("torch_left")
	# Notice how we are working with the vector's x and z axes.
	# In 3D, the XZ plane is the ground plane.
	if Input.is_action_pressed("torch_back"):
		direction.z += Input.get_action_strength("torch_back")
	if Input.is_action_pressed("torch_forward"):
		direction.z -= Input.get_action_strength("torch_forward")
	if direction != Vector3.ZERO and direction.length() > 1:
			direction = direction.normalized()
	var input_vector = Vector2(
		max(abs(Input.get_action_strength("torch_right")), abs(Input.get_action_strength("torch_left"))),
		max(abs(Input.get_action_strength("torch_back")), abs(Input.get_action_strength("torch_forward")))
	)
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	velocity = target_velocity
	move_and_slide()

	# Normalize speed to a 0-1 range
	#print(velocity)
	var t = clamp((velocity.length() - speed_min) / (speed_max - speed_min), 0.0, 1.0)

	# Interpolate between colors based on speed
	var chosen_color = blue
	if t < .33:
		chosen_color = red.lerp(orange, t/.33)
	if t >= .33 and t < .66:
		chosen_color = orange.lerp(yellow, (t-.33)/.33)
	if t >= .66 and t < 1:
		chosen_color = yellow.lerp(blue, (t-.66)/.33)
	# Apply color to particle material
	material.set("color", chosen_color)
	

func _input(event):
	var camera = get_viewport().get_camera_3d()

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var from = camera.project_ray_origin(event.position)
				var to = from + camera.project_ray_normal(event.position) * 1000
				var space_state = get_world_3d().direct_space_state
				var query = PhysicsRayQueryParameters3D.create(from, to)
				query.collide_with_areas = true
				var result = space_state.intersect_ray(query)

				if result and result.collider == self:
					dragging = true
			else:
				dragging = false  # Stop dragging when mouse button is released

	if event is InputEventMouseMotion and dragging:
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = false
		var result = space_state.intersect_ray(query)

		if result:
			target_position = result.position
