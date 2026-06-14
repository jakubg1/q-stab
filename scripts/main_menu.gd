extends Control

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

## Called when Play is pressed.
func _on_button_play_pressed() -> void:
	game.startGame()

## Called when Settings is pressed.
func _on_button_settings_pressed() -> void:
	pass # TODO

## Called when Quit is pressed :(
func _on_button_quit_pressed() -> void:
	get_tree().quit()
