extends PlayerState

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
    player.velocity.x = 0.0
    player.animation_player.play("idle")
    
## Called by the state machine on the engine's main loop tick.
func physics_update(_delta: float) -> void:
    var move_left = Input.is_action_just_pressed("move_left")
    var move_right = Input.is_action_just_pressed("move_right")
    
    if move_left or move_right:
        finished.emit(WALK)
