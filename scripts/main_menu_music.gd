extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPalyer.play_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
