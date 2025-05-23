extends Area2D

# Optional: filter by class or group name
@export var target_node: Node
@export var player_name: String = "Player"  # Or use a group name like "player"

func _ready():
	if not target_node:
		push_error("No target node assigned to AreaTrigger.")
		return

	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	# Filter only the player
	if body.name == player_name or body.is_in_group(player_name):
		target_node._on_player_entered(body)
