extends PlayerState

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
    player.animation_player.play("walk")
    
## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
    var input_direction_x := Input.get_axis("move_left", "move_right")
    player.velocity.x = player.speed * input_direction_x
    player.move_and_slide()
    
    if is_equal_approx(input_direction_x, 0.0):
        finished.emit(IDLE)
