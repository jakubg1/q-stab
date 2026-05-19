extends Node2D

@onready var tileSprite: Sprite2D = $Tile
@onready var letterSprite: Sprite2D = $Tile/Letter
@onready var valueSprite: Sprite2D = $Tile/Value
@onready var hoverArea: Area2D = $Hover

const LETTERS := "abcdefghijklmnopqrstuvwxyz*"
const LETTER_MAPPINGS := {"q": "qu"}
const LETTER_VALUES := {
	"a": 1, "b": 3, "c": 3, "d": 2, "e": 1, "f": 4, "g": 2, "h": 4, "i": 1,
	"j": 10, "k": 5, "l": 1, "m": 3, "n": 1, "o": 1, "p": 3, "q": 10, "r": 1,
	"s": 1, "t": 1, "u": 2, "v": 4, "w": 5, "x": 10, "y": 4, "z": 10, "*": 0
}
const LETTER_WEIGHTS: Dictionary[Variant, int] = {
	# Scores -> weights: 1 -> 15, 2 -> 10, 3 -> 7, 4 -> 5, 5 -> 3, 10 -> 2
	# Vowels have their weights multiplied by x1.5.
	"a": 23, "b": 7, "c": 7, "d": 10, "e": 23, "f": 5, "g": 10, "h": 5, "i": 23,
	"j": 2, "k": 3, "l": 15, "m": 7, "n": 15, "o": 23, "p": 7, "q": 2, "r": 15,
	"s": 15, "t": 15, "u": 15, "v": 5, "w": 3, "x": 2, "y": 5, "z": 2, "*": 0
}
var letter := "a"
var gemType := Enums.GemType.NONE
var gemIndex := 1
var onRack := true
var rackIndex := 0
var destroyed := false

## Readjusts the tile's display.
func refreshDisplay() -> void:
	tileSprite.texture.region = Rect2(gemType * 20, 0, 20, 20)
	var index = LETTERS.find(letter)
	var x = index % 9
	var y = index / 9 + 1
	letterSprite.texture.region = Rect2(x * 20, y * 20, 20, 20)
	valueSprite.texture.region = Rect2(0, getValue() * 7, 8, 7)

## Sets a letter on this Tile.
## `letter` must be a valid lowercase letter.
func setLetter(letter: String) -> void:
	self.letter = letter
	refreshDisplay()

## Returns the letter on this Tile. This is always a single character.
## For example, for the Q tile this returns "q".
func getLetter() -> String:
	return letter

## Sets the gem type on this Tile.
func setGemType(gemType: Enums.GemType) -> void:
	self.gemType = gemType
	refreshDisplay()

## Returns the current gem type on this Tile.
func getGemType() -> Enums.GemType:
	return gemType

## Sets which occurrence of this tile's particular gem type this tile is in the staged word.
## Used to calculate bonuses when two or more tiles of the same gem type are in a single word.
## Set to 1 when in the rack; the tiles would display as if that was its first gem type occurrence.
func setGemIndex(gemIndex: int) -> void:
	self.gemIndex = gemIndex
	refreshDisplay()

## Returns which occurrence of this tile's particular gem type this tile is in the staged word.
func getGemIndex() -> int:
	return gemIndex

## Returns the letter or multiple letters this Tile is used for a word.
## For example, for the Q tile this returns "qu".
func getWordComponent() -> String:
	return LETTER_MAPPINGS[letter] if letter in LETTER_MAPPINGS else letter

## Returns this Tile's letter base value, including enhancements.
func getValue() -> int:
	var value = LETTER_VALUES[letter]
	if gemType == Enums.GemType.YELLOW:
		value += 5 + (gemIndex - 1) * 2
	return value

## Returns the word multiplier coming from this Tile, if it has a gem effect.
func getWordMultiplier() -> float:
	match gemType:
		Enums.GemType.GREEN:
			return 1.1
		Enums.GemType.RED:
			return 1.2
		Enums.GemType.PURPLE:
			return 1.3
	return 1.0

## Returns the status effect this Tile can inflict.
func getEffect() -> Enums.StatusEffectType:
	match gemType:
		Enums.GemType.GREEN:
			return Enums.StatusEffectType.POISON
	return Enums.StatusEffectType.NONE

## Returns the duration of the status effect this Tile can inflict.
func getEffectDuration() -> int:
	match gemType:
		Enums.GemType.GREEN:
			return 3 + (gemIndex - 1)
	return 0

## Sets whether this tile is currently on rack.
func setOnRack(onRack: bool) -> void:
	self.onRack = onRack

## Returns whether this tile is currently on rack.
func isOnRack() -> bool:
	return onRack

## Sets this tile's rack index.
func setRackIndex(index: int) -> void:
	self.rackIndex = index

## Returns this tile's rack index.
## This is used so that the tile can be moved back to its home position on the rack.
func getRackIndex() -> int:
	return rackIndex

## Returns `true` if this tile is hovered.
func isHovered() -> bool:
	return hoverArea.hovered

## Destroys this tile.
func destroy() -> void:
	# This tile will still exist until the end of frame, and we need the destruction fact now.
	destroyed = true
	queue_free()

## Returns whether this tile is destroyed, i.e. `destroy()` has been called but the node still exists.
func isDestroyed() -> bool:
	return destroyed

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setLetter(Utils.weightedRandomKeys(LETTER_WEIGHTS))

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
