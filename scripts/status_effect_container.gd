extends Node2D
class_name UIStatusEffectContainer

const STATUS_EFFECT := preload("res://scenes/status_effect.tscn")
var statusEffects: Array[UIStatusEffect] = []
var statusEffectsByEffect: Dictionary[Enums.StatusEffectType, UIStatusEffect] = {}
## `false` - the bars will grow from left to right, `true` - the bars will grow from right to left
@export var right = false

## Sets whether the bars should grow to the right.
func setRight(right: bool) -> void:
	self.right = right

## Updates the bar positions.
func updateBarPositions() -> void:
	var x = 0
	for bar in statusEffects:
		bar.position.x = -x - 15 if right else x
		x += bar.getWidth() + 1

## Adds a new status effect bar, if that effect doesn't exist yet.
func addStatusEffect(effect: Enums.StatusEffectType, duration: int) -> void:
	# Do not allow two bars with the same effect.
	if effect in statusEffectsByEffect:
		return
	var bar: UIStatusEffect = STATUS_EFFECT.instantiate()
	statusEffects.append(bar)
	statusEffectsByEffect[effect] = bar
	add_child(bar)
	bar.setEffect(effect)
	bar.setMaxValue(duration)
	bar.setValue(duration)
	bar.setRight(right)
	updateBarPositions()

## Updates a status effect bar with the specified duration.
func updateStatusEffect(effect: Enums.StatusEffectType, duration: int) -> void:
	statusEffectsByEffect[effect].setValue(duration)

## Removes a status effect bar.
func removeStatusEffect(effect: Enums.StatusEffectType) -> void:
	var bar = statusEffectsByEffect[effect]
	statusEffects.erase(bar)
	statusEffectsByEffect.erase(effect)
	bar.queue_free()
	updateBarPositions()

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
