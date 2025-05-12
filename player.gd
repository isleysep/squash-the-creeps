extends CharacterBody3D

signal hit
signal combo(num)
signal twirl(yes)
signal stunt
signal height(num)
signal horizont(num)

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
# Vertical impulse applied to the character upon jumping in meters per second.
@export var jump_impulse = 20
# Vertical impulse applied to the character upon bouncing over a mob in
# meters per second.
@export var bounce_impulse = 20
@export var twirl_impulse = 10

var combo_count = 0
var airborne = false
var target_velocity = Vector3.ZERO
var twirl_available = false
var twirl_counter = 0
var phase_two = false
var dead = false

func _physics_process(delta):
	if dead:
		return
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	
	pick_color()

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x += Input.get_action_strength("move_right")
	if Input.is_action_pressed("move_left"):
		direction.x -= Input.get_action_strength("move_left")
	# Notice how we are working with the vector's x and z axes.
	# In 3D, the XZ plane is the ground plane.
	if Input.is_action_pressed("move_back"):
		direction.z += Input.get_action_strength("move_back")
	if Input.is_action_pressed("move_forward"):
		direction.z -= Input.get_action_strength("move_forward")
	if direction != Vector3.ZERO:
		if direction.length() > 1:
			direction = direction.normalized()

		# Get current rotation as a quaternion
		var current_rotation = $Pivot.basis.get_euler().y  # Get Y-axis rotation

		# Compute target rotation angle
		var target_rotation = atan2(direction.x, direction.z) + PI # Get Y rotation angle toward direction

		# Smoothly interpolate using lerp_angle
		var new_rotation = lerp_angle(current_rotation, target_rotation, 12.0 * delta)  # Adjust speed if needed

		# Apply the new interpolated rotation
		$Pivot.basis = Basis(Vector3.UP, new_rotation)

		if not airborne:
			$AnimationPlayer.speed_scale = 3
		else:
			$AnimationPlayer.speed_scale = 2
	else:
		$AnimationPlayer.speed_scale = 1
	#var input_vector = Vector2(
		#max(abs(Input.get_action_strength("move_right")), abs(Input.get_action_strength("move_left"))),
		#max(abs(Input.get_action_strength("move_back")), abs(Input.get_action_strength("move_forward")))
	#)
	# Ground Velocity
	#if input_vector.length() > 1:
		#input_vector = input_vector.normalized()
	target_velocity.x = direction.x * speed# * input_vector.x
	target_velocity.z = direction.z * speed# * input_vector.y
	#print(target_velocity.length())
	
	if PhaseTrack.get_phase() == 2:
		phase_two = true
		var rotation_amount = 10 * delta
		if Input.is_action_pressed("ground_right"):
			$Pivot/Character.rotate_object_local(Vector3(0, 0, -1), rotation_amount)
		if Input.is_action_pressed("ground_left"):
			$Pivot/Character.rotate_object_local(Vector3(0, 0, 1), rotation_amount)
		if Input.is_action_pressed("ground_back"):
			$Pivot/Character.rotate_object_local(Vector3(1, 0, 0), rotation_amount)
		if Input.is_action_pressed("ground_forward"):
			$Pivot/Character.rotate_object_local(Vector3(-1, 0, 0), rotation_amount)
	if phase_two and PhaseTrack.get_phase() == 1:
		phase_two = false
		$Pivot/Character.rotation.z = 0
		$Pivot/Character.rotation.x = 0

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		#if target_velocity.y < 0.0:
			#$Pivot/Character/FastTrailParticles.emitting = false
		if Input.is_action_just_pressed("jump") and twirl_available and not phase_two:
			target_velocity.y = bounce_impulse
			$AnimationPlayer.play("twirl")
			twirl_available = false
			twirl.emit(false)
			twirl_counter = 0
			var mat = $Pivot/Character/Sphere_001.get_surface_override_material(1)
			mat.albedo_color = Color("ff6430")
			$Pivot/Character/Sphere_001.set_surface_override_material(1, mat)
	
	# Jumping.
	if is_on_floor():
		if not airborne:
			if combo_count > 0:
				die()
			combo_count = 0
			ComboCount.reset_combo()
			twirl_available = false
			twirl.emit(true)
			twirl_counter = 0
			#$Pivot/Character/FastTrailParticles.emitting = false
			var mat = $Pivot/Character/Sphere_001.get_surface_override_material(1)
			mat.albedo_color = Color("ff6430")
			$Pivot/Character/Sphere_001.set_surface_override_material(1, mat)
		airborne = false
		#combo_count = 0
		combo.emit(0)
		$MobDetector/CollisionShape3D.disabled = false
		$AnimationPlayer.play("float")
		if Input.is_action_just_pressed("jump"):
			target_velocity.y = jump_impulse
	
		
	# Iterate through all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)

		# If the collision is with ground
		if collision.get_collider() == null:
			continue

		# If the collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# we check that we are hitting it from above.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, we squash it and bounce.
				combo_count += 1
				ComboCount.increase_combo()
				if !twirl_available:
					twirl_counter += 1
				if twirl_counter > 2:
					var mat = $Pivot/Character/Sphere_001.get_surface_override_material(1)
					mat.albedo_color = Color("fb67a2")
					$Pivot/Character/Sphere_001.set_surface_override_material(1, mat)
					twirl_available = true
					twirl.emit(true)
				mob.squash()
				target_velocity.y = min(bounce_impulse + (10*(combo_count)), 40)
				# if stunt
				if mob.get_real_velocity().y > 10:
					target_velocity.y += mob.get_real_velocity().y*5
					stunt.emit()
					#var mat = $Pivot/Character/Sphere_001.get_surface_override_material(1)
					#mat.albedo_color = Color("fb67a2")
					#$Pivot/Character/Sphere_001.set_surface_override_material(1, mat)
					#twirl_available = true
					#twirl.emit(true)
				combo.emit(combo_count)
				airborne = true
				# $PinkParticles.emitting = true
				$AnimationPlayer.pause()
				if combo_count > 2:
					$AnimationPlayer.play("flip")
					$AnimationPlayer.queue("float")
					#$Pivot/Character/FastTrailParticles.emitting = true
				# Prevent further duplicate calls.
				break
	
	if not is_on_floor():
		if $AnimationPlayer.current_animation == "float":
			$AnimationPlayer.pause()
		airborne = true
		$MobDetector/CollisionShape3D.disabled = true

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	if PhaseTrack.get_phase() == 2 and velocity.length() > 30:
		$Pivot/Character/FastTrailParticles.emitting = true
	else:
		$Pivot/Character/FastTrailParticles.emitting = false
	if $AnimationPlayer.current_animation == "twirl":
		$Pivot/Character/FastTrailParticles.emitting = true
	$Pivot.rotation.x = PI / 6 * clamp(velocity.y, -50, 50) / jump_impulse
	height.emit(position.y)
	if position.x < -10 or position.x > 10:
		horizont.emit(position.x)

