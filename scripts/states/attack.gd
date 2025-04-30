extends PlayerState

@export var anim: String
@export var next_state: String

var attack_buffered := false

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
     if _event.is_action_pressed("attack"):
        attack_buffered = true

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
    player.animation_player.play(anim)

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
    if player.animation_player.is_playing():
        return
        
    var input_direction_x := Input.get_axis("move_left", "move_right")
    
    if attack_buffered and next_state:
        attack_buffered = false
        finished.emit(next_state)
        return
    
    if is_equal_approx(input_direction_x, 0.0):
        finished.emit(IDLE)
    else:
        finished.emit(WALK)
