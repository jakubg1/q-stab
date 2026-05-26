extends Node2D

@onready var background: NinePatchRect = $Background
@onready var bar: NinePatchRect = $Background/Bar
@onready var barFlash: NinePatchRect = $Background/BarFlash
@onready var label: Label = $Background/Text

## `false` - the bar will grow from left to right, `true` - the bar will grow from right to left
@export var right = false

const SCALE := 2 ## How many pixels per one HP should be displayed on the bar.

var value := 50
var maxValue := 50
var animValue := 50.0 ## Value displayed by the red portion of the bar and by the counter.
var animFlashValue := 50.0 ## Value displayed by the white portion of the bar.
var damageTime := -1.0 ## Counts up from 0 when damage is taken.
var regenTime := -1.0 ## Counts up from 0 when regenerating health.

## Initializes this health bar by setting its maximum value.
func init(maxValue: int) -> void:
	value = maxValue
	self.maxValue = maxValue
	animValue = float(maxValue)
	animFlashValue = float(maxValue)
	updateLayout()

## Updates the widget sizes.
func updateLayout() -> void:
	# Adjust bar sizes.
	background.size.x = 5 + maxValue * SCALE
	bar.size.x = 4 + animValue * SCALE
	barFlash.size.x = 4 + animFlashValue * SCALE
	# Flip the bar if told to.
	background.scale.x = -1 if right else 1
	background.position.x = 8 if right else 7
	# Invert the text again so that it is always displayed correctly.
	label.scale.x = -1 if right else 1
	label.position.x = background.size.x if right else 1
	# Set the health text value.
	label.text = str(int(animValue))
	# Flash the bar when animating.
	bar.visible = not ((damageTime >= 0.1 and damageTime < 0.25) or (damageTime >= 0.3 and damageTime < 0.45))

## Sets the bar value and starts the hurt animation.
func setValue(value: int) -> void:
	if value < self.value:
		damageTime = 0
	elif value > self.value:
		regenTime = 0
	self.value = max(value, 0)

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateLayout()

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Handle the flash.
	if damageTime >= 0:
		damageTime += delta
		var multiplier = 1 + (animValue - value) / 2
		animValue = max(animValue - multiplier * delta * 20, value)
		if damageTime >= 1:
			animFlashValue = max(animFlashValue - delta * 40, value)
			if animFlashValue == value:
				damageTime = -1
		updateLayout()
	if regenTime >= 0:
		regenTime += delta
		animValue = min(animValue + delta * regenTime * 20, value)
		animFlashValue = animValue
		if animValue == value:
			regenTime = -1
		updateLayout()

## Called when the player's health changes.
func _on_player_health_changed(health: int) -> void:
	setValue(health)

## Called when the enemy's health changes.
func _on_enemy_health_changed(health: int) -> void:
	setValue(health)
