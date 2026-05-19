extends Node2D

@onready var label: Label = $Sprite2D/Label

## Sets text on this label.
func setText(text: String) -> void:
	label.text = text

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
