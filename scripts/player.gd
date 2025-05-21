class_name Player extends CharacterBody2D

signal health_change

@export var speed := 200.0
@export var health := 100.0
@export var max_health := 100.0

@onready var twilight = preload("res://scenes/twilight.tscn").instantiate()
@onready var animation_player = $AnimatedSprite2D
@onready var attack_area = $AttackRange
@onready var damage_amount = attack_area.damage_amount

var direction: Vector2 = Vector2(1, 0)

func _ready():
	add_to_group("Player")
	add_child(twilight)
	twilight.player = self
	attack_area.monitoring = false

func attacked(damage, is_twilight: bool = false):
	if health <= 0:
		return
	
	health -= damage
	print("Player HP:", health)
	health_change.emit()
	
	var state_machine = get_node("StateMachine")
	if health <= 0:
		state_machine._transition_to_next_state("Death")
	else:
		if !is_twilight:
			state_machine._transition_to_next_state("Hurt")

func buff(stat):
	speed += stat
	damage_amount += stat

func heal(amount: int):
	health = min(health + amount, max_health)
	health_change.emit()
