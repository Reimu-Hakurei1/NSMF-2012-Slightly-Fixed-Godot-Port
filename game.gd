extends Node2D

## Main scene: boots the GameMaker runtime and drives fixed logic ticks at room_speed.

var acc: float = 0.0
var _savedir: String = ""


func _ready() -> void:
	Engine.max_fps = 60
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--savedir="):
			_savedir = a.substr(10).replace("\\", "/")
			DirAccess.make_dir_recursive_absolute(_savedir)
	R.boot(self)


func _process(delta: float) -> void:
	if not R.game_running:
		return
	# Headless validation can redirect saves away from the player's real data.
	if _savedir != "" and R.working_directory != _savedir:
		R.working_directory = _savedir
	if delta > 0.25:
		delta = 0.25
	var step_time: float = 1.0 / maxf(1.0, float(R.room_speed))
	# Normal rooms advance a single step per frame, like GM8 does when it cannot
	# keep up. Only the 1000 Hz system rooms need real catch-up, otherwise a slow
	# frame would replay several expensive steps and make the slowdown compound.
	var max_steps: int = 1 if R.room_speed <= 60 else maxi(2, int(ceil(float(R.room_speed) / 30.0)))
	acc += delta
	var n := 0
	var t0 := Time.get_ticks_usec()
	while acc >= step_time and n < max_steps:
		R.step()
		acc -= step_time
		n += 1
	R.perf_step_usec = Time.get_ticks_usec() - t0
	# One rendered draw covers one step; only high-speed rooms need the rest.
	if n > 1 and R.room_speed > 60:
		R.draw_state_passes(n - 1)
	if acc > step_time * 4.0:
		acc = 0.0


func _input(event: InputEvent) -> void:
	R.handle_input(event)
