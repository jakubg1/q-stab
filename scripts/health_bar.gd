extends Node2D

@onready var background: NinePatchRect = $Background
@onready var bar: NinePatchRect = $MarginContainer/Control/Bar
@onready var barFlash: NinePatchRect = $MarginContainer/Control/BarFlash

# We love multiplying text labels just because Godot can't do pixel-perfect outlines -_-
@onready var text: Label = $Text
@onready var outline_1: Label = $Text/Outline1
@onready var outline_2: Label = $Text/Outline2
@onready var outline_3: Label = $Text/Outline3
@onready var outline_4: Label = $Text/Outline4
@onready var labels: Array[Label] = [text, outline_1, outline_2, outline_3, outline_4]

## `false` - the bar will grow from left to right, `true` - the bar will grow from right to left
@export var flipped = true

const SCALE := 2 ## How many pixels per one HP should be displayed on the bar.

var value := 50
var maxValue := 50
var animValue := 50.0 ## Value displayed by the red portion of the bar and by the counter.
var animFlashValue := 50.0 ## Value displayed by the white portion of the bar.
var damageTime := -1.0 ## Counts up from 0 when damage is taken.

## Updates the widget sizes.
func updateLayout() -> void:
	background.size.x = 26 + maxValue * SCALE
	bar.size.x = 8 + animValue * SCALE
	barFlash.size.x = 8 + animFlashValue * SCALE
	if flipped:
		background.position.x = -26 - maxValue * SCALE
		bar.position.x = 200 - animValue * SCALE
		barFlash.position.x = 200 - animFlashValue * SCALE
	for label in labels:
		label.text = str(int(animValue))
	# Flash the bar when animating.
	bar.visible = not ((damageTime >= 0.1 and damageTime < 0.25) or (damageTime >= 0.3 and damageTime < 0.45))

## Sets the bar value and starts the hurt animation.
func setValue(value: int) -> void:
	self.value = max(value, 0)
	# TODO: Do something with this. This shouldn't probably belong here. Or at least add some conditions?
	damageTime = 0

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateLayout()

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Handle the flash.
	if damageTime >= 0:
		damageTime += delta
		animValue = max(animValue - delta * 150, value)
		if damageTime >= 1:
			animFlashValue = max(animFlashValue - delta * 40, value)
			if animFlashValue == value:
				damageTime = -1
		updateLayout()

## Called when the player's health changes.
func _on_player_health_changed(health: int) -> void:
	setValue(health)

## Called when the enemy's health changes.
func _on_enemy_health_changed(health: int) -> void:
	setValue(health)

## Called when the player entity is initialized.
func _on_player_initialized(maxHealth: int) -> void:
	value = maxHealth
	maxValue = maxHealth
	animValue = float(maxHealth)
	animFlashValue = float(maxHealth)

## Called when the enemy entity is initialized.
func _on_enemy_initialized(maxHealth: int) -> void:
	value = maxHealth
	maxValue = maxHealth
	animValue = float(maxHealth)
	animFlashValue = float(maxHealth)
