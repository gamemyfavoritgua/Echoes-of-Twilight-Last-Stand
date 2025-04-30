extends PlayerState

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
    player.animation_player.play('attack_1')

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:\
    if !player.animation_player.is_playing():
        var input_direction_x := Input.get_axis("move_left", "move_right")
        
        if is_equal_approx(input_direction_x, 0.0):
            finished.emit(IDLE)
        else:
            finished.emit(WALK)
