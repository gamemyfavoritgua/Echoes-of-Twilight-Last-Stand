extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    body_entered.connect(_on_body_entered_hit)

func _on_body_entered_hit(body: Node):
    if body.is_in_group('enemy'):
        print('ENEMY TAKEN DAMAGE')
