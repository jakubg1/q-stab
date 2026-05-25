extends Entity
class_name Player

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init("Player", 80)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when an enemy performs an attack towards the player.
func _on_enemy_attacked(attacker: Entity, attack: Array) -> void:
	receiveAttack(attacker, attack)

## Called when an enemy inflicts a status effect on the player.
func _on_enemy_status_effect_inflicted(effect: Enums.StatusEffectType, turns: int) -> void:
	addStatusEffect(effect, turns)

## Called when the player submits a valid word.
func _on_letter_manager_word_submitted(attack: Array) -> void:
	attacked.emit(self, attack)
	turn_finished.emit()

## Called when the player has finished their move.
func _on_battle_player_move_ended() -> void:
	tickStatusEffects()

## Called when the full battle turn ends.
func _on_battle_turn_ended() -> void:
	pass # Replace with function body.
