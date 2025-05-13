class_name Player extends CharacterBody2D

@export var speed := 200.0
@onready var animation_player = $AnimatedSprite2D
@onready var attack_area = $AttackRange

func _ready() -> void:
    attack_area.monitoring = false
