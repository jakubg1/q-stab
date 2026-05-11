extends Area2D

var hovered := false

# Returns `true` if this area is hovered.
func isHovered() -> bool:
	return hovered

# Called when mouse enters the area.
func _on_mouse_entered() -> void:
	hovered = true

# Called when mouse leaves the area.
func _on_mouse_exited() -> void:
	hovered = false
