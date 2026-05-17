extends Node

@onready var player: Node2D = $Player
@onready var enemy: Node2D = $Enemy
@onready var letterManager: Node = $LetterManager
@onready var victorySprite: Sprite2D = $VictorySprite
@onready var defeatSprite: Sprite2D = $DefeatSprite

var turn := Enums.Turn.PLAYER
var over := false

## Ends the turn for the specified player.
func endMove() -> void:
	if over:
		return
	if turn == Enums.Turn.PLAYER:
		turn = Enums.Turn.ENEMY
		enemy.queueMove()
		letterManager.setInputAllowed(false)
	elif turn == Enums.Turn.ENEMY:
		turn = Enums.Turn.PLAYER
		endTurn()
		letterManager.setInputAllowed(true)

## Ends the turn after both the player and enemy have played. This ticks status effects, etc.
func endTurn() -> void:
	pass

## Ends the battle and shows a victory or defeat screen. Player input is revoked.
func end(won: bool) -> void:
	over = true
	letterManager.setInputAllowed(false)
	if won:
		victorySprite.show()
	else:
		defeatSprite.show()

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when the player has finished their turn.
func _on_player_turn_finished() -> void:
	endMove()

## Called when the enemy has finished their turn.
func _on_enemy_turn_finished() -> void:
	endMove()

## Called when the player dies.
func _on_player_died() -> void:
	end(false)

## Called when the enemy dies.
func _on_enemy_died() -> void:
	end(true)
