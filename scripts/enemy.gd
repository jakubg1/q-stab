extends Node2D

const ATTACKS = [
	{
		"name": "Basic Attack",
		"weight": 2,
		"effects": [
			{"type": "damage", "amount": 10}
		]
	},
	{
		"name": "Basic Effect",
		"weight": 1,
		"effects": [
			{"type": "damage", "amount": 5},
			{"type": "effect", "effect": "burning", "turns": 2}
		]
	}
]

var health = 50
var maxHealth = 50

signal health_changed(health: int)

## Damages the enemy the given amount of HP.
func damage(amount: int) -> void:
	health = max(health - amount, 0)
	health_changed.emit(health)
	if health == 0:
		print("Enemy died!")

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when a word is submitted.
func _on_letter_manager_word_submitted(score: int) -> void:
	damage(score)
