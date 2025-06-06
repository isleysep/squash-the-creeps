extends Node

@export var mob_scene: PackedScene
@export var combo: int
@onready var hc = $Player/HeightCount
var score = 0
var best_combo = 0
var last_height = 0.0



func _ready():
	$UserInterface/Retry.hide()
	$UserInterface/Retry.color = Color(0.0, 0.0, 0.0, 0)

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("Ground/SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	player_position.y = 0
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	# We connect the mob to the score label to update the score upon squashing one.
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	#mob.squashed.connect($UserInterface/ComboLabel._on_mob_squashed.bind())


func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()
	var tween = create_tween()
	tween.tween_property($UserInterface/Retry, "color", Color(0.0, 0.0, 0.0, 0.588), 0.5)
	await Leaderboards.post_guest_score("squashcreep-high-score-czUM", best_combo, "test")

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()


func _on_player_combo(num: Variant) -> void:
	combo = num
	best_combo = max(best_combo, combo)


func _on_score_label_score_count(num: Variant) -> void:
	score = num


func _on_player_height(num: Variant) -> void:
	if hc:
		hc.on_score(int(num))
	#$Silhouette/Pivot/Character.position.y = num
	#if last_height - num < 0.1 and PhaseTrack.get_phase() == 2:
		#if $Player/Pivot/Character.rotation.z - $Silhouette/Pivot/Character.rotation.z < 0.1:
			#$AudioStreamPlayer3D.play()
	#if last_height - num < 5 and PhaseTrack.get_phase() == 2 and not slowed:
		#slowed = true
		#Engine.set_time_scale(0.5)
		#print("slowed")
		#await get_tree().create_timer(0.25).timeout
		#print("unslowed")
		#Engine.set_time_scale(1)
	if 30.0 > num and PhaseTrack.get_phase() == 1:
		DopamineTickerSound.reset_pitch()
	if 30.0 > num or last_height > num + 0.5 or $Player/AnimationPlayer.current_animation == "twirl":
		if PhaseTrack.get_phase() == 2:
			# letterbox out
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_QUART)
			tween.tween_method(camera_fade, $SubViewportContainer.material.get_shader_parameter("squishedness"), 0, 0.25)
			#score_pos.emit($CameraPivot/Camera3D.unproject_position($Player/Pivot/Character/HeightLabel.position))
			$UserInterface/ScoreLabel.visible = true
			$UserInterface/ComboLabel.visible = true
			$CameraPivot/Camera3D.current = true
			#$Silhouette.visible = false
			
			#$Player/Pivot/HeightLabel.visible = false
			#$UserInterface/HeightLabelTemp.visible = true
			PhaseTrack.set_phase(1)
			hc.visible = false
			hc.reset()
	else:
		if PhaseTrack.get_phase() == 1:
			# letterbox in
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_QUART)
			tween.tween_method(camera_fade, $SubViewportContainer.material.get_shader_parameter("squishedness"), 0.25, 0.25)
			#$Silhouette.visible = true
			$JumpCamera.current = true
			# if entering phase 2, set random rotation for silhouette
			if PhaseTrack.get_phase() == 1:
				#$Player/Pivot/HeightLabel.visible = true
				$UserInterface/ScoreLabel.visible = false
				$UserInterface/ComboLabel.visible = false
			PhaseTrack.set_phase(2)
			hc.visible = true
			hc.wake()
	last_height = num

func camera_fade(num: float):
	$SubViewportContainer.material.set_shader_parameter("squishedness", num)
	#var cur = $SubViewportContainer.material.get_shader_parameter("squishedness")
	#var tween = create_tween()
	#tween.tween_method($SubViewportContainer.material.set_shader_parameter, ("squishedness", cur), ("squishedness", num), 1)
