extends Area2D

@export var next_level_path: String = "res://test_scenes/enemy_chase_templar.tscn"

func _ready() -> void:
	# Pastikan Area2D hanya berinteraksi dengan player
	monitoring = true
	monitorable = false
	print("Next level stair ready!")
	
	# Tambahkan signal body entered untuk mendeteksi player
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	print("Body entered: ", body.name)
	
	# Periksa apakah yang masuk adalah player
	if body.is_in_group("player"):
		print("Player detected!")
		# Tunjukkan indikator visual kalau bisa naik tangga (opsional)
		_show_indicator()
		
		# Tunggu input player untuk naik tangga
		await get_tree().create_timer(0.5).timeout
		
		# Transisi ke level berikutnya
		_go_to_next_level()
	else:
		print("Not a player! Groups: ", body.get_groups())

func _show_indicator() -> void:
	# Opsional: Tampilkan indikator atau petunjuk visual
	# Misalnya, tampilkan teks "Press E to climb"
	# Jika kamu punya UI Manager, kamu bisa memanggilnya di sini
	pass

func _go_to_next_level() -> void:
	# Tunjukkan transisi fade out (opsional)
	# Jika kamu punya transition manager, kamu bisa memanggilnya di sini
	
	# Tambahkan efek transisi sederhana
	var transition = ColorRect.new()
	transition.color = Color(0, 0, 0, 0) # Mulai transparan
	transition.size = get_viewport().size
	transition.z_index = 100
	get_tree().root.add_child(transition)
	
	# Animasi fade-out
	var tween = create_tween()
	tween.tween_property(transition, "color:a", 1.0, 1.0)
	
	# Tunggu sampai fade selesai
	await tween.finished
	
	# Pindah ke level berikutnya
	get_tree().call_deferred("change_scene_to_file", next_level_path)
