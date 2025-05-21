extends LinkButton

@export var scene_to_load: String

func _on_Start_Game_pressed():
	get_tree().change_scene_to_file("res://scenes/" + scene_to_load + ".tscn")
	
func _on_Tutorial_pressed():
	get_tree().change_scene_to_file("res://scenes/" + scene_to_load + ".tscn")
