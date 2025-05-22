extends LinkButton

var transition_scene = preload("res://scenes/transition.tscn")

func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

func _on_pressed() -> void:
    # Use the same transition method as the player code
    var transition = transition_scene.instantiate()
    get_tree().root.add_child(transition)
    transition.change_scene("res://scenes/main_menu.tscn")
