class_name Player extends CharacterBody2D

@export var speed := 200.0
@export var health := 100.0

@onready var twilight = preload("res://scenes/twilight.tscn").instantiate()
@onready var animation_player = $AnimatedSprite2D
@onready var attack_area = $AttackRange
@onready var damage = attack_area.damage_amount

var direction: Vector2 = Vector2(1, 0)

func _ready():
	add_child(twilight)
	twilight.player = self
	attack_area.monitoring = false

func attacked(damage):
	if health <= 0:
		return
	
	health -= damage
	print(health)
	if health <= 0:
		queue_free()

func buff(stat):
	speed += stat
	damage += stat
	print(damage)
	print(speed)
