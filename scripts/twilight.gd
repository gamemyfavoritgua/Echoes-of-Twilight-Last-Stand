extends Node

@export var fill_duration_sec: float = 17.0  # total detik sampai penuh
@export var buff_amount: int = 20
@export var health_drain: int = 3

@onready var twilight_progress = $CanvasLayer/TwilightProgress
@onready var fill_timer = $FillTimer
@onready var drain_timer = $DrainTimer

var buff_applied: bool = false
var player: CharacterBody2D = null
var health_frame: TextureProgressBar = null
var notification_layer = null

func _ready():
    fill_timer.start()
    drain_timer.stop()
    twilight_progress.max_value = fill_duration_sec
    
    # Get reference to the health frame when ready
    call_deferred("_setup_health_frame")

func _setup_health_frame():
    if player != null:
        health_frame = player.get_node_or_null("CanvasLayer/HealthFrame")

func _on_fill_timer_timeout():
    if buff_applied:
        return

    twilight_progress.value += 1  # naik 1 per detik
    if twilight_progress.value >= twilight_progress.max_value:
        # bar sudah penuh → apply buff & mulai drain
        apply_buff()
        drain_timer.start()
        fill_timer.stop()

func _on_drain_timer_timeout():
    if player != null:
        player.attacked(health_drain, true)
        
func apply_buff():
    buff_applied = true
    if player != null:
        player.buff(buff_amount)
    _apply_twilight_visual_effect()
    _show_twilight_notification()

func _apply_twilight_visual_effect():
    # Apply purple tint to health frame when twilight mode is active
    if health_frame != null:
        # Create a purple tint (adjust these values for the desired purple shade)
        var purple_tint = Color(0.8, 0.4, 1.0, 1.0)  # Light purple tint
        health_frame.modulate = purple_tint
        
        # Add a subtle pulsing effect
        var tween = create_tween()
        tween.set_loops()
        tween.tween_property(health_frame, "modulate:a", 0.7, 0.5)
        tween.tween_property(health_frame, "modulate:a", 1.0, 0.5)

func _show_twilight_notification():
    # Create a canvas layer to ensure the notification appears above everything
    var canvas_layer = CanvasLayer.new()
    canvas_layer.layer = 15  # Higher than pause menu (10)
    add_child(canvas_layer)
    
    # Store reference to remove later
    notification_layer = canvas_layer
    
    # Create compact notification panel
    var panel = Panel.new()
    panel.name = "TwilightNotification"
    panel.size = Vector2(400, 110)
    panel.position = Vector2((1152 - 400) / 2, 30)  # High position
    
    # Style the main panel with a twilight theme
    var style_box = StyleBoxFlat.new()
    style_box.bg_color = Color(0.2, 0.1, 0.4, 0.9)
    style_box.border_color = Color(0.8, 0.4, 1.0)     # Light purple border
    style_box.border_width_bottom = 2
    style_box.border_width_top = 2
    style_box.border_width_left = 2
    style_box.border_width_right = 2
    style_box.corner_radius_top_left = 10
    style_box.corner_radius_top_right = 10
    style_box.corner_radius_bottom_left = 10
    style_box.corner_radius_bottom_right = 10
    
    # Smaller shadow
    style_box.shadow_color = Color(0.8, 0.4, 1.0, 0.4)
    style_box.shadow_size = 5
    style_box.shadow_offset = Vector2(0, 0)
    
    panel.add_theme_stylebox_override("panel", style_box)
    
    # Create title label
    var title_label = Label.new()
    title_label.text = "⚡ TWILIGHT MODE ACTIVATED ⚡"
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title_label.position = Vector2(0, 5)
    title_label.size = Vector2(400, 25)
    title_label.add_theme_font_size_override("font_size", 18)
    title_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))  # Golden text
    title_label.add_theme_color_override("font_shadow_color", Color(0.5, 0.0, 0.8))
    title_label.add_theme_constant_override("shadow_offset_x", 1)
    title_label.add_theme_constant_override("shadow_offset_y", 1)
    
    # Create narrative description
    var effects_label = Label.new()
    effects_label.text = "You got stronger but you lose HP every second.\nManage your time wisely!"
    effects_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    effects_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    effects_label.position = Vector2(20, 35)
    effects_label.size = Vector2(360, 70)
    effects_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    effects_label.add_theme_font_size_override("font_size", 15)
    effects_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))  # Light gray text
    
    # Add all elements to the panel
    canvas_layer.add_child(panel)
    panel.add_child(title_label)
    panel.add_child(effects_label)
    
    # Animate the notification entrance
    panel.modulate.a = 0.0
    panel.scale = Vector2(0.7, 0.7)
    
    var entrance_tween = create_tween()
    entrance_tween.set_parallel(true)
    entrance_tween.tween_property(panel, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_OUT)
    entrance_tween.tween_property(panel, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
    
    # Subtle pulsing glow effect to the title
    var title_tween = create_tween()
    title_tween.set_loops()
    title_tween.tween_property(title_label, "modulate:a", 0.8, 1.0)
    title_tween.tween_property(title_label, "modulate:a", 1.0, 1.0)
    
    # Auto-hide notification after 3 seconds
    var hide_timer = Timer.new()
    add_child(hide_timer)
    hide_timer.wait_time = 3.0
    hide_timer.one_shot = true
    hide_timer.timeout.connect(func():
        if notification_layer:
            _hide_notification()
        hide_timer.queue_free()
    )
    hide_timer.start()

func _hide_notification():
    if notification_layer:
        var panel = notification_layer.get_child(0)
        var exit_tween = create_tween()
        exit_tween.set_parallel(true)
        exit_tween.tween_property(panel, "modulate:a", 0.0, 0.2)
        exit_tween.tween_property(panel, "scale", Vector2(0.8, 0.8), 0.2)
        
        exit_tween.finished.connect(func():
            notification_layer.queue_free()
            notification_layer = null
        )
