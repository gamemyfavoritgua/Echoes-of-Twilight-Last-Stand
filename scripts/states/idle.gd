extends PlayerState

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
    player.velocity.x = 0.0
    player.animation_player.play("idle")
    
## Called by the state machine on the engine's main loop tick.
func physics_update(_delta: float) -> void:
    var input_vector := Vector2(
        Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
        Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
    )
    
    if input_vector != Vector2.ZERO:
        finished.emit(WALK)
    
    if Input.is_action_just_pressed("attack"):
        finished.emit(ATTACK1)
