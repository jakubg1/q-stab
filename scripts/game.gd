extends Node
class_name Game

@onready var transition: UITransition = $Transition

const SCENES = {
	"main_menu": preload("res://scenes/main_menu.tscn"),
	"stagemap": preload("res://scenes/stagemap.tscn"),
	"battle": preload("res://scenes/battle.tscn")
}

var currentScene = null

## Starts the specified screen.
func setScene(name: String) -> void:
	if currentScene:
		currentScene.queue_free()
	currentScene = SCENES[name].instantiate()
	currentScene.setGame(self)
	add_child(currentScene)

## Goes to the main menu.
func startMainMenu() -> void:
	transition.start(Callable(self, "setScene").bind("main_menu"))

## Goes to the stagemap.
func startStagemap() -> void:
	transition.start(Callable(self, "setScene").bind("stagemap"))

## Starts the game.
func startGame() -> void:
	transition.start(Callable(self, "setScene").bind("battle"))
	MusicManager.stop(0.5)

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setScene("main_menu")

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
