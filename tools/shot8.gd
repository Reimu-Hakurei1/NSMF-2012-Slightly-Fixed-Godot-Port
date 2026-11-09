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


func _shot(name: String) -> void:
	var img: Image = root.get_texture().get_image()
	img.save_png("res://" + name)
	var gs := _find(642)
	if not gs.is_empty():
		var g: GMInstance = gs[0]
		var f: Dictionary = R.sprite_info(int(G.sun_glow))
		var tex: Texture2D = f["frames"][0] if f["frames"].size() > 0 else null
		print("GLOW %s wafel=%s stream=%s tex=%s" % [name,
			str(R.member_get(g, "g_wafel")), str(R.member_get(g, "g_stream")),
			tex.resource_path if tex != null else "<none>"])


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
		if wait == 120:
			_shot("shot_glow_normal.png")
			for g in _find(642):
				g.visible = false
		if wait == 150:
			_shot("shot_glow_off.png")
			var gs := _find(642)
			if not gs.is_empty():
				var mat := CanvasItemMaterial.new()
				mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
				gs[0].material = mat
				gs[0].visible = true
				gs[0].queue_redraw()
		if wait == 180:
			_shot("shot_glow_add.png")
			quit()
			return true
		if wait > 400:
			quit(1)
			return true
		return false
	return false
