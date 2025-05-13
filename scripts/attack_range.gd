extends Area2D

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    body_entered.connect(_on_body_entered_hit)

func _on_body_entered_hit(body: Node):
    if body.is_in_group('enemy'):
        var enemy_position = body.global_position
        var player_position = player.global_position
        
        var direction_to_enemy = (enemy_position - player_position).normalized()
        
        if direction_to_enemy.dot(player.direction) > 0:
            # Get the state machine from the enemy
            var state_machine = body.get_node("StateMachine")
            if state_machine:
                # Transition the enemy to the hurt state
                state_machine._transition_to_next_state("Hurt")
