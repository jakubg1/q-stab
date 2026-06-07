extends Node

@onready var player: Player = $Player
@onready var playerHealthBar: Node2D = $PlayerHealthBar
@onready var playerStatusEffectContainer: UIStatusEffectContainer = $PlayerStatusEffectContainer
@onready var enemyAnchor: Node2D = $EnemyAnchor
@onready var enemyHealthBar: Node2D = $EnemyHealthBar
@onready var enemyStatusEffectContainer: UIStatusEffectContainer = $EnemyStatusEffectContainer
@onready var enemyName: Node2D = $EnemyName
@onready var enemyRespawnTimer: Timer = $EnemyRespawnTimer
@onready var statusText: Label = $StatusText
@onready var letterManager: Node = $LetterManager
@onready var playerTurnSprite: UITurnSprite = $PlayerTurnSprite
@onready var enemyTurnSprite: UITurnSprite = $EnemyTurnSprite
@onready var victorySprite: Sprite2D = $VictorySprite
@onready var defeatSprite: Sprite2D = $DefeatSprite
@onready var battleStatsModal: UIBattleStatsModal = $BattleStatsModal

var WAVES := [
	#EnemyDatabase.placeholder,
	#EnemyDatabase.slime,
	EnemyDatabase.slime
]

var game: Game = null
const ENEMY := preload("res://scenes/enemy.tscn")
var enemy: Enemy = null
var turn := Enums.Turn.PLAYER
var wave := 1 ## Wave number, starting from 1 (1st wave).
var over := false

signal player_move_ended()
signal enemy_move_ended()
signal turn_ended()

## Sets the game when this scene starts.
## This is necessary so that we can move the game control out of the scene tree!
func setGame(game: Game) -> void:
	self.game = game

## Spawns a new enemy on the battlefield.
func spawnEnemy() -> void:
	enemy = ENEMY.instantiate()
	enemy.name = "Enemy"
	enemy.setData(WAVES[wave - 1])
	# Connect signals going out of the enemy.
	enemy.attacked.connect(player._on_enemy_attacked)
	enemy.died.connect(_on_enemy_died)
	enemy.health_changed.connect(enemyHealthBar._on_enemy_health_changed)
	enemy.status_effect_added.connect(_on_enemy_status_effect_added)
	enemy.status_effect_removed.connect(_on_enemy_status_effect_removed)
	enemy.status_effect_updated.connect(_on_enemy_status_effect_updated)
	enemy.turn_finished.connect(_on_enemy_turn_finished)
	# Connect signals going into the enemy.
	player.attacked.connect(enemy._on_player_attacked)
	player_move_ended.connect(enemy._on_battle_player_move_ended)
	enemy_move_ended.connect(enemy._on_battle_enemy_move_ended)
	turn_ended.connect(enemy._on_battle_turn_ended)
	# Initialize some relevant UI elements.
	enemyHealthBar.init(enemy.getMaxHealth())
	enemyName.setText(enemy.getName())
	enemyStatusEffectContainer.clear()
	# Add to the tree.
	enemyAnchor.add_child(enemy)
	# Update status text.
	statusText.text = "Wave {0} of {1}".format([wave, len(WAVES)])

## Ends the turn for the current player.
func endMove() -> void:
	# Do not start a new turn if any of the parties is dead.
	if player.dead or enemy.dead:
		return
	# End and switch the turn.
	match turn:
		Enums.Turn.PLAYER:
			player_move_ended.emit()
			letterManager.setInputAllowed(false)
			enemyTurnSprite.display()
			turn = Enums.Turn.ENEMY
		Enums.Turn.ENEMY:
			enemy_move_ended.emit()
			endTurn()
			letterManager.setInputAllowed(true)
			playerTurnSprite.display()
			turn = Enums.Turn.PLAYER

## Ends the turn after both the player and enemy have played. This ticks uhhh...
func endTurn() -> void:
	turn_ended.emit()

## Advances the wave when the enemy is killed.
## If this was the last wave, ends the battle with a victory.
func advanceWave() -> void:
	if wave < len(WAVES):
		wave += 1
		player.regenerateFull()
		player.removeStatusEffects()
		enemyRespawnTimer.start()
	else:
		end(true)

## Ends the battle and shows a victory or defeat screen. Player input is revoked.
func end(won: bool) -> void:
	over = true
	letterManager.setInputAllowed(false)
	if won:
		victorySprite.show()
		battleStatsModal.showDialog(2)
	else:
		defeatSprite.show()

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerHealthBar.init(player.getMaxHealth())
	spawnEnemy()

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
	advanceWave()

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

## Called when the enemy respawn timer has expired.
func _on_enemy_respawn_timer_timeout() -> void:
	enemy.queue_free()
	spawnEnemy()
	turn = Enums.Turn.PLAYER
	letterManager.setInputAllowed(true)
