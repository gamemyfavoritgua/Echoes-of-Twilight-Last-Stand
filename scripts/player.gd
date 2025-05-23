class_name Player extends CharacterBody2D

signal health_change

@export var speed := 200.0
@export var health := 100.0
@export var max_health := 100.0

@onready var twilight = preload("res://scenes/twilight.tscn").instantiate()
@onready var animation_player = $AnimatedSprite2D
@onready var attack_area = $AttackRange
@onready var damage_amount = attack_area.damage_amount
@onready var heal_sfx_stream = preload("res://assets/Sound Asset/sfx/rune-pickup.mp3")

var direction: Vector2 = Vector2(1, 0)
var heal_sfx = AudioStreamPlayer
var transition_scene = preload("res://scenes/transition.tscn")

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
		attack_area.monitoring = false
		if !is_twilight:
			state_machine._transition_to_next_state("Hurt")

func go_to_lose_screen():
	# Instantiate transition
	var transition = transition_scene.instantiate()
	get_tree().root.add_child(transition)
	
	# Change scene to lose screen
	transition.change_scene("res://scenes/lose_screen.tscn")

func buff(stat):
	speed += stat
	damage_amount += stat

func heal(amount: int):
	health = min(health + amount, max_health)
	health_change.emit()
	heal_sfx = AudioStreamPlayer.new()
	heal_sfx.stream = heal_sfx_stream
	add_child(heal_sfx)
	heal_sfx.play()
	await get_tree().create_timer(1.5).timeout
	if is_instance_valid(heal_sfx):
		heal_sfx.queue_free()
