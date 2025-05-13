extends GoblinState

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
    player.velocity.x = 0.0
    player.animation_player.play("idle")
    
func _on_player_entered(player_body):
    finished.emit(WALK)
