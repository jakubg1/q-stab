extends Entity

const ATTACKS = [
	{
		"name": "Basic Attack",
		"weight": 2,
		"effects": [
			{"type": "damage", "amount": 6}
		]
	},
	{
		"name": "Basic Effect",
		"weight": 1,
		"effects": [
			{"type": "damage", "amount": 3},
			{"type": "effect", "effect": "burning", "turns": 2}
		]
	}
]

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init(20)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when a word is submitted.
func _on_letter_manager_word_submitted(score: int) -> void:
	damage(score)
