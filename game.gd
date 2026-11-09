extends Node2D

## Main scene: boots the GameMaker runtime and drives fixed logic ticks at room_speed.

var acc: float = 0.0


func _ready() -> void:
	R.boot(self)


func _process(delta: float) -> void:
	if not R.game_running:
		return
	if delta > 0.25:
		delta = 0.25
	var step_time: float = 1.0 / maxf(1.0, float(R.room_speed))
	acc += delta
	var n := 0
	var t0 := Time.get_ticks_usec()
	while acc >= step_time and n < 8:
		R.step()
		acc -= step_time
		n += 1
	R.perf_step_usec = Time.get_ticks_usec() - t0
	if n >= 8:
		acc = 0.0


func _input(event: InputEvent) -> void:
	R.handle_input(event)
