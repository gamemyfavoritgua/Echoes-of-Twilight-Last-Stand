# level1.gd
extends Node2D

# Called when the node enters the scene tree for the first time
func _ready():
	# Get the character scene path based on the player's selection
	var character_scene_path = GameData.get_selected_character_scene()
	
	# Load and instantiate the selected character
	var character_scene = load(character_scene_path)
	var character_instance = character_scene.instantiate()
	
	# Set the character position (adjust as needed)
	character_instance.position = Vector2(-35, 25)
	
	# Add the character to the scene
	add_child(character_instance)
