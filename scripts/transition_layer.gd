extends CanvasLayer

signal transition_completed

@onready var color_rect = $ColorRect

func _ready():
	# Mulai dengan transparan
	color_rect.color = Color(0, 0, 0, 0)

func fade_in(duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, duration)
	await tween.finished
	
func fade_out(duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, duration)
	await tween.finished
	
func change_scene(target_path: String):
	# Fade to black
	await fade_in(1.0)
	
	# Change scene
	get_tree().change_scene_to_file(target_path)
	
	# Fade to transparent
	await fade_out(1.0)
	
	# Signal that transition is done
	transition_completed.emit()

	queue_free()
