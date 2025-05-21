extends StaticBody2D

signal stairs_revealed

@onready var sprite = $Sprite2D
@onready var collision_area = $Area2D
@onready var collision_shape = $Area2D/CollisionShape2D if has_node("Area2D/CollisionShape2D") else null

# Added to keep track of notification
var notification_layer = null

func _ready() -> void:
    visible = false
    set_process(false)
    
    if collision_shape:
        collision_shape.disabled = true
    
    await get_tree().process_frame
    
    check_enemies()
    
    # Connect to the body entered signal to detect when player reaches the stairs
    collision_area.body_entered.connect(_on_player_reached_stairs)

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
    
    # Show notification after the animation completes
    tween.tween_callback(func():
        show_notification()
    ).set_delay(0.5)
    
    set_process(false)

func _on_player_reached_stairs(body) -> void:
    if body.is_in_group("player") and notification_layer:
        # Remove the notification when player reaches the stairs
        notification_layer.queue_free()
        notification_layer = null

func show_notification() -> void:
    # Emit signal for UI systems to handle
    emit_signal("stairs_revealed")
    
    # Create a canvas layer to ensure the notification appears above everything
    var canvas_layer = CanvasLayer.new()
    canvas_layer.layer = 10
    add_child(canvas_layer)
    
    # Store reference to remove later when player reaches stairs
    notification_layer = canvas_layer
    
    # Create a panel as the container with background
    var panel = Panel.new()
    panel.name = "StairNotification"
    panel.size = Vector2(800, 100)  # Increased height for two lines
    panel.position = Vector2((1152 - 800) / 2, 50)  # Center horizontally
    
    # Style the panel with a custom background
    var style_box = StyleBoxFlat.new()
    style_box.bg_color = Color(0.5, 0.1, 0.1, 0.8)  # Dark red semi-transparent
    style_box.border_color = Color(1, 0.9, 0.2)     # Gold/yellow border
    style_box.border_width_bottom = 2
    style_box.border_width_top = 2
    style_box.border_width_left = 2
    style_box.border_width_right = 2
    style_box.corner_radius_top_left = 8
    style_box.corner_radius_top_right = 8
    style_box.corner_radius_bottom_left = 8
    style_box.corner_radius_bottom_right = 8
    
    # Add padding inside the box for text
    style_box.content_margin_left = 16
    style_box.content_margin_right = 16
    style_box.content_margin_top = 8
    style_box.content_margin_bottom = 8
    
    panel.add_theme_stylebox_override("panel", style_box)
    
    # Add the notification text as a label inside the panel
    var notification = Label.new()
    notification.text = "Something just happened!!!\nYou need to find the stair at the top right of the map to next level"
    notification.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    notification.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    notification.size = panel.size
    notification.position = Vector2(0, 0)
    notification.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART  # Enable smart word wrapping
    
    # Style the notification text
    notification.add_theme_font_size_override("font_size", 24)
    notification.add_theme_color_override("font_color", Color(1, 0.9, 0.2))  # Gold/yellow text
    
    # Add panel to canvas layer, then add label to panel
    canvas_layer.add_child(panel)
    panel.add_child(notification)
    
    # Add timer to automatically hide the notification after 5 seconds
    var timer = Timer.new()
    add_child(timer)
    timer.wait_time = 5.0
    timer.one_shot = true
    timer.timeout.connect(func():
        if notification_layer:
            notification_layer.queue_free()
            notification_layer = null
        timer.queue_free()
    )
    timer.start()

func _process(delta: float) -> void:
    pass
