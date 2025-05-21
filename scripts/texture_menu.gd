extends TextureRect

func _ready():
	var video_player = $VideoStreamPlayer
	video_player.play()
	video_player.frame_changed.connect(_on_video_frame_changed.bind(video_player))

func _on_video_frame_changed(video_player):
	if video_player.get_video_texture() != null:
		self.texture = video_player.get_video_texture()
