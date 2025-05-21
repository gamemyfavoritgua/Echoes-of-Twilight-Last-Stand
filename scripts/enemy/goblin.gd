class_name Goblin extends CharacterBody2D

@export var speed := 50.0
@export var max_health := 100.0
var health: float

@onready var animation_player = $AnimatedSprite2D

func _ready() -> void:
	health = max_health

func take_damage(damage_amount: float) -> void:
	health -= damage_amount
	print("Enemy health: ", health)
	
	if health <= 0:
		var state_machine = get_node("StateMachine")
		if state_machine:
			state_machine._transition_to_next_state("Death")
	else:
		var state_machine = get_node("StateMachine")
		if state_machine:
			state_machine._transition_to_next_state("Hurt")
