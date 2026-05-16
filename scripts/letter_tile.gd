extends Node2D

const LETTERS := "abcdefghijklmnopqrstuvwxyz*"
const LETTER_MAPPINGS := {"q": "qu"}
const LETTER_SCORES := {
	"a": 1, "b": 3, "c": 3, "d": 2, "e": 1, "f": 4, "g": 2, "h": 4, "i": 1,
	"j": 10, "k": 5, "l": 1, "m": 3, "n": 1, "o": 1, "p": 3, "q": 10, "r": 1,
	"s": 1, "t": 1, "u": 2, "v": 4, "w": 5, "x": 10, "y": 4, "z": 10, "*": 0
}
const LETTER_WEIGHTS: Dictionary[Variant, int] = {
	# Scores -> weights: 1 -> 10, 2 -> 7, 3 -> 5, 4 -> 3, 5 -> 2, 10 -> 1
	"a": 10, "b": 5, "c": 5, "d": 7, "e": 10, "f": 3, "g": 7, "h": 3, "i": 10,
	"j": 1, "k": 2, "l": 10, "m": 5, "n": 10, "o": 10, "p": 5, "q": 1, "r": 10,
	"s": 10, "t": 10, "u": 7, "v": 3, "w": 2, "x": 1, "y": 3, "z": 1, "*": 0
}
var letter := "a"
var onRack := true
var rackIndex := 0
var destroyed := false

# Sets a letter on this Tile.
# `letter` must be a valid lowercase letter.
func setLetter(letter: String) -> void:
	self.letter = letter
	var index = LETTERS.find(letter)
	var x = index % 9
	var y = index / 9 + 1
	$Tile/Letter.texture.region = Rect2(x * 20, y * 20, 20, 20)

# Returns the letter on this Tile. This is always a single character.
# For example, for the Q tile this returns "q".
func getLetter() -> String:
	return letter

# Returns the letter or multiple letters this Tile is used for a word.
# For example, for the Q tile this returns "qu".
func getWordComponent() -> String:
	return LETTER_MAPPINGS[letter] if letter in LETTER_MAPPINGS else letter

# Returns this Tile's letter score.
func getScore() -> int:
	return LETTER_SCORES[letter]

# Sets whether this tile is currently on rack.
func setOnRack(onRack: bool) -> void:
	self.onRack = onRack

# Returns whether this tile is currently on rack.
func isOnRack() -> bool:
	return onRack

# Sets this tile's rack index.
func setRackIndex(index: int) -> void:
	self.rackIndex = index

# Returns this tile's rack index.
# This is used so that the tile can be moved back to its home position on the rack.
func getRackIndex() -> int:
	return rackIndex

# Returns `true` if this tile is hovered.
func isHovered() -> bool:
	return $Hover.hovered

# Destroys this tile.
func destroy() -> void:
	# This tile will still exist until the end of frame, and we need the destruction fact now.
	destroyed = true
	queue_free()

# Returns whether this tile is destroyed, i.e. `destroy()` has been called but the node still exists.
func isDestroyed() -> bool:
	return destroyed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setLetter(Utils.weightedRandomKeys(LETTER_WEIGHTS))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
