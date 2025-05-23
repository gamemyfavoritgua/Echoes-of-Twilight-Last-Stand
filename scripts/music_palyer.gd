extends Node

var music_stream: AudioStream = preload("res://assets/Sound Asset/main_menu.mp3")
var audio_player: AudioStreamPlayer

func _ready():
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = music_stream
	audio_player.bus = "Music"
	audio_player.volume_db = -25.037
	add_child(audio_player)

func play_music():
	if not audio_player.playing:
		audio_player.play()

func stop_music():
	if audio_player.playing:
		audio_player.stop()
