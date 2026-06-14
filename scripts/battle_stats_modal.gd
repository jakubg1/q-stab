extends Node2D
class_name UIBattleStatsModal

@onready var window: UIBattleStats = $BattleStats
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

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

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when the show delay has ended.
func _on_timer_timeout() -> void:
	showDialog()
