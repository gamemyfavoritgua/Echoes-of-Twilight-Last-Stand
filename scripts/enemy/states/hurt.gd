extends GoblinState

var hurt_stream := preload("res://assets/Sound Asset/sfx/hit.mp3")

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
    player.animation_player.play("hurt")
    
    var hurt_sfx = AudioStreamPlayer.new()
    hurt_sfx.stream = hurt_stream
    player.add_child(hurt_sfx)
    hurt_sfx.play()
    
    await get_tree().create_timer(2.0).timeout
    hurt_sfx.queue_free()
    
## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
    if player.animation_player.is_playing():
        return
        
    finished.emit(WALK)
