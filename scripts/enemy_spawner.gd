extends Node2D

# Remove the incorrect reference
# @onready var main = get_node("root/Level1/EnemySpawner")

var enemy_scene := preload("res://scenes/enemy.tscn")
var spawn_points := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    for i in get_children():
        if i is Marker2D:
            spawn_points.append(i)
    
    # Start the timer if it exists as a child
    var timer = get_node_or_null("Timer")
    if not timer:
        print("Warning: No Timer node found as child of EnemySpawner")

func _on_timer_timeout() -> void:
    if spawn_points.size() == 0:
        print("No spawn points available!")
        return
        
    var spawn = spawn_points[randi() % spawn_points.size()]
    var enemy = enemy_scene.instantiate()
    enemy.position = spawn.position
    
    # Add the enemy to the parent (Level1) instead
    get_parent().add_child(enemy)
    print("Enemy spawned at position: ", spawn.position)
