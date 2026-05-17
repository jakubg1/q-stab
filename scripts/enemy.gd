extends Entity

signal attacked(damage: int)

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
			{"type": "effect", "effect": "burning", "turns": 2}
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
	for effect in attack.effects:
		if effect.type == "damage":
			attacked.emit(effect.amount)
		elif effect.type == "effect":
			pass # TODO

## Queues a move by starting a timer until the enemy attacks.
func queueMove() -> void:
	if dead:
		return
	actionTimer.start()

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init(80)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when a word is submitted.
func _on_letter_manager_word_submitted(score: int) -> void:
	damage(score)

## Called when the wait timer before attacking is up.
func _on_action_timer_timeout() -> void:
	attack()
	turn_finished.emit()
