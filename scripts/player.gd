class_name Player extends CharacterBody2D

@export var speed := 200.0
@export var health := 100.0

@onready var twilight = preload("res://scenes/twilight.tscn").instantiate()
@onready var animation_player = $AnimatedSprite2D
@onready var attack_area = $AttackRange

var direction: Vector2 = Vector2(1, 0)

func _ready():
    add_child(twilight)
    twilight.player = self
    attack_area.monitoring = false

func attacked(damage, is_twilight: bool = false):
    if health <= 0:
        return
    
    health -= damage
    print("Player HP:", health)
    
    var state_machine = get_node("StateMachine")
    if health <= 0:
        state_machine._transition_to_next_state("Death")
    else:
        if !is_twilight:
            state_machine._transition_to_next_state("Hurt")

func buff(stat):
    speed += stat
    health += stat
