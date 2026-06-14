extends Control
class_name UIBattleStats

@onready var click_to_continue_label: Label = $ClickToContinueLabel
@onready var time_value: Label = $TimeValue
@onready var longest_word_value: Label = $LongestWordValue

## Sets the total time to be displayed in this modal.
func setTime(time: float) -> void:
	time_value.text = "%d:%02d" % [int(time / 60), int(time) % 60]

## Sets the new longest word to be displayed in this window.
func setLongestWord(word: String) -> void:
	longest_word_value.text = word.to_upper()

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(click_to_continue_label.label_settings, "font_color:a", 0.5, 1)
	tween.tween_property(click_to_continue_label.label_settings, "font_color:a", 1, 1)
	tween.set_loops()

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
