extends PlayerState

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
    player.animation_player.play("walk")
    
## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
    var input_vector := Vector2(
        Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
        Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
    )

    if input_vector.length() > 0:
        input_vector = input_vector.normalized()
        player.direction = input_vector
    
    player.velocity = input_vector * player.speed
    player.move_and_slide()
    
    # Flip sprite if moving horizontally (optional, only if side view is relevant)
    if input_vector.x != 0:
        player.animation_player.flip_h = input_vector.x < 0

    # State transitions
    if input_vector == Vector2.ZERO:
        finished.emit(IDLE)

    if Input.is_action_just_pressed("attack"):
        finished.emit(ATTACK1)
