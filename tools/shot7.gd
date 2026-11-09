extends SceneTree

var stage: int = 0
var wait: int = 0


func _initialize() -> void:
	root.add_child(load("res://scenes/game.tscn").instantiate())


func _find(oid: int) -> Array:
	var out: Array = []
	for inst in R.instances:
		if inst.alive and int(inst.g_object_index) == oid:
			out.append(inst)
	return out


func _process(_d: float) -> bool:
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
		return false
	if stage == 2:
		wait += 1
		if wait == 3:
			R.keyboard_key_release(null, 90)
		if R.room != 273:
			stage = 3
			wait = 0
		elif wait > 5000:
			quit(1)
			return true
		return false
	if stage == 3:
		wait += 1
		if wait == 60:
			for inst in R.instances.duplicate():
				if int(inst.g_object_index) != 642:
					R.instance_destroy(inst, inst.inst_id)
			var gs0 := _find(642)
			if not gs0.is_empty():
				R.member_set(gs0[0], "g_stream", 0)
		if wait == 120 or wait == 180:
			for g in _find(642):
				R.member_set(g, "g_wafel", 0.5)
				R.member_set(g, "g_stream", 0)
			var img: Image = root.get_texture().get_image()
			img.save_png("res://shot_glowonly_%d.png" % wait)
			var gs := _find(642)
			if not gs.is_empty():
				var g: GMInstance = gs[0]
				print("GLOWONLY wait=%d pos=%.0f,%.0f wafel=%s stream=%s ekran=%s" % [
					wait, g.position.x, g.position.y,
					str(R.member_get(g, "g_wafel")), str(R.member_get(g, "g_stream")),
					str(G.ekran_size_act)])
		if wait == 200:
			quit()
			return true
		if wait > 400:
			quit(1)
			return true
		return false
	return false
