extends GoblinState

@export var attack_range := 25.0
@export var damage_amount := 10.0
@export var attack_cooldown := 1.0

var can_attack := true
var timer: Timer

func _ready() -> void:
    super._ready()
    timer = Timer.new()
    timer.wait_time = attack_cooldown
    timer.one_shot = true
    timer.timeout.connect(_on_timer_timeout)
    add_child(timer)

func enter(previous_state_path: String, data := {}) -> void:
    # Check if target is valid before proceeding
    if not is_instance_valid(target):
        finished.emit(IDLE)
        return
        
    # Apply damage immediately when entering attack state
    if can_attack and target.has_method("attacked"):
        target.attacked(damage_amount)
        can_attack = false
        timer.start()
    
    # Play animation (just visual, damage already dealt)
    player.animation_player.play("attack_1")

func physics_update(_delta: float) -> void:
    # If target is no longer valid (dead or removed), go to idle
    if not is_instance_valid(target):
        finished.emit(IDLE)
        return
        
    if player.animation_player.is_playing():
        return

    # Get distance to player
    var distance = player.position.distance_to(target.position)
    
    # If player moved out of range
    if distance > attack_range:
        finished.emit(WALK)
        return
    
    # If animation finished but we can attack again
    if can_attack:
        # Apply damage immediately
        if target.has_method("attacked"):
            target.attacked(damage_amount)
            can_attack = false
            timer.start()
        
        # Play animation (just visual)
        player.animation_player.play("attack_1")
    else:
        # Face the player while waiting for cooldown
        var direction = (target.position - player.position).normalized()
        if direction.x != 0:
            player.animation_player.flip_h = direction.x < 0

func _on_timer_timeout() -> void:
    can_attack = true
