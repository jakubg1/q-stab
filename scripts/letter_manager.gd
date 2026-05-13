extends Node

@onready var letterRack: Node2D = $LetterRack
@onready var letterStage: Node2D = $LetterStage

signal word_submitted(score: int)

# Moves a letter from the specified index in the rack to the stage.
func moveLetterToStage(index: int) -> void:
	var tile = letterRack.getTile(index)
	if tile:
		letterStage.addTile(tile)

# Moves a letter from the specified key being pressed from the rack to the stage.
func moveLetterToStageFromKey(letter: String) -> void:
	# Do not move a U after a Qu tile. QoL FTW!
	if letter == "u":
		var lastTile = letterStage.getLastTile()
		if lastTile and lastTile.getLetter() == "q":
			return
	# Look for the appropriate tile in the rack and move it if it exists.
	var tile = letterRack.getTileFromLetter(letter)
	if tile:
		letterStage.addTile(tile)

# Moves the last letter from the stage back to the rack and returns it.
# If no letters were in the stage, does nothing and returns `null`.
func moveLetterToRack() -> Node:
	var tile = letterStage.removeTile()
	if tile:
		letterRack.returnTile(tile)
	return tile

# Moves all letters from the stage back to the rack.
func moveAllLettersToRack() -> void:
	while true:
		var lastTile = moveLetterToRack()
		if not lastTile:
			break

# Moves all letters from the stage back to the rack until the specified tile (inclusive!).
func moveLettersToRackUntil(tile: Node) -> void:
	while true:
		var lastTile = moveLetterToRack()
		if not lastTile or lastTile == tile:
			break

# Checks if the specified word is valid and returns `true` if so, `false` otherwise.
func isWordValid(word: String) -> bool:
	# Obviously this will be more sophisticated than that eventually.
	return len(word) > 0

# Attempts to submit the word in rack.
func submitWord() -> void:
	var word = letterStage.getWord()
	var score = letterStage.getWordScore()
	if isWordValid(word):
		letterStage.destroyTiles()
		letterRack.fill()
		print(word + " for " + str(score))
		word_submitted.emit(score)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called on an input event.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		# Handle mouse button presses.
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Check rack -> stage
			var tile = letterRack.getHoveredTile()
			if tile:
				letterStage.addTile(tile)
			else:
				# Check stage -> rack
				var stageTile = letterStage.getHoveredTile()
				if stageTile:
					moveLettersToRackUntil(stageTile)
	if event is InputEventKey and event.pressed:
		# Handle keyboard keys.
		if event.keycode == KEY_BACKSPACE:
			if Input.is_key_pressed(KEY_SHIFT):
				moveAllLettersToRack()
			else:
				moveLetterToRack()
		elif event.keycode == KEY_DELETE:
			moveAllLettersToRack()
		elif event.keycode == KEY_ESCAPE:
			moveAllLettersToRack()
		elif event.keycode == KEY_ENTER:
			submitWord()
		else:
			# Handle a letter being pressed.
			var code = event.get_unicode()
			if code != 0:
				moveLetterToStageFromKey(char(code))
