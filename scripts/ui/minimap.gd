extends CanvasLayer

@onready var minimap = $MinimapContainer/MarginContainer/MinimapViewport/Minimap
@onready var player_marker = $MinimapContainer/MarginContainer/MinimapViewport/Minimap/PlayerMarker
@onready var enemy_marker_scene = preload("res://scenes/enemy_marker.tscn")
@onready var minimap_rect = $MinimapContainer/MarginContainer/MinimapViewport

var markers = {}
var map_scale = 0.1  # Adjust this based on your game's scale
var minimap_size = Vector2(200, 200)  # Default size, will be updated in _ready

func _ready():
    # Get actual minimap size
    await get_tree().process_frame
    minimap_size = minimap_rect.size
    
    # Register player and all enemies
    call_deferred("register_player")
    call_deferred("register_enemies")

func register_player():
    var player = get_tree().get_first_node_in_group("Player")
    if player:
        # Set initial position
        player_marker.position = clamp_to_minimap(player.global_position * map_scale)

func register_enemies():
    var enemies = get_tree().get_nodes_in_group("Enemy")
    for enemy in enemies:
        add_enemy_marker(enemy)

func add_enemy_marker(enemy):
    var marker = enemy_marker_scene.instantiate()
    minimap.add_child(marker)
    markers[enemy] = marker
    marker.position = clamp_to_minimap(enemy.global_position * map_scale)

func clamp_to_minimap(pos):
    # Calculate the maximum distance from center
    var half_width = minimap_size.x / 2 - 5  # 5 pixels margin
    var half_height = minimap_size.y / 2 - 5
    
    # Get distance from center
    var distance = pos.length()
    
    # If outside bounds, clamp to boundary
    if distance > min(half_width, half_height):
        pos = pos.normalized() * min(half_width, half_height)
    
    return pos

func _process(_delta):
    update_minimap()

func update_minimap():
    # Update player position
    var player = get_tree().get_first_node_in_group("Player")
    if player:
        player_marker.position = clamp_to_minimap(player.global_position * map_scale)
    
    # Update enemy positions or remove markers for defeated enemies
    var enemies_to_remove = []
    
    # Check if enemies are still valid
    for enemy in markers.keys():
        if not is_instance_valid(enemy) or not enemy.is_inside_tree() or (enemy.has_method("get_health") and enemy.health <= 0):
            enemies_to_remove.append(enemy)
        else:
            markers[enemy].position = clamp_to_minimap(enemy.global_position * map_scale)
    
    # Remove invalid enemies
    for enemy in enemies_to_remove:
        if enemy in markers:
            markers[enemy].queue_free()
            markers.erase(enemy)
    
    # Add markers for new enemies
    var enemies = get_tree().get_nodes_in_group("Enemy")
    for enemy in enemies:
        if not enemy in markers:
            add_enemy_marker(enemy)
