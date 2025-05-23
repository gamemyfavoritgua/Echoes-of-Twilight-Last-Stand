# game_data.gd
extends Node

# Character types
enum CharacterType {SOLDIER, WIZARD, KNIGHT}

# Currently selected character
var selected_character = CharacterType.SOLDIER

# Character scene paths
var character_scenes = {
	CharacterType.SOLDIER: "res://scenes/character.tscn",
	CharacterType.WIZARD: "res://scenes/wizard.tscn",
	CharacterType.KNIGHT: "res://scenes/templar.tscn"
}

# Get the scene path for the selected character
func get_selected_character_scene():
	return character_scenes[selected_character]
