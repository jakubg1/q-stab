extends Entity
class_name Enemy

@onready var actionTimer: Timer = $ActionTimer

const ATTACKS = [
	{
		"name": "Basic Attack",
		"weight": 2,
		"effects": [
			{"type": "damage", "amount": 10}
		]
	},
	{
		"name": "Basic Effect",
		"weight": 1,
		"effects": [
			{"type": "damage", "amount": 5},
			{"type": "effect", "effect": Enums.StatusEffectType.POISON, "turns": 2}
		]
	}
]

## Performs one attack out of the specified attacks list.
func attack() -> void:
	if dead:
		return
	var weights: Array[int] = []
	for attack in ATTACKS:
		weights.append(attack.weight)
	var n = Utils.weightedRandom(weights)
	var attack = ATTACKS[n]
	attacked.emit(self, attack.effects)

## Queues a move by starting a timer until the enemy attacks.
func queueMove() -> void:
	if dead:
		return
	actionTimer.start()

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init("Placeholder", 80)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when a player performs an attack towards the enemy.
func _on_player_attacked(attacker: Entity, effects: Array) -> void:
	receiveAttack(attacker, effects)

## Called when the player finishes their move.
func _on_battle_player_move_ended() -> void:
	queueMove()

## Called when the enemy finishes their move.
func _on_battle_enemy_move_ended() -> void:
	tickStatusEffects()

## Called when the full battle turn ends.
func _on_battle_turn_ended() -> void:
	pass # Replace with function body.

## Called when the wait timer before attacking is up.
func _on_action_timer_timeout() -> void:
	if dead:
		return
	attack()
	turn_finished.emit()
