extends Node2D
class_name UIStatusEffect

@onready var bar: Node2D = $Bar
@onready var icon: Sprite2D = $Icon

const ICON_RECTS = {
	Enums.StatusEffectType.VULNERABLE: Rect2(0, 0, 11, 11),
	Enums.StatusEffectType.WEAKNESS: Rect2(11, 0, 11, 11),
	Enums.StatusEffectType.POISON: Rect2(22, 0, 11, 11),
	Enums.StatusEffectType.BURNING: Rect2(33, 0, 11, 11),
}

const BAR_SEGMENT := preload("res://scenes/status_effect_bar_segment.tscn")
var segments = []
var width = 16

## Sets the effect icon matching the given effect.
func setEffect(effect: Enums.StatusEffectType) -> void:
	icon.texture.region = ICON_RECTS[effect]

## Sets the max value for this bar. This respawns all segments and resets the value to 0.
func setMaxValue(maxValue: int) -> void:
	# Nuke the contents.
	for segment in segments:
		segment.free()
	segments.clear()
	# Create new segments.
	for i in maxValue:
		var segment = BAR_SEGMENT.instantiate()
		segments.append(segment)
		bar.add_child(segment)
		segment.setIndex(i)
	# Update the width.
	width = 15 + maxValue * 11

## Sets the amount of filled segments.
func setValue(value: int) -> void:
	for i in range(len(segments)):
		segments[i].setFilled(value > i)

## Sets whether the bar should grow to the right.
func setRight(right: bool) -> void:
	bar.scale.x = -1 if right else 1

## Returns the total width of this status effect icon and bar in pixels.
func getWidth() -> int:
	return width

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
