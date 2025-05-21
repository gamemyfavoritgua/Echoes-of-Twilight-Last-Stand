class_name GoblinState extends State

const IDLE = "Idle"
const WALK = "Walk"
const HURT = "Hurt"
const DEATH = "Death"
const ATTACK = "Attack"

var player: Goblin
var target: Player

func _ready() -> void:
	await owner.ready
	player = owner as Goblin
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")

	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		target = players[0] as Player
		if target == null:
			push_error("First node in 'Player' group is not a Player.")
	else:
		push_error("No nodes in 'Player' group.")
