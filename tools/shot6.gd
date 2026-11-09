extends SceneTree

var stage: int = 0
var wait: int = 0
var level_room: int = -1


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
		var nodes := _find(828)
		var node: GMInstance = null
		for n in nodes:
			if int(R.member_get(n, "g_goto_level")) > 0:
				node = n
				break
		if players.is_empty() or node == null:
			print("SHOT6 FAIL")
			quit(1)
			return true
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
		elif wait > 200:
			print("SHOT6 STUCK")
			quit(1)
			return true
		return false
	if stage == 3:
		wait += 1
		if wait == 700:
			var seen := {}
			for inst in R.instances:
				seen[int(inst.g_object_index)] = true
			print("SHOT6 objects=%s" % str(seen.keys()))
			var gi: int = int(G.sun_glow)
			var info: Dictionary = R.sprite_info(gi)
			print("SHOT6 sun_glow idx=%d name=%s origin=%s size=%s frames=%s" % [
				gi, info.get("name", ""), str(info.get("origin", Vector2.ZERO)),
				str(info.get("size", Vector2.ZERO)), str(R.sprites.get(gi, {}).get("paths", []))])
			var frames: Array = info.get("frames", [])
			if not frames.is_empty() and frames[0] != null:
				var tex: Texture2D = frames[0]
				tex.get_image().save_png("res://shot_sunglow_tex.png")
			for oid in [642]:
				for inst in _find(oid):
					R.instance_destroy(inst, inst.inst_id)
		if wait == 730:
			var img: Image = root.get_texture().get_image()
			img.save_png("res://shot_noglow.png")
			print("SHOT6 saved room=%d" % R.room)
			quit()
			return true
		if wait > 1200:
			quit(1)
			return true
		return false
	return false
