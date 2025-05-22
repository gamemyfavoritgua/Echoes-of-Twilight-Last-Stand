extends TextureProgressBar

@export var player: Player

func _ready():
	player.health_change.connect(update)

func update():
	value = player.health * 100 / player.max_health
