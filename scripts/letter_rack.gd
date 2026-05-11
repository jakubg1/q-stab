extends Node2D

const LETTER_TILE := preload("res://scenes/letter_tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 16:
		var x = i % 4
		var y = i / 4
		var tile = LETTER_TILE.instantiate()
		$Letters.add_child(tile)
		tile.position = Vector2(x * 20 + 10, y * 20 + 10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
