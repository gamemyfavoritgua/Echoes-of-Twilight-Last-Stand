extends Node

@export var fill_duration_sec: float = 17.0  # total detik sampai penuh
@export var buff_amount: int = 20
@export var health_drain: int = 3

@onready var twilight_progress = $CanvasLayer/TwilightProgress
@onready var fill_timer = $FillTimer
@onready var drain_timer = $DrainTimer

var buff_applied: bool = false
var player: CharacterBody2D = null

func _ready():
	fill_timer.start()
	drain_timer.stop()
	twilight_progress.max_value = fill_duration_sec
	
func _on_fill_timer_timeout():
	if buff_applied:
		return

	twilight_progress.value += 1  # naik 1 per detik
	if twilight_progress.value >= twilight_progress.max_value:
		# bar sudah penuh → apply buff & mulai drain
		apply_buff()
		drain_timer.start()
		fill_timer.stop()

func _on_drain_timer_timeout():
	if player != null:
		player.attacked(health_drain, true)
		
func apply_buff():
	buff_applied = true
	if player != null:
		player.buff(buff_amount)
