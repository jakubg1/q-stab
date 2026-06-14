extends Node

@onready var letterRack: Node2D = $LetterRack
@onready var letterStage: Node2D = $LetterStage

var inputAllowed := true

signal attack_prepared(attack: Array)
signal word_submitted(word: String)

## Sets whether the player can interact with the board.
func setInputAllowed(inputAllowed: bool) -> void:
	self.inputAllowed = inputAllowed

## Moves a letter in the rack to the stage. If the tile is `null`, plays a "not accepted" sound.
func moveLetterToStage(tile: LetterTile) -> void:
	if not tile:
		SoundManager.playSound("Reject")
		return
	if not tile.isSelectable():
		# letterChainedSound.play()
		return
	letterStage.addTile(tile)
	SoundManager.playSound("LetterStage")

## Moves a letter from the specified index in the rack to the stage.
func moveLetterToStageFromIndex(index: int) -> void:
	moveLetterToStage(letterRack.getTile(index))

## Moves a letter from the specified key being pressed from the rack to the stage.
## If `enhanced` is `true`, enhanced (gem) tiles are preferred.
## Otherwise, regular tiles are preferred.
## Setting `enhanced` to `null` will cause the pick to be indifferent.
func moveLetterToStageFromKey(letter: String, enhanced: bool) -> void:
	# Do not move a U after a Qu tile. QoL FTW!
	if letter == "u":
		var lastTile = letterStage.getLastTile()
		if lastTile and lastTile.getLetter() == "q":
			return
	# Look for the appropriate tile in the rack and move it if it exists.
	var tile = null
	match enhanced:
		true:
			tile = letterRack.getEnhancedTileFromLetter(letter)
		false:
			tile = letterRack.getRegularTileFromLetter(letter)
		_:
			tile = letterRack.getTileFromLetter(letter)
	moveLetterToStage(tile)

## Moves the hovered letter in the rack to the stage.
## Returns `false` if the letter is not found, `true` otherwise.
func moveHoveredLetterToStage() -> bool:
	var tile = letterRack.getHoveredTile()
	if tile:
		moveLetterToStage(tile)
	return tile != null

## Moves the last letter from the stage back to the rack and returns it.
## If no letters were in the stage, does nothing and returns `null`.
func moveLetterToRackInternal() -> Node:
	var tile = letterStage.removeTile()
	if tile:
		letterRack.returnTile(tile)
	return tile

## Moves the last letter from the stage back to the rack and returns it.
## If no letters were in the stage, does nothing and returns `null`.
func moveLetterToRack() -> Node:
	var tile = moveLetterToRackInternal()
	if tile:
		SoundManager.playSound("LetterUnstage")
	return tile

## Moves all letters from the stage back to the rack.
func moveAllLettersToRack() -> void:
	if letterStage.isEmpty():
		return
	while true:
		var lastTile = moveLetterToRackInternal()
		if not lastTile:
			break
	SoundManager.playSound("LetterUnstage")

## Moves all letters from the stage back to the rack until the specified tile (inclusive!).
func moveLettersToRackUntil(tile: Node) -> void:
	if letterStage.isEmpty():
		return
	while true:
		var lastTile = moveLetterToRackInternal()
		if not lastTile or lastTile == tile:
			break
	SoundManager.playSound("LetterUnstage")

## Returns the gem type the player gets when scoring the specified amount of points for a word.
func getGemType(score: int) -> Enums.GemType:
	if score >= 20:
		return Enums.GemType.PURPLE
	elif score >= 16:
		return Enums.GemType.RED
	elif score >= 12:
		return Enums.GemType.GREEN
	elif score >= 8:
		return Enums.GemType.YELLOW
	return Enums.GemType.NONE

## Attempts to submit the word in rack.
func submitWord() -> void:
	# Do not accept nothing.
	if letterStage.isEmpty():
		return
	# Get the word and check if it exists in the dictionary.
	var word = letterStage.getWord()
	if not WordDictionary.isWordValid(word):
		print(word + ": This is not a valid word!")
		SoundManager.playSound("WordInvalid")
		return
	# Calculate the word score.
	var base = letterStage.getWordScore()
	var score = int(ceil(base * letterStage.getWordMultiplier()))
	# Prepare attack information.
	var attack = [{"type":"damage","amount":score}]
	attack += letterStage.getWordEffects()
	# Destroy the letters and spawn new letters in the rack.
	letterStage.destroyTiles()
	letterRack.fill()
	# Check if this word is eligible for a gem spawn.
	var gemType = getGemType(base)
	if gemType != Enums.GemType.NONE:
		var gemCandidate = letterRack.getRandomNonGemTile()
		if gemCandidate:
			gemCandidate.setGemType(gemType)
	# Play a sound and make the attack!
	print(word + " for " + str(score) + (" (!!)" if WordDictionary.isWordValidBad(word) else ""))
	word_submitted.emit(word)
	attack_prepared.emit(attack)
	#SoundManager.playSound("WordSubmit")

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called on an input event.
func _input(event: InputEvent) -> void:
	if not inputAllowed:
		return
	if event is InputEventMouseButton and event.pressed:
		# Handle mouse button presses.
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Check rack -> stage
			var success = moveHoveredLetterToStage()
			if not success:
				# Check stage -> rack
				var stageTile = letterStage.getHoveredTile()
				if stageTile:
					moveLettersToRackUntil(stageTile)
	elif event is InputEventKey and event.pressed:
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
		else:
			# Handle a letter being pressed.
			var code = event.get_unicode()
			if code != 0:
				var letter = char(code).to_lower()
				var uppercase = code >= ord("A") and code <= ord("Z")
				moveLetterToStageFromKey(letter, uppercase)
	if event.is_action_pressed("battle_attack"):
		submitWord()