func pick_color():
	#if combo_count > 1:
		#var chosen_color = Color(0.9017, 0.3173, 0.2187, 0.851)
		#var combo_temp = combo_count
		#while combo_temp > 20:
			#combo_temp -= 20
		#chosen_color.h = combo_temp * 0.05
		#$Pivot/Character/FastTrailParticles.process_material.set("color", chosen_color)
		#return
	var material = $Pivot/Character/FastTrailParticles.process_material
	var amount = $Pivot/Character/FastTrailParticles.amount
	var red = Color(0.9017, 0.3173, 0.2187, 0.851)
	var red_amt = 20
	var orange = Color(0.8117, 0.4153, 0.2306, 0.851)
	var orange_amt = 40
	var yellow = Color(0.7559, 0.4633, 0.1603, 0.851)
	var yellow_amt = 60
	var blue = Color(0.4164, 0.5444, 0.76, 0.851)
	var blue_amt = 80
	var purp = Color("fb67a2")
	if $AnimationPlayer.current_animation == "twirl":
		material.set("color", purp)
		return

	# Define speed thresholds (adjust as needed)
	var speed_min = 0.0
	var speed_max = 50.0  # Adjust based on your game

	# Normalize speed to a 0-1 range
	var t = clamp((velocity.length() - speed_min) / (speed_max - speed_min), 0.0, 1.0)

	# Interpolate between colors based on speed
	var chosen_color = blue
	var chosen_amt = 40
	if t < .33:
		chosen_color = red.lerp(orange, t/.33)
		chosen_amt = lerp(red_amt, orange_amt, t/.33)
	if t >= .33 and t < .66:
		chosen_color = orange.lerp(yellow, (t-.33)/.33)
		chosen_amt = lerp(orange_amt, yellow_amt, (t-.33)/.33)
	if t >= .66 and t < 1:
		chosen_color = yellow.lerp(blue, (t-.66)/.33)
		chosen_amt = lerp(yellow_amt, blue_amt, (t-.66)/.33)
	
	
	#chosen_color = chosen_color.lerp(orange, t * 0.8)
	#chosen_color = chosen_color.lerp(yellow, t * 0.9)

	# Apply color to particle material
	material.set("color", chosen_color)
	amount = chosen_amt
	#material.set("amount", chosen_amt)

func die():
	dead = true
	if ComboCount.get_combo() > 0:
		$DeathParticles.amount = 30 * ComboCount.get_combo()
	$DeathParticles.emitting = true
	#call_deferred($MobDetector/CollisionShape3D.disable)
	#$CollisionShape3D.disabled = true
	hit.emit()
	combo.emit(0)
	$Pivot/Character.visible = false
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _on_mob_detector_body_entered(_body: Node3D) -> void:
	die()

#func _on_phase():
	#rotation
	##look at phase_track


func _on_area_3d_area_entered(_area: Area3D) -> void:
	die()
