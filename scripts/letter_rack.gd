extends Node2D

const LETTER_TILE := preload("res://scenes/letter_tile.tscn")
var tiles: Dictionary[int, LetterTile] = {}

## Returns the tile node position at specific index.
func getTilePosition(index: int) -> Vector2:
	return Vector2((index % 4) * 20, (index / 4) * 20)

## Adds a new tile to the rack at given index.
func addTile(index: int) -> void:
	var tile = LETTER_TILE.instantiate()
	tiles[index] = tile
	$Letters.add_child(tile)
	tile.setPos(getTilePosition(index))
	tile.setRackIndex(index)

## Returns the specified tile back to the rack.
func returnTile(tile: LetterTile) -> void:
	tile.setOnRack(true)
	tile.setGemIndex(1)
	tile.reparent(self)
	tile.setPos(getTilePosition(tile.getRackIndex()))

## Moves the specified tile to a different position.
## Overwrites whatever was at the position previously and sets the tile in old position to `null`.
func moveTile(tile: LetterTile, index: int) -> void:
	tiles[tile.getRackIndex()] = null
	tiles[index] = tile
	tile.setRackIndex(index)
	tile.setPos(getTilePosition(tile.getRackIndex()))

## Returns a tile at given tile index.
func getTile(index: int) -> LetterTile:
	return tiles[index]

## Returns the first selectable tile matching the given letter, or `null` if there isn't any.
func getTileFromLetter(letter: String) -> LetterTile:
	for i in 16:
		var tile = getTile(i)
		if tile.isOnRack() and tile.isSelectable() and tile.getLetter() == letter:
			return tile
	return null

## Returns the first selectable enhanced tile matching the given letter.
## Falls back to `getTileFromLetter()` if no enhanced tile is found.
func getEnhancedTileFromLetter(letter: String) -> LetterTile:
	for i in 16:
		var tile = getTile(i)
		if tile.isOnRack() and tile.isSelectable() and tile.getLetter() == letter and tile.getGemType() != Enums.GemType.NONE:
			return tile
	return getTileFromLetter(letter)

## Returns the first selectable regular tile matching the given letter.
## Falls back to `getTileFromLetter()` if no regular tile is found.
func getRegularTileFromLetter(letter: String) -> LetterTile:
	for i in 16:
		var tile = getTile(i)
		if tile.isOnRack() and tile.isSelectable() and tile.getLetter() == letter and tile.getGemType() == Enums.GemType.NONE:
			return tile
	return getTileFromLetter(letter)

## Returns a random tile that is currently on the rack, or `null` if there isn't any.
func getRandomTile() -> LetterTile:
	var tiles = []
	for i in 16:
		var tile = getTile(i)
		if tile.isOnRack():
			tiles.append(tile)
	if len(tiles) > 0:
		return tiles[randi_range(0, len(tiles) - 1)]
	return null

## Returns a random tile that is currently on the rack and not a gem, or `null` if there isn't any.
func getRandomNonGemTile() -> LetterTile:
	var tiles = []
	for i in 16:
		var tile = getTile(i)
		if tile.isOnRack() and tile.getGemType() == Enums.GemType.NONE:
			tiles.append(tile)
	if len(tiles) > 0:
		return tiles[randi_range(0, len(tiles) - 1)]
	return null

## Returns a random tile that is currently on the rack and with no effect, or `null` if there isn't any.
func getRandomNonEffectTile() -> LetterTile:
	var tiles = []
	for i in 16:
		var tile = getTile(i)
		if tile.isOnRack() and tile.getEffectType() == Enums.TileEffectType.NONE:
			tiles.append(tile)
	if len(tiles) > 0:
		return tiles[randi_range(0, len(tiles) - 1)]
	return null

## Returns the currently hovered tile, or `null` if there isn't any.
func getHoveredTile() -> LetterTile:
	for i in 16:
		var tile = getTile(i)
		if tile.isOnRack() and tile.isHovered():
			return tile
	return null

## Purges destroyed tiles, makes existing ones fall down in the holes and new ones fall from the top.
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

## Ticks tile effects on all tiles on the rack.
func tickTileEffects() -> void:
	for i in 16:
		var tile = getTile(i)
		if tile:
			tile.tickEffect()

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 16:
		addTile(i)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when the player is attacked with a tile effect attack.
func _on_player_tile_effect_attack_received(effect: int, duration: int, amount: int) -> void:
	for i in amount:
		var tile = getRandomNonEffectTile()
		if tile:
			tile.setEffectType(effect, duration)

## Called when the battle's volley has ended.
func _on_battle_turn_ended() -> void:
	tickTileEffects()
