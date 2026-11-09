extends SceneTree

var frames: int = 0
var acc_delta: float = 0.0
var acc_step: int = 0
var samples: int = 0
var target: int = 273
var jumped: bool = false


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--room="):
			target = int(a.substr(7))
	root.add_child(load("res://scenes/game.tscn").instantiate())


func _process(delta: float) -> bool:
	frames += 1
	if R.room == 324 and not jumped:
		jumped = true
		R.room_goto(null, target)
	if R.room == target:
		acc_delta += delta
		acc_step += R.perf_step_usec
		samples += 1
		if samples == 120:
			print("PERF room=%d avg_frame=%.1fms step=%.2fms inst=%d" % [
				R.room, acc_delta / samples * 1000.0, acc_step / 1000.0 / samples,
				R.instances.size()])
			print("PERF phases begin=%.2f keys=%.2f logic=%.2f move=%.2f anim=%.2f end=%.2f vis=%.2f views=%.2f" % [
				R.perf_begin_usec / 1000.0, R.perf_keys_usec / 1000.0,
				R.perf_logic_usec / 1000.0, R.perf_motion_usec / 1000.0,
				R.perf_anim_usec / 1000.0, R.perf_end_usec / 1000.0,
				R.perf_vis_usec / 1000.0, R.perf_views_usec / 1000.0])
			samples = 0
			acc_delta = 0.0
			acc_step = 0
		if frames > 900:
			quit()
			return true
	if frames > 3000:
		print("PERF timeout room=%d" % R.room)
		quit(1)
		return true
	return false
