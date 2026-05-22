extends Node

@onready var player: Node2D = $Player
@onready var playerHealthBar: Node2D = $PlayerHealthBar
@onready var playerStatusEffectContainer: UIStatusEffectContainer = $PlayerStatusEffectContainer
@onready var enemy: Node2D = $Enemy
@onready var enemyHealthBar: Node2D = $EnemyHealthBar
@onready var enemyStatusEffectContainer: UIStatusEffectContainer = $EnemyStatusEffectContainer
@onready var enemyName: Node2D = $EnemyName
@onready var letterManager: Node = $LetterManager
@onready var victorySprite: Sprite2D = $VictorySprite
@onready var defeatSprite: Sprite2D = $DefeatSprite

var turn := Enums.Turn.PLAYER
var over := false

signal player_move_ended()
signal enemy_move_ended()
signal turn_ended()

## Ends the turn for the specified player.
func endMove() -> void:
	if over:
		return
	if turn == Enums.Turn.PLAYER:
		turn = Enums.Turn.ENEMY
		player_move_ended.emit()
		letterManager.setInputAllowed(false)
	elif turn == Enums.Turn.ENEMY:
		turn = Enums.Turn.PLAYER
		enemy_move_ended.emit()
		endTurn()
		letterManager.setInputAllowed(true)

## Ends the turn after both the player and enemy have played. This ticks status effects, etc.
func endTurn() -> void:
	turn_ended.emit()

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
	playerHealthBar.init(player.getMaxHealth())
	enemyHealthBar.init(enemy.getMaxHealth())
	enemyName.setText(enemy.getName())

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

## Called when the player gains a status effect.
func _on_player_status_effect_added(effect: Enums.StatusEffectType, duration: int) -> void:
	playerStatusEffectContainer.addStatusEffect(effect, duration)

## Called when the player loses a status effect.
func _on_player_status_effect_removed(effect: Enums.StatusEffectType) -> void:
	playerStatusEffectContainer.removeStatusEffect(effect)

## Called when the player's status effect changes its duration.
func _on_player_status_effect_updated(effect: Enums.StatusEffectType, duration: int) -> void:
	playerStatusEffectContainer.updateStatusEffect(effect, duration)

## Called when the enemy gains a status effect.
func _on_enemy_status_effect_added(effect: Enums.StatusEffectType, duration: int) -> void:
	enemyStatusEffectContainer.addStatusEffect(effect, duration)

## Called when the enemy loses a status effect.
func _on_enemy_status_effect_removed(effect: Enums.StatusEffectType) -> void:
	enemyStatusEffectContainer.removeStatusEffect(effect)

## Called when the enemy's status effect changes its duration.
func _on_enemy_status_effect_updated(effect: Enums.StatusEffectType, duration: int) -> void:
	enemyStatusEffectContainer.updateStatusEffect(effect, duration)
