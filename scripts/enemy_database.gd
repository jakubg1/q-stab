extends Node

const placeholder: Dictionary[String, Variant] = {
	"name": "Placeholder",
	"health": 35,
	"attacks": [
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
				{"type": "effect", "effect": Enums.StatusEffectType.POISON, "turns": 2}
			]
		},
		{
			"name": "Chain Test",
			"weight": 30,
			"effects": [
				{"type": "tileEffect", "effect": Enums.TileEffectType.CHAINED, "duration": 3, "amount": 2}
			]
		}
	]
}

const slime: Dictionary[String, Variant] = {
	"name": "Slime",
	"health": 25,
	"attacks": [
		{
			"name": "Jump",
			"weight": 2,
			"effects": [
				{"type": "damage", "amount": 10}
			]
		},
		{
			"name": "Poison Spit",
			"weight": 1,
			"effects": [
				{"type": "damage", "amount": 5},
				{"type": "effect", "effect": Enums.StatusEffectType.POISON, "turns": 2}
			]
		}
	]
}
