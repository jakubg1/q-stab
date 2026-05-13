extends Node2D

const LETTER_TILE := preload("res://scenes/letter_tile.tscn")
var tiles: Dictionary[int, Node] = {}

# Returns the tile node position at specific index.
func getTilePosition(index: int) -> Vector2:
	return Vector2((index % 4) * 20, (index / 4) * 20)

# Adds a new tile to the rack at given index.
func addTile(index: int) -> void:
	var tile = LETTER_TILE.instantiate()
	tiles[index] = tile
	$Letters.add_child(tile)
	tile.position = getTilePosition(index)
	tile.setRackIndex(index)

# Returns the specified tile back to the rack.
func returnTile(tile: Node) -> void:
	tile.setOnRack(true)
	tile.reparent(self)
	tile.position = getTilePosition(tile.getRackIndex())

# Moves the specified tile to a different position.
# Overwrites whatever was at the position previously and sets the tile in old position to `null`.
func moveTile(tile: Node, index: int) -> void:
	tiles[tile.getRackIndex()] = null
	tiles[index] = tile
	tile.setRackIndex(index)
	tile.position = getTilePosition(tile.getRackIndex())

# Returns a tile at given tile index.
func getTile(index: int) -> Node:
	return tiles[index]

# Returns the first tile matching the given letter, or `null` if there isn't any.
func getTileFromLetter(letter: String) -> Node:
	for i in 16:
		var tile = getTile(i)
		if tile.isOnRack() and tile.getLetter() == letter:
			return tile
	return null

# Returns the currently hovered tile, or `null` if there isn't any.
func getHoveredTile() -> Node:
	for i in 16:
		var tile = getTile(i)
		if tile.isOnRack() and tile.isHovered():
			return tile
	return null

# Purges destroyed tiles, makes existing ones fall down in the holes and new ones fall from the top.
func fill() -> void:
	# Purge destroyed tiles.
	for i in 16:
		if getTile(i).isDestroyed():
			tiles[i] = null
	# Fall existing tiles into the newly created holes and spawn new tiles, column by column.
	for x in 4:
		for y in range(3, -1, -1): # Iterates through [3, 2, 1, 0]. Essentially, we are working our way up.
			var index = x + y * 4
			if getTile(index):
				continue # There is a tile there, leave it alone.
			# If we have arrived here, this space is empty.
			# Look for a tile above us that we could fit here.
			var seekTile = null
			for seekY in range(y - 1, -1, -1): # Working our way up from the tile one above.
				seekTile = getTile(x + seekY * 4)
				if seekTile:
					break # We found a tile. Seek over.
			# If we found a tile above us, move it here. Otherwise, spawn a new tile.
			if seekTile:
				moveTile(seekTile, index)
			else:
				addTile(index)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 16:
		addTile(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
