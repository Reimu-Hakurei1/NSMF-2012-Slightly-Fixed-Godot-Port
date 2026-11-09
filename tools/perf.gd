extends SceneTree

var stage: int = 0
var wait: int = 0
var frames: int = 0
var acc_delta: float = 0.0
var acc_step: int = 0
var samples: int = 0


func _initialize() -> void:
	root.add_child(load("res://scenes/game.tscn").instantiate())


func _find(oid: int) -> Array:
	var out: Array = []
	for inst in R.instances:
		if inst.alive and int(inst.g_object_index) == oid:
			out.append(inst)
	return out


func _process(delta: float) -> bool:
	frames += 1
	if stage == 0:
		if R.room == 324:
			R.room_goto(null, 273)
			stage = 1
			wait = 0
		return false
	if stage == 1:
		wait += 1
		if wait < 8:
			return false
		var players := _find(831)
		var node: GMInstance = null
		for n in _find(828):
			if int(R.member_get(n, "g_goto_level")) > 0:
				node = n
				break
		players[0].position = node.position
		R.member_set(players[0], "g_idzie", 0)
		G.mario_wszedl_do_etapu = 0
		R.keyboard_key_press(null, 90)
		stage = 2
		wait = 0
		acc_delta = 0.0
		acc_step = 0
		samples = 0
		return false
	if stage == 2:
		wait += 1
		if wait == 3:
			R.keyboard_key_release(null, 90)
		if R.room != 273:
			stage = 3
			wait = 0
			return false
		if wait > 5000:
			print("PERF STUCK")
			quit(1)
			return true
		return false
	if stage == 3:
		wait += 1
		if wait == 30:
			R.keyboard_key_press(null, 39)
			R.keyboard_key_press(null, 88)
		if wait > 60:
			acc_delta += delta
			acc_step += R.perf_step_usec
			samples += 1
			if samples == 120:
				var avg_delta: float = acc_delta / samples
				print("PERF frames=%d avg_frame=%.1fms step=%.2fms inst=%d draw=%d vis=%d" % [
					frames, avg_delta * 1000.0, acc_step / 1000.0 / samples,
					R.instances.size(), 0, 0])
				samples = 0
				acc_delta = 0.0
				acc_step = 0
			if wait > 900:
				quit()
				return true
		return false
	return false
