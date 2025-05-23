extends Node

var is_paused = false
var pause_menu_instance = null

func _ready() -> void:
    # Create the pause menu and add it to the scene tree
    var pause_menu_scene = load("res://scenes/pause_menu.tscn")
    pause_menu_instance = pause_menu_scene.instantiate()
    
    # Create a CanvasLayer to ensure the pause menu appears on top of everything
    var canvas_layer = CanvasLayer.new()
    canvas_layer.layer = 10  # High layer number ensures it's on top
    add_child(canvas_layer)
    canvas_layer.add_child(pause_menu_instance)
    
    pause_menu_instance.visible = false
    pause_menu_instance.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _input(event) -> void:
    if event.is_action_pressed("ui_cancel"):  # ESC key
        toggle_pause()
        
func toggle_pause() -> void:
    is_paused = !is_paused
    
    if is_paused:
        pause_menu_instance.visible = true
        get_tree().paused = true
    else:
        pause_menu_instance.visible = false
        get_tree().paused = false
