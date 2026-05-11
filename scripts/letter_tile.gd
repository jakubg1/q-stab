extends Node2D

const LETTERS := "abcdefghijklmnopqrstuvwxyz*"
var letter := "a"

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
