extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var collision_area = $Area2D
@onready var collision_shape = $Area2D/CollisionShape2D if has_node("Area2D/CollisionShape2D") else null

func _ready() -> void:
    visible = false
    set_process(false)
    
    if collision_shape:
        collision_shape.disabled = true
    
    await get_tree().process_frame
    
    check_enemies()

func check_enemies() -> void:
    var enemies = get_tree().get_nodes_in_group("enemy")
    
    if enemies.size() == 0:
        reveal_stair()
    else:
        for enemy in enemies:
            if not enemy.is_connected("tree_exiting", Callable(self, "_on_enemy_tree_exiting")):
                enemy.tree_exiting.connect(_on_enemy_tree_exiting)

func _on_enemy_tree_exiting() -> void:
    var timer = Timer.new()
    add_child(timer)
    timer.one_shot = true
    timer.wait_time = 0.1
    timer.timeout.connect(func(): 
        check_enemies()
        timer.queue_free()
    )
    timer.start()

func reveal_stair() -> void:
    visible = true
    
    if collision_shape:
        collision_shape.disabled = false
    
    collision_area.monitoring = true
    collision_area.monitorable = false  # Tetap false karena kita hanya ingin mendeteksi player, bukan sebaliknya
    
    sprite.scale = Vector2(0.1, 0.1)
    sprite.modulate.a = 0.0
    
    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(sprite, "scale", Vector2(1, 1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
    tween.tween_property(sprite, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_OUT)
    
    set_process(false)

func _process(delta: float) -> void:
    pass
