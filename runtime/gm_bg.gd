class_name GMBgLayer extends Node2D

## Draws the room's background slots that are not marked foreground (front = false),
## or the foreground ones (front = true). Offsets are relative to the current view.

var front: bool = false


func _draw() -> void:
	R.draw_bg_layer(self, front)
