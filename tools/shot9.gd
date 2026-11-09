extends SceneTree

var stage: int = 0
var wait: int = 0
var tick0: int = 0


func _initialize() -> void:
	root.add_child(load("res://scenes/game.tscn").instantiate())


func _find(oid: int) -> Array:
	var out: Array = []
	for inst in R.instances:
		if inst.alive and int(inst.g_object_index) == oid:
			out.append(inst)
	return out


func _shot(name: String) -> void:
	var img: Image = root.get_texture().get_image()
	img.save_png("res://" + name)
	var gs := _find(642)
	if not gs.is_empty():
		print("GLOW %s wafel=%s stream=%s pos=%.0f,%.0f view=%.0f,%.0f" % [name,
			str(R.member_get(gs[0], "g_wafel")), str(R.member_get(gs[0], "g_stream")),
			gs[0].position.x, gs[0].position.y, R.view_xview[0], R.view_yview[0]])


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
		if R.room != 273:
			R.keyboard_key_release(null, 90)
			R.keyboard_key_press(null, 39)
			stage = 3
			tick0 = R.tick_count
		elif wait > 5000:
			print("GLOW STUCK room=%d" % R.room)
			quit(1)
			return true
		return false
	if stage == 3:
		if R.tick_count - tick0 == 700:
			print("GLOW cap1 room=%d" % R.room)
			_shot("shot_ring_on.png")
			for g in _find(642):
				g.visible = false
		if R.tick_count - tick0 == 760:
			_shot("shot_ring_off.png")
			quit()
			return true
		if R.tick_count - tick0 > 1200:
			print("GLOW timeout room=%d dt=%d" % [R.room, R.tick_count - tick0])
			quit(1)
			return true
		return false
	return false
