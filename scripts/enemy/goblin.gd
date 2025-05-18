class_name Goblin extends CharacterBody2D

@export var speed := 50.0
@export var max_health := 100.0
var health := max_health

@onready var animation_player = $AnimatedSprite2D

func take_damage(damage_amount: float) -> void:
    health -= damage_amount
    
    if health <= 0:
        # If health depleted, go to death state
        var state_machine = get_node("StateMachine")
        if state_machine:
            state_machine._transition_to_next_state("Death")
    else:
        # Otherwise go to hurt state
        var state_machine = get_node("StateMachine")
        if state_machine:
            state_machine._transition_to_next_state("Hurt")