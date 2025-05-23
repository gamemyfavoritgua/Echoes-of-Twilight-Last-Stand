class_name GoblinState extends State

const IDLE = "Idle"
const WALK = "Walk"
const HURT = "Hurt"
const DEATH = "Death"
const ATTACK = "Attack"

var player: Goblin
var target: Player
var find_target_timer: Timer

func _ready() -> void:
	await owner.ready
	player = owner as Goblin
	assert(player != null, "The GoblinState state type must be used only in the goblin scene. It needs the owner to be a Goblin node.")
	
	# Create a timer to keep looking for the player if not found initially
	find_target_timer = Timer.new()
	find_target_timer.wait_time = 0.5
	find_target_timer.autostart = true
	find_target_timer.timeout.connect(_try_find_target)
	add_child(find_target_timer)
	
	# Initial attempt to find target
	_try_find_target()

func _try_find_target() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		target = players[0] as Player
		if target != null:
			find_target_timer.stop()
			find_target_timer.queue_free()
			# print("Goblin found player target successfully")
		else:
			push_warning("First node in 'Player' group is not a Player.")
	else:
		push_warning("No nodes in 'Player' group yet, will keep looking...")
