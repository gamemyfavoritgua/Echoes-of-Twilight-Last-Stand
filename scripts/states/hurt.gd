extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity = Vector2.ZERO
	player.animation_player.play("hurt")

func physics_update(_delta: float) -> void:
	# Wait for animation to complete before returning to IDLE
	if player.animation_player.is_playing():
		return
		
	# After hurt animation, return to idle
	finished.emit(IDLE)
