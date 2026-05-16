extends Node2D

@onready var background: NinePatchRect = $Background
@onready var bar: NinePatchRect = $MarginContainer/Control/Bar

# We love multiplying text labels just because Godot can't do pixel-perfect outlines -_-
@onready var text: Label = $Text
@onready var outline_1: Label = $Text/Outline1
@onready var outline_2: Label = $Text/Outline2
@onready var outline_3: Label = $Text/Outline3
@onready var outline_4: Label = $Text/Outline4
@onready var labels: Array[Label] = [text, outline_1, outline_2, outline_3, outline_4]

## `false` - the bar will grow from left to right, `true` - the bar will grow from right to left
@export var flipped = true

var value := 50
var maxValue := 50

## Updates the widget sizes.
func updateLayout() -> void:
	background.size.x = 26 + maxValue
	bar.size.x = 8 + value
	if flipped:
		background.position.x = -26 - maxValue
		bar.position.x = 200 - value
	for label in labels:
		label.text = str(value)

## Sets the bar value.
func setValue(value: int) -> void:
	self.value = max(value, 0)
	updateLayout()

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateLayout()

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when the enemy's health changes.
func _on_enemy_health_changed(health: int) -> void:
	setValue(health)
