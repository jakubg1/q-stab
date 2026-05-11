extends Node2D

const LETTER_TILE := preload("res://scenes/letter_tile.tscn")
var tiles: Dictionary[int, Node] = {}

# Returns the tile node position at specific coordinates.
func getTilePosition(x: int, y: int) -> Vector2:
	return Vector2(x * 20 + 10, y * 20 + 10)

# Adds a new tile to the rack at given coordinates.
func addTile(index: int) -> void:
	var tile = LETTER_TILE.instantiate()
	tiles[index] = tile
	$Letters.add_child(tile)
	tile.position = getTilePosition(index % 4, index / 4)

# Returns a tile at given tile index.
func getTile(index: int) -> Node:
	return tiles[index]

# Returns the first tile matching the given letter, or `null` if there isn't any.
func getTileFromLetter(letter: String) -> Node:
	for i in 16:
		var tile := getTile(i)
		if tile.getLetter() == letter:
			print(i)
			return tile
	return null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)
	for i in 16:
		addTile(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in 16:
		var tile := getTile(i)
		if tile.isHovered():
			print("Hovered: " + str(i))

# Called on an input event.
func _input(event: InputEvent):
	if event is InputEventKey && event.pressed:
		var code: int = event.get_unicode()
		if code != 0:
			var letter: String = char(event.get_unicode())
			print(getTileFromLetter(letter))
