extends Node

# Maybe in the future?
#var rng := RandomNumberGenerator.new()

## Accepts a list of weights and returns an index which matches the weight picked.
func weightedRandom(weights: Array[int]) -> int:
	var total = 0
	for weight in weights:
		total += weight
	var rnd = randi_range(0, total - 1)
	var i = 0
	while rnd > weights[i]:
		rnd -= weights[i]
		i += 1
	return i

## Accepts a dict of [any, int] and returns the picked key based on their weight values.
func weightedRandomKeys(weights: Dictionary[Variant, int]) -> Variant:
	return weights.keys()[weightedRandom(weights.values())]

## Executed on start
func _ready():
	pass
