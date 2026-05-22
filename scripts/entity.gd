extends Node2D
class_name Entity

#@onready var attackSound: AudioStreamPlayer = $Sound/Attack
#@onready var effectInflictSound: AudioStreamPlayer = $Sound/EffectInflict
#@onready var effectTickSound: AudioStreamPlayer = $Sound/EffectTick

var displayName = ""
var health = 50
var maxHealth = 50
var block = 0
var dead = false
var statusEffects: Dictionary[Enums.StatusEffectType, int] = {}

signal initialized(maxHealth: int)
signal health_changed(health: int)
signal status_effect_added(effect: Enums.StatusEffectType, duration: int)
signal status_effect_removed(effect: Enums.StatusEffectType)
signal status_effect_updated(effect: Enums.StatusEffectType, duration: int)
signal died
signal attacked(attacker: Entity, effects: Array) ## Attacked as in "conducted an attack", not "has been attacked".
signal turn_finished

## Initializes the entity by setting its maximum health.
func init(name: String, maxHealth: int) -> void:
	self.displayName = name
	self.health = maxHealth
	self.maxHealth = maxHealth
	initialized.emit(maxHealth)

## Returns this Entity's name.
func getName() -> String:
	return displayName

## Returns this Entity's maximum health.
func getMaxHealth() -> int:
	return maxHealth

## Damages the entity the given amount of HP. Kills it when the health reaches 0.
func damage(amount: int, bypassBlock: bool = false) -> void:
	if dead:
		return
	var blocked = min(amount, block) if not bypassBlock else 0
	block -= blocked
	var notBlocked = amount - blocked
	health = max(health - notBlocked, 0)
	health_changed.emit(health)
	if health == 0:
		dead = true
		died.emit()

## Inflicts the specified status effect on this entity.
## If the entity already has the effect, it will be extended to be at least the specified duration.
func addStatusEffect(effect: Enums.StatusEffectType, duration: int) -> void:
	# Do not decrease the effect duration.
	var duplicate = effect in statusEffects
	if duplicate and statusEffects[effect] >= duration:
		return
	statusEffects[effect] = duration
	if duplicate:
		status_effect_updated.emit(effect, duration)
	else:
		status_effect_added.emit(effect, duration)
	print(name + ": Status effect inflicted!")

## Removes the specified status effect from this entity.
func removeStatusEffect(effect: Enums.StatusEffectType) -> void:
	statusEffects.erase(effect)
	status_effect_removed.emit(effect)

## Removes all status effects from this entity.
func removeStatusEffects() -> void:
	for effect in statusEffects:
		removeStatusEffect(effect)

## Returns whether this Entity has the specified status effect.
func hasStatusEffect(effect: Enums.StatusEffectType) -> bool:
	return effect in statusEffects

## Ticks all status effects by applying their effects and reducing their duration by one.
func tickStatusEffects() -> void:
	for effect in statusEffects:
		# Apply effects.
		match effect:
			Enums.StatusEffectType.POISON:
				damage(ceil(maxHealth * 0.05), true)
				#effectTickSound.play()
			Enums.StatusEffectType.BURNING:
				damage(ceil(maxHealth * 0.1), true)
		print(name + ": Status effect applied!")
		# Tick the length.
		statusEffects[effect] -= 1
		if statusEffects[effect] == 0:
			print(name + ": Status effect worn off!")
			removeStatusEffect(effect)
		else:
			status_effect_updated.emit(effect, statusEffects[effect])
	print(name + ": Status effects: " + str(statusEffects))

## Dispatches an attack by reducing HP and applying status effects.
func receiveAttack(attacker: Entity, effects: Array) -> void:
	print(attacker.getName() + " attacked " + name + " with: " + str(effects))
	for effect in effects:
		match effect.type:
			"damage":
				var amount = effect.amount
				if attacker.hasStatusEffect(Enums.StatusEffectType.WEAKNESS):
					amount = ceil(amount / 3.0)
				if hasStatusEffect(Enums.StatusEffectType.VULNERABLE):
					amount = ceil(amount * 1.5)
				damage(amount)
			"effect":
				addStatusEffect(effect.effect, effect.turns)

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
