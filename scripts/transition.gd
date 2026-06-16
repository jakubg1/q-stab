extends Node2D
class_name UITransition

@onready var rect: ColorRect = $Rect

var t := -1.0 ## Elapsed transition time. Starts from 0 and counts up. -1 when no transition.
var onDark = null ## Callable or null. Called when the screen is fully obstructed by the curtain.
const MAX_T = 1.5 ## Total transition time, in seconds.
const IN_T = 0.4 ## Fade in time.
const OUT_T = 0.6 ## Fade out time.

## Starts the transition, optionally with a function to be called when the screen goes dark.
func start(onDark: Callable) -> void:
	if t != -1.0:
		return
	t = 0.0
	self.onDark = onDark

## Updates the transition appearance.
func update() -> void:
	var alpha = 0
	if t >= 0 && t < IN_T:
		alpha = t / IN_T # Fade in
	elif t >= IN_T && t < MAX_T - OUT_T:
		alpha = 1 # Faded in
	elif t >= MAX_T - OUT_T && t < MAX_T:
		alpha = 1 - (t - (MAX_T - OUT_T)) / OUT_T # Fading out
	rect.color.a = alpha

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if t >= 0:
		t += delta
		# Check whether to call the onDark function.
		if t >= IN_T && onDark:
			onDark.call()
			onDark = null
		# Check whether the transition has finished.
		if t >= MAX_T:
			t = -1.0
			onDark = null
		update()
