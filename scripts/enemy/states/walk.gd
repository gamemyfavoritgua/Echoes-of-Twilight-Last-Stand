extends GoblinState

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
    player.animation_player.play("walk")
    
## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
    
    var direction = (target.position - player.position).normalized()
    
    player.velocity = direction * player.speed
    player.move_and_slide()
    
    # Flip sprite if moving horizontally (optional, only if side view is relevant)
    if direction.x != 0:
        player.animation_player.flip_h = direction.x < 0
