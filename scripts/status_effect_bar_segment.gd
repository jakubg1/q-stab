extends Sprite2D

## Sets the bar segment index. This is its position.
func setIndex(index: int) -> void:
	position.x = index * 11

## Sets whether this segment is filled.
func setFilled(filled: bool) -> void:
	texture.region = Rect2(16 if filled else 0, 0, 16, 0)

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
