extends Node2D

var tiles: Array[Node] = []

# Takes the specified tile out of the rack and moves it to the stage.
func addTile(tile: Node) -> void:
	tile.setOnRack(false)
	tile.reparent(self)
	tiles.append(tile)
	refreshTilePositions()

# Removes the last tile from the stage and returns it.
func removeTile() -> Node:
	var tile = tiles.pop_back()
	refreshTilePositions()
	return tile

# Removes all tiles from the stage and moves them back to the rack.
func removeAllTiles() -> void:
	while len(tiles) > 0:
		removeTile()

# Destroys all tiles in the stage. This is supposed to run after successfully submitting a word.
func destroyTiles() -> void:
	while len(tiles) > 0:
		var tile = tiles.pop_back()
		tile.destroy()

# Returns the most recent (rightmost) tile in the stage, or `null` if the stage is empty.
func getLastTile() -> Node:
	return tiles[-1] if len(tiles) > 0 else null

# Returns the currently hovered tile in the stage, or `null` if none is hovered.
func getHoveredTile() -> Node:
	for tile in tiles:
		if tile.isHovered():
			return tile
	return null

# Returns a word comprised of the current tiles in the stage.
func getWord() -> String:
	var word = ""
	for tile in tiles:
		word += tile.getWordComponent()
	return word

# Returns a tile node position based on the index in the stage.
func getTilePosition(i: int) -> Vector2:
	return Vector2(i * 20 - len(tiles) * 10, 0)

# Moves all tiles on stage to their correct locations.
func refreshTilePositions() -> void:
	for i in range(len(tiles)):
		tiles[i].position = getTilePosition(i)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
