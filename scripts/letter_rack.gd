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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 16:
		addTile(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
