extends Control
class_name UIStagemap

var game: Game = null

## Sets the game when this scene starts.
## This is necessary so that we can move the play button signal out of the scene tree!
func setGame(game: Game) -> void:
	self.game = game

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.play("title")

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when Play is pressed
func _on_button_play_pressed() -> void:
	self.game.startGame()

## Called when Menu is pressed
func _on_button_menu_pressed() -> void:
	self.game.startMainMenu()

func _on_button_play_button_down() -> void:
	SoundManager.playSound("ButtonClick")

func _on_button_menu_button_down() -> void:
	SoundManager.playSound("ButtonClick")
