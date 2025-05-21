extends PlayerState

var hurt_stream := preload("res://assets/Sound Asset/sfx/hit.mp3")

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity = Vector2.ZERO
	player.animation_player.play("hurt")
	
	var hurt_sfx = AudioStreamPlayer.new()
	hurt_sfx.stream = hurt_stream
	player.add_child(hurt_sfx)
	hurt_sfx.play()
	
	await get_tree().create_timer(2.0).timeout
	hurt_sfx.queue_free()

func physics_update(_delta: float) -> void:
	# Wait for animation to complete before returning to IDLE
	if player.animation_player.is_playing():
		return
		
	# After hurt animation, return to idle
	finished.emit(IDLE)
