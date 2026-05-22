extends Node

## Status effect type used for entities.
enum StatusEffectType {
	NONE,
	POISON,
	BURNING,
	WEAKNESS,
	VULNERABLE
}

## Gem type used for tile enhancements.
enum GemType {
	NONE,
	YELLOW,
	GREEN,
	RED,
	PURPLE
}

## Whose turn it currently is.
enum Turn {
	PLAYER,
	ENEMY
}
