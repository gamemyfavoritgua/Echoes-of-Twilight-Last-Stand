extends Control

func _ready() -> void:
    # Ensure this menu can process while the game is paused
    process_mode = Node.PROCESS_MODE_WHEN_PAUSED
    visible = false

func _on_resume_button_pressed() -> void:
    get_parent().get_parent().toggle_pause()

func _on_main_menu_button_pressed() -> void:
    get_tree().paused = false  # Unpause before changing scene
    get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
