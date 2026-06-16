extends Node2D
class_name UIBattleStatsModal

@onready var window: UIBattleStats = $BattleStats
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

signal closed()

## Shows the battle stat dialog.
func showDialog(delay: float = 0) -> void:
	if delay == 0:
		animation.play("fade_in")
	else:
		timer.start(delay)

## Resets the animation state.
func reset() -> void:
	visible = false
	animation.stop()

## Sets the total time taken in the stats window.
func setTime(time: float) -> void:
	window.setTime(time)

## Sets the longest word to be displayed in the status window.
func setLongestWord(word: String) -> void:
	window.setLongestWord(word)

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called on an input event.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		# Handle mouse button presses.
		closed.emit()
	elif event is InputEventKey and event.pressed:
		# Handle keyboard input.
		closed.emit()

## Called when the show delay has ended.
func _on_timer_timeout() -> void:
	showDialog()
