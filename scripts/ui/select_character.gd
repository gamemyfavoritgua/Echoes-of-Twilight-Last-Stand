# select_character.gd
extends MarginContainer

# Preload the transition scene
var transition_scene = preload("res://scenes/transition.tscn")

# Define the scenes to load for each character
@export var soldier_scene: String = "res://scenes/game.tscn" 
@export var wizard_scene: String = "res://scenes/game.tscn"
@export var knight_scene: String = "res://scenes/game.tscn"

# Called when the node enters the scene tree for the first time
func _ready():
    # Set up TextureRects
    var soldier = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect
    var wizard = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect2
    var knight = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect3
    
    # Make all characters darker by default
    for texture in [soldier, wizard, knight]:
        texture.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
        texture.mouse_filter = Control.MOUSE_FILTER_STOP
        texture.modulate = Color(0.5, 0.5, 0.5)
    
    # Connect hover effects
    soldier.mouse_entered.connect(func(): soldier.modulate = Color(1.0, 1.0, 1.0))
    soldier.mouse_exited.connect(func(): soldier.modulate = Color(0.5, 0.5, 0.5))
    
    wizard.mouse_entered.connect(func(): wizard.modulate = Color(1.0, 1.0, 1.0))
    wizard.mouse_exited.connect(func(): wizard.modulate = Color(0.5, 0.5, 0.5))
    
    knight.mouse_entered.connect(func(): knight.modulate = Color(1.0, 1.0, 1.0))
    knight.mouse_exited.connect(func(): knight.modulate = Color(0.5, 0.5, 0.5))
    
    # Connect click handlers
    soldier.gui_input.connect(func(event): 
        if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
            GameData.selected_character = GameData.CharacterType.SOLDIER
            _change_scene(soldier_scene)
    )
    
    wizard.gui_input.connect(func(event): 
        if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
            GameData.selected_character = GameData.CharacterType.WIZARD
            _change_scene(wizard_scene)
    )
    
    knight.gui_input.connect(func(event): 
        if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
            GameData.selected_character = GameData.CharacterType.KNIGHT
            _change_scene(knight_scene)
    )

# Change scene with transition effect
func _change_scene(target_scene):
    # Store the selected character type in autoload or global variable
    # (You might need to create a global script to store this data)
    
    # Create transition
    var transition = transition_scene.instantiate()
    get_tree().root.add_child(transition)
    
    # Change scene using transition
    transition.change_scene(target_scene)
