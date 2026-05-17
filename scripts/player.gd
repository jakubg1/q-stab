extends Entity

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init(40)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when an enemy performs an attack towards the player.
func _on_enemy_attacked(damage: int) -> void:
	damage(damage)
