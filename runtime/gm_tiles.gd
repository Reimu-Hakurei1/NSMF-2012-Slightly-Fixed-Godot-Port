class_name GMTileLayer extends Node2D

## Draws every tile of one room depth layer. Tiles live in R.tiles keyed by tile id.

var layer_depth: float = 0.0


func _draw() -> void:
	R.draw_tiles_at(self, layer_depth)
