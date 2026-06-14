extends AnimatedSprite2D
class_name EnemySprite

const ENEMY = preload("uid://uog22fluoaog")
const ENEMY_FLASH = preload("uid://t4xdig2xl8bu")

## Sets whether this sprite is currently flashing (white).
func setFlashing(flashing: bool) -> void:
	material = ENEMY_FLASH if flashing else ENEMY

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
