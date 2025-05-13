extends GoblinState

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
    player.animation_player.play("hurt")
    
## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
    if player.animation_player.is_playing():
        return
        
    finished.emit(WALK)
