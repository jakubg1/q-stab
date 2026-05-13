extends Node2D

@onready var background: NinePatchRect = $Background
@onready var bar: NinePatchRect = $MarginContainer/Control/Bar

# We love multiplying text labels just because Godot can't do pixel-perfect outlines -_-
@onready var text: Label = $Text
@onready var outline_1: Label = $Text/Outline1
@onready var outline_2: Label = $Text/Outline2
@onready var outline_3: Label = $Text/Outline3
@onready var outline_4: Label = $Text/Outline4

var value := 50
var maxValue := 50

# Updates the widget sizes.
func updateLayout() -> void:
	background.size.x = 17 + maxValue
	background.position.x = -17 - maxValue
	bar.size.x = 8 + value
	bar.position.x = 200 - value
	text.text = str(value)
	outline_1.text = str(value)
	outline_2.text = str(value)
	outline_3.text = str(value)
	outline_4.text = str(value)

# Sets the bar value.
func setValue(value: int) -> void:
	self.value = max(value, 0)
	updateLayout()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateLayout()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when a word is submitted.
func _on_letter_manager_word_submitted(score: int) -> void:
	setValue(value - score)
