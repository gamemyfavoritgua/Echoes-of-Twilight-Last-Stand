class_name Player extends CharacterBody2D

@export var speed := 200.0
@export var max_health := 100
@export var health := 50
@export var stamina := 50
@export var is_alive := true

@onready var animation_player = $AnimatedSprite2D

func _ready():
	add_to_group("player")

func _process(delta: float) -> void:
	print("nyawa", health)

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()
		
func heal(amount: int):
	health = min(health + amount, max_health)
	
func die():
	is_alive = false
	animation_player.play("death")
	set_physics_process(false)
