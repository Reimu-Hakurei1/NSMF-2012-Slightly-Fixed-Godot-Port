class_name GMParticleLayer extends Node2D

## Draws one GameMaker particle system (or the built-in effect pool when sys_id is -1).

var sys_id: int = -1


func _draw() -> void:
	if sys_id == -1:
		R.draw_effects(self)
	else:
		R.draw_particles(self, sys_id)
