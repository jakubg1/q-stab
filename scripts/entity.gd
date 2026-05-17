extends Node2D
class_name Entity

var health = 50
var maxHealth = 50
var dead = false

signal initialized(maxHealth: int)
signal health_changed(health: int)
signal turn_finished
signal died

## Initializes the entity by setting its maximum health.
func init(maxHealth: int) -> void:
	self.health = maxHealth
	self.maxHealth = maxHealth
	initialized.emit(maxHealth)

## Damages the entity the given amount of HP.
func damage(amount: int) -> void:
	if dead:
		return
	health = max(health - amount, 0)
	health_changed.emit(health)
	if health == 0:
		dead = true
		died.emit()

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
