extends Node
class_name Game

const SCENES = {
	"main_menu": preload("res://scenes/main_menu.tscn"),
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

## Starts the game.
func startGame() -> void:
	setScene("battle")

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setScene("main_menu")

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
