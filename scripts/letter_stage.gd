extends Node2D

var tiles: Array[Node] = []

# Takes the specified tile out of the rack and moves it to the stage.
func addTile(tile: Node) -> void:
	pass

# Removes the last tile from the stage and moves it back to the rack.
func removeTile() -> void:
	pass

# Removes all tiles from the stage and moves them back to the rack.
func removeAllTiles() -> void:
	while len(tiles) > 0:
		removeTile()

# Returns a word comprised of the current tiles in the stage.
func getWord() -> String:
	return ""

# Returns a tile node position based on the index in the stage.
func getTilePosition(i: int) -> Vector2:
	return Vector2(i * 20 - (len(tiles) - 1) * 10, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
