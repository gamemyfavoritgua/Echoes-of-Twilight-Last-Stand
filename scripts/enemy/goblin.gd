class_name Goblin extends CharacterBody2D

@export var speed := 50.0
@export var max_health := 100.0
var health := max_health
@export_file("*.tscn") var item_scene_path := ""
@export var drop_chance := 0.5

@onready var animation_player = $AnimatedSprite2D

func _ready() -> void:
    health = max_health

func take_damage(damage_amount: float) -> void:
    health -= damage_amount
    var drop_position = global_position
    
    if health <= 0:
        print("Enemy health: ", health)
        var state_machine = get_node("StateMachine")
        if state_machine:
            state_machine._transition_to_next_state("Death")
        _try_drop_item(drop_position)
    else:
        var state_machine = get_node("StateMachine")
        if state_machine:
            state_machine._transition_to_next_state("Hurt")
            

func _try_drop_item(pos: Vector2) -> void:
    if randf() <= drop_chance:
        _spawn_item(pos)
        
func _spawn_item(pos: Vector2) -> void:
    if item_scene_path.is_empty():
        return
    
    var item_scene = load(item_scene_path)
    if item_scene:
        var item_instance = item_scene.instantiate()
        
        get_parent().call_deferred("add_child", item_instance)
        item_instance.global_position = pos
