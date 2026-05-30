extends Entity
class_name Enemy

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var actionTimer: Timer = $ActionTimer

var attacks: Array[Dictionary] = []

## Loads enemy data from the enemy database entry. You must call this when creating an enemy.
func setData(enemyData: Dictionary[String, Variant]) -> void:
	init(enemyData.name, enemyData.health)
	attacks.assign(enemyData.attacks)

## Performs one attack out of the specified attacks list.
func attack() -> void:
	if dead:
		return
	sprite.play("Attack")
	var attack = Utils.weightedRandomObject(attacks)
	attacked.emit(self, attack.effects)

## Damages the entity the given amount of HP. Kills it when the health reaches 0.
func damage(amount: int, bypassBlock: bool = false) -> void:
	sprite.play("Hurt")
	super.damage(amount, bypassBlock)

## Kills this entity.
func kill() -> void:
	sprite.play("Dead")
	super.kill()

## Queues a move by starting a timer until the enemy attacks.
func queueMove() -> void:
	if dead:
		return
	actionTimer.start()

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

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

## Called when an animation on the enemy sprite has finished.
func _on_sprite_animation_finished() -> void:
	if sprite.animation != "Dead":
		sprite.play("Idle")
