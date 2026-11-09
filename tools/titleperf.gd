extends SceneTree

var frames: int = 0
var phase: int = 0
var samples: int = 0
var acc: float = 0.0
var acc_step: float = 0.0
var acc_n: int = 0


func _initialize() -> void:
	root.add_child(load("res://scenes/game.tscn").instantiate())


func _process(d: float) -> bool:
	frames += 1
	if R.room == 324 and phase == 0:
		phase = 1
		R.room_goto(null, 262)
		return false
	if R.room != 262:
		return false
	if phase == 1:
		samples += 1
		acc += d
		acc_step += R.perf_step_usec / 1000.0
		acc_n += 1
		if samples == 120:
			print("TITLE all vis avg_frame=%.1fms step=%.2fms inst=%d" % [
				acc / acc_n * 1000.0, acc_step / acc_n, R.instances.size()])
			if R.room_root != null:
				R.room_root.visible = false
			phase = 2
			samples = 0
			acc = 0.0
			acc_step = 0.0
			acc_n = 0
		return false
	if phase == 2:
		samples += 1
		acc += d
		acc_step += R.perf_step_usec / 1000.0
		acc_n += 1
		if samples == 120:
			print("TITLE hidden avg_frame=%.1fms step=%.2fms inst=%d" % [
				acc / acc_n * 1000.0, acc_step / acc_n, R.instances.size()])
			if R.room_root != null:
				R.room_root.visible = true
			phase = 3
			samples = 0
			acc = 0.0
			acc_step = 0.0
			acc_n = 0
		return false
	if phase == 3:
		samples += 1
		acc += d
		acc_step += R.perf_step_usec / 1000.0
		acc_n += 1
		if samples == 120:
			print("TITLE back avg_frame=%.1fms step=%.2fms inst=%d" % [
				acc / acc_n * 1000.0, acc_step / acc_n, R.instances.size()])
			quit()
			return true
	return false
