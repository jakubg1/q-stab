extends Entity

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init(80)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when an enemy performs an attack towards the player.
func _on_enemy_attacked(damage: int) -> void:
	damage(damage)

## Called when the player submits a valid word.
func _on_letter_manager_word_submitted(score: int) -> void:
	turn_finished.emit()
