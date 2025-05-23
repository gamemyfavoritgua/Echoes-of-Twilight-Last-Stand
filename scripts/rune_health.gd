extends Node2D
@export var type := "health"
@export var amount := 25
@export var float_height := 5.0
@export var float_speed := 2.0

var initial_position: Vector2
var tween: Tween

func _ready():
	initial_position = position
	create_floating_effect()

func create_floating_effect():
	tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "position",initial_position + Vector2(0, -float_height),float_speed / 2.0)
	tween.tween_property(self, "position",initial_position + Vector2(0, float_height),float_speed / 2.0)

func _on_body_entered(body: Node2D) -> void:
	print("Body entered: ", body.name)
	
	if body.is_in_group("Player"):
		print("Player detected!")
		apply_effect(body)
		if tween:
			tween.kill()
		queue_free()

func apply_effect(player):
	match type:
		"health":
			if player.has_method("heal"):
				player.heal(amount)
				print("Healing player for ", amount, " health")
