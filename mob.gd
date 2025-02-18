extends CharacterBody3D

signal squashed

# Minimum speed of the mob in meters per second.
@export var min_speed = 10
# Maximum speed of the mob in meters per second.
@export var max_speed = 15
@export var fall_acceleration = 150
var paused = true

#var combo = 0


func _physics_process(delta):
	if not paused:
		if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
			velocity.y -= (fall_acceleration * delta)
		move_and_slide()
	
func _ready():
	await flicker(10)
	paused = false
	$CollisionShape3D.disabled = false
	# We calculate a random speed (integer)
	var random_speed = randi_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	$AnimationPlayer.speed_scale = random_speed / min_speed
	#$VideoPlayer/MeshInstance3D.transparency(1)
	
# This function will be called from the Main scene.
func initialize(start_position, player_position):
	#var crt_shader = preload("res://glitch.gdshader")
	#$Pivot/mob.material = ShaderMaterial.new()
	#$Pivot/mob.material.shader = crt_shader
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	position.y += 8
	# Rotate this mob randomly within range of -45 and +45 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4))

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()

func flicker(num):
	for i in range(num):
		$Pivot/mob.visible = true
		$Pivot/Character.visible = false
		await get_tree().create_timer(0.05).timeout
		$Pivot/mob.visible = false
		$Pivot/Character.visible = true
		await get_tree().create_timer(0.05).timeout
		
	
#

func squash():
	squashed.emit()
	flicker(20)
	#$VideoPlayer/MeshInstance3D.transparency(0)
	#$VideoPlayer/VideoStreamPlayer.play()
	$AnimationPlayer.speed_scale = 0
	$BlueParticles.amount = min(10*ComboCount.get_combo(), 50)
	$RedParticles.amount = min(5*ComboCount.get_combo(), 25)
	$BlackParticles.amount = min(2*ComboCount.get_combo(), 10)
	$BlueParticles.emitting = true
	$RedParticles.emitting = true
	$BlackParticles.emitting = true
	$Pivot/Character.visible = false
	velocity = Vector3.ZERO
	$CollisionShape3D.disabled = true
	await get_tree().create_timer(1.0).timeout
	queue_free()
