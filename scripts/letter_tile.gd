extends Node2D

const LETTERS := "abcdefghijklmnopqrstuvwxyz*"
var letter := "a"
var onRack := true
var rackIndex := 0

# Sets a letter on this Tile.
# `letter` must be a valid lowercase letter.
func setLetter(letter: String) -> void:
	self.letter = letter
	var index = LETTERS.find(letter)
	var x = index % 9
	var y = index / 9 + 1
	$Tile/Letter.texture.region = Rect2(x * 20, y * 20, 20, 20)

# Returns the letter on this Tile.
func getLetter() -> String:
	return letter

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var n = randi_range(0, 25)
	setLetter(LETTERS[n])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
