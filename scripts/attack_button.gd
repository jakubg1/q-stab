extends TextureButton

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when this button is pressed.
func _on_pressed() -> void:
	var event = InputEventAction.new()
	event.action = "battle_attack"
	event.pressed = true
	Input.parse_input_event(event)

## Called whenever the staged word changes.
func _on_letter_stage_word_updated(valid: bool) -> void:
	disabled = not valid
