class_name Player extends CharacterBody2D

@export var speed := 200.0
@export var health := 100.0

@onready var animation_player = $AnimatedSprite2D
@onready var twilight = $Twilight
@onready var attack_area = $AttackRange

var direction: Vector2 = Vector2(1, 0)

func _ready():
	twilight.player = self
	attack_area.monitoring = false

func attacked(damage):
	if health <= 0:
		return
	
	health -= damage
	print(health)
	print(speed)
	if health <= 0:
		queue_free()

func buff(stat):
	speed += stat
	health += stat
