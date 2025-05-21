extends Area2D

@export var next_level_path: String = "res://test_scenes/enemy_chase_templar.tscn"

func _ready() -> void:
	monitoring = true
	monitorable = false
	print("Next level stair ready!")
	
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	print("Body entered: ", body.name)
	
	if body.is_in_group("player"):
		print("Player detected!")
		_show_indicator()
		
		await get_tree().create_timer(0.5).timeout
		
		_go_to_next_level()
	else:
		print("Not a player! Groups: ", body.get_groups())

func _show_indicator() -> void:
	pass

func _go_to_next_level() -> void:
	var transition = ColorRect.new()
	transition.color = Color(0, 0, 0, 0)
	transition.size = get_viewport().size
	transition.z_index = 100
	get_tree().root.add_child(transition)
	
	var tween = create_tween()
	tween.tween_property(transition, "color:a", 1.0, 1.0)
	
	await tween.finished
	
	var old_transition = transition
	
	get_tree().call_deferred("change_scene_to_file", next_level_path)
	
	await get_tree().process_frame
	
	if is_instance_valid(old_transition) and old_transition.is_inside_tree():
		old_transition.queue_free()
