class_name EliteOrc extends CharacterBody2D

@export var speed := 50.0
@export var max_health := 500
var health := max_health
var has_spawned_minions := false
@export_file("*.tscn") var item_scene_path := ""
@export var drop_chance := 0.5
@export_file("*.tscn") var minion_scene_path := ""
@onready var regen_timer := Timer.new()
var active_minions: Array = []
@onready var spawn_sfx_player := AudioStreamPlayer.new()


@onready var animation_player = $AnimatedSprite2D

func _ready() -> void:
    add_to_group("Enemy")
    health = max_health
    regen_timer.wait_time = 1.0  # tiap 1 detik
    regen_timer.one_shot = false
    regen_timer.autostart = false
    regen_timer.connect("timeout", Callable(self, "_on_regen_timeout"))
    add_child(regen_timer)
    add_child(spawn_sfx_player)
    spawn_sfx_player.stream = preload("res://assets/Sound Asset/sfx/goblin_spawn.wav")
    %BossHealthBar.max_value = max_health

func take_damage(damage_amount: float) -> void:
    health -= damage_amount
    var drop_position = global_position
    %BossHealthBar.value = health
    
    if health <= 0:
        print("Enemy health: ", health)
        var state_machine = get_node("StateMachine")
        if state_machine:
            state_machine._transition_to_next_state("Death")
        _try_drop_item(drop_position)
    elif health <= 250 and not has_spawned_minions:
        var state_machine = get_node("StateMachine")
        if state_machine:
            state_machine._transition_to_next_state("Hurt")
        has_spawned_minions = true
        _spawn_minions(global_position)
    else:
        var state_machine = get_node("StateMachine")
        if state_machine:
            state_machine._transition_to_next_state("Hurt")
            

func _try_drop_item(pos: Vector2) -> void:
    if randf() <= drop_chance:
        _spawn_item(pos)
        
func _spawn_item(pos: Vector2) -> void:
    if item_scene_path.is_empty():
        return
    
    var item_scene = load(item_scene_path)
    if item_scene:
        var item_instance = item_scene.instantiate()
        
        get_parent().call_deferred("add_child", item_instance)
        item_instance.global_position = pos

func _spawn_minions(pos: Vector2, count: int = 4) -> void:
    if minion_scene_path.is_empty():
        return

    var minion_scene = load(minion_scene_path)
    if not minion_scene:
        return

    var space_state = get_world_2d().direct_space_state
    var shape := CircleShape2D.new()
    shape.radius = 8.0

    var transform := Transform2D.IDENTITY
    var max_attempts := 20
    var spawned := 0

    while spawned < count and max_attempts > 0:
        var offset = Vector2(randf_range(-75, 75), randf_range(-75, 75))
        var spawn_pos = pos + offset
        transform.origin = spawn_pos

        var query := PhysicsShapeQueryParameters2D.new()
        query.shape = shape
        query.transform = transform
        query.collide_with_bodies = true
        query.collide_with_areas = true

        var result = space_state.intersect_shape(query, 1)

        if result.is_empty():
            var minion_instance = minion_scene.instantiate()
            get_parent().call_deferred("add_child", minion_instance)
            minion_instance.global_position = spawn_pos
            
            if spawn_sfx_player:
                spawn_sfx_player.play()

            active_minions.append(minion_instance)

            if minion_instance.has_signal("died"):
                minion_instance.connect("died", Callable(self, "_on_minion_died"), [minion_instance])

            spawned += 1

        max_attempts -= 1

    if active_minions.size() > 0:
        regen_timer.start()

    if active_minions.size() > 0:
        regen_timer.start()


func _on_minion_died(minion):
    if not is_instance_valid(minion):
        return
    active_minions.erase(minion)
    if active_minions.is_empty():
        regen_timer.stop()
        
func _on_regen_timeout():
    if active_minions.size() > 0 and health < max_health:
        health = min(health + 5, max_health)
        print("Boss regenerating... HP:", health)
