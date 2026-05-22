extends Node2D

var tiles: Array[Node] = []

signal word_updated(valid: bool)

## Takes the specified tile out of the rack and moves it to the stage.
func addTile(tile: Node) -> void:
	tile.setOnRack(false)
	tile.reparent(self)
	tiles.append(tile)
	refreshTilePositions()
	refreshTileGemIndices()
	word_updated.emit(WordDictionary.isWordValid(getWord()))

## Removes the last tile from the stage and returns it.
func removeTile() -> Node:
	var tile = tiles.pop_back()
	refreshTilePositions()
	refreshTileGemIndices()
	word_updated.emit(WordDictionary.isWordValid(getWord()))
	return tile

## Removes all tiles from the stage and moves them back to the rack.
func removeAllTiles() -> void:
	tiles.clear()
	refreshTilePositions()
	refreshTileGemIndices()
	word_updated.emit(false)

## Destroys all tiles in the stage. This is supposed to run after successfully submitting a word.
func destroyTiles() -> void:
	while len(tiles) > 0:
		var tile = tiles.pop_back()
		tile.destroy()
	word_updated.emit(false)

## Returns whether the stage is empty.
func isEmpty() -> bool:
	return len(tiles) == 0

## Returns the most recent (rightmost) tile in the stage, or `null` if the stage is empty.
func getLastTile() -> Node:
	return tiles[-1] if len(tiles) > 0 else null

## Returns the currently hovered tile in the stage, or `null` if none is hovered.
func getHoveredTile() -> Node:
	for tile in tiles:
		if tile.isHovered():
			return tile
	return null

## Returns a word comprised of the current tiles in the stage.
func getWord() -> String:
	var word = ""
	for tile in tiles:
		word += tile.getWordComponent()
	return word

## Returns the base score of the current word in stage.
func getWordScore() -> int:
	var score = 0
	for tile in tiles:
		score += tile.getValue()
	return score

## Returns the score multiplier of the current word in stage, such as from gem effects.
func getWordMultiplier() -> float:
	var mult = 1.0
	for tile in tiles:
		mult *= tile.getWordMultiplier()
	return mult

## Returns an array of status effects which is eligible data to be put in an attack.
## This is an array of all status effects which this word will inflict.
func getWordEffects() -> Array:
	var effects = {} # Maps effect types to durations. Longest duration wins.
	for tile in tiles:
		var effect = tile.getEffect()
		if effect != Enums.StatusEffectType.NONE:
			var duration = tile.getEffectDuration()
			if effect in effects:
				effects[effect] = max(effects[effect], duration)
			else:
				effects[effect] = duration
	var result = []
	for effect in effects:
		result.append({"type": "effect", "effect": effect, "turns": effects[effect]})
	return result

## Returns a tile node position based on the index in the stage.
func getTilePosition(i: int) -> Vector2:
	return Vector2(i * 20 - len(tiles) * 10, 0)

## Moves all tiles on stage to their correct locations.
func refreshTilePositions() -> void:
	for i in range(len(tiles)):
		tiles[i].position = getTilePosition(i)

## Updates all staged tiles' gem indices used to calculate double gem bonuses.
func refreshTileGemIndices() -> void:
	var gemCounts = {}
	for i in range(len(tiles)):
		var gemType = tiles[i].getGemType()
		if not gemType in gemCounts:
			gemCounts[gemType] = 0
		gemCounts[gemType] += 1
		tiles[i].setGemIndex(gemCounts[gemType])

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
