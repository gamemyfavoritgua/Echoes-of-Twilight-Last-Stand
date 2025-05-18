extends GoblinState

func enter(previous_state_path: String, data := {}) -> void:
    player.animation_player.play("death")
    # Disable collision
    player.collision_layer = 0
    player.collision_mask = 0

func physics_update(_delta: float) -> void:
    # Wait for animation to complete before removing the enemy
    if not player.animation_player.is_playing():
        player.queue_free()