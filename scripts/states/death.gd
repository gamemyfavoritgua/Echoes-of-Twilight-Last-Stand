extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity = Vector2.ZERO
	player.animation_player.play("death")
	
	# Disable collision so enemies don't continue targeting
	player.collision_layer = 0
	player.collision_mask = 0
	
	# Detach camera before player is removed
	if player.has_node("Camera2D"):
		var camera = player.get_node("Camera2D")
		var camera_pos = camera.global_position
		player.remove_child(camera)
		# Add camera to the scene tree so it persists
		get_tree().current_scene.add_child(camera)
		camera.global_position = camera_pos

func physics_update(_delta: float) -> void:
	# Wait for animation to complete before removing the player
	if not player.animation_player.is_playing():
		# You could add game over logic here
		
		# Optional: Show game over screen or UI
		# get_tree().call_group("UI", "show_game_over")
		
		# Remove player but keep camera in scene
		player.queue_free()
