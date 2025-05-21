extends Area2D

@export var next_level_path: String = "res://scenes/Level2.tscn"
var transition_scene = preload("res://scenes/transition.tscn")

func _ready() -> void:
    monitoring = true
    monitorable = false
    print("Next level stair ready!")
    
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    print("Body entered: ", body.name)
    
    if body.is_in_group("Player"):
        print("Player detected!")
        _show_indicator()
        
        await get_tree().create_timer(0.5).timeout
        
        _go_to_next_level()
    else:
        print("Not a player! Groups: ", body.get_groups())

func _show_indicator() -> void:
    pass

func _go_to_next_level() -> void:
    # Instantiate transition
    var transition = transition_scene.instantiate()
    get_tree().root.add_child(transition)
    
    # Change scene using transition
    transition.change_scene(next_level_path)
