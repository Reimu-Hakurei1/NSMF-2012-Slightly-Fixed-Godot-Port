extends SceneTree

var stage: int = 0
var wait: int = 0
var level_room: int = -1
var tries: int = 0
var tick0: int = 0


func _initialize() -> void:
	root.add_child(load("res://scenes/game.tscn").instantiate())


func _find(oid: int) -> Array:
	var out: Array = []
	for inst in R.instances:
		if inst.alive and int(inst.g_object_index) == oid:
			out.append(inst)
	return out


func _process(_d: float) -> bool:
	tries += 1
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
		var nodes := _find(828)
		if players.is_empty() or nodes.is_empty():
			print("MAPSHOT FAIL player=%d nodes=%d" % [players.size(), nodes.size()])
			quit(1)
			return true
		var node: GMInstance = null
		for n in nodes:
			if int(R.member_get(n, "g_goto_level")) > 0:
				node = n
				break
		if node == null:
			print("MAPSHOT FAIL no level node")
			quit(1)
			return true
		players[0].position = node.position
		R.member_set(players[0], "g_idzie", 0)
		G.mario_wszedl_do_etapu = 0
		level_room = int(R.member_get(node, "g_goto_level"))
		R.keyboard_key_press(null, 90)
		stage = 2
		wait = 0
		return false
	if stage == 2:
		wait += 1
		if wait == 3:
			R.keyboard_key_release(null, 90)
			print("MAPSHOT enter goto=%d" % level_room)
		if R.room != 273:
			print("MAPSHOT level room=%d %s" % [R.room, R.room_caption])
			stage = 3
			wait = 0
			tick0 = R.tick_count
		elif wait > 5000:
			print("MAPSHOT STUCK")
			quit(1)
			return true
		return false
	if stage == 3:
		wait += 1
		if wait == 20:
			R.keyboard_key_press(null, 39)
			R.keyboard_key_press(null, 88)
		if R.tick_count - tick0 == 120:
			var img: Image = root.get_texture().get_image()
			img.save_png("res://shot_maplevel.png")
			var ms := _find(306)
			var mp: Vector2 = ms[0].position if not ms.is_empty() else Vector2.ZERO
			print("MAPSHOT view=%.1f,%.1f w=%.0fx%.0f cam=%.1f,%.1f zoom=%.2f mario=%.1f,%.1f inst=%d" % [
				R.view_xview[0], R.view_yview[0], R.view_wview[0], R.view_hview[0],
				R.camera.position.x, R.camera.position.y, R.camera.zoom.x,
				mp.x, mp.y, R.instances.size()])
		if R.tick_count - tick0 == 700:
			var img2: Image = root.get_texture().get_image()
			img2.save_png("res://shot_maplevel2.png")
			var ms2 := _find(306)
			var mp2: Vector2 = ms2[0].position if not ms2.is_empty() else Vector2.ZERO
			print("MAPSHOT2 view=%.1f,%.1f cam=%.1f,%.1f mario=%.1f,%.1f inst=%d" % [
				R.view_xview[0], R.view_yview[0],
				R.camera.position.x, R.camera.position.y,
				mp2.x, mp2.y, R.instances.size()])
			quit()
			return true
		if R.tick_count - tick0 > 1500:
			print("MAPSHOT timeout room=%d" % R.room)
			quit(1)
			return true
		return false
	return false
