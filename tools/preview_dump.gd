extends SceneTree

## Loads every room, ticks it twice so Create/early Step code assigns sprites and
## positions, and dumps one preview snapshot per room. The importer uses these to
## make the Godot editor scenes show what the game actually draws at room entry.
##   godot --headless --path . --script res://tools/preview_dump.gd -- [out.json]

var frames: int = 0
var started: bool = false
var settle: int = 470
var order: Array = []
var idx: int = 0
var room_frames: int = 0
var cap: int = 4
var base_ids: Dictionary = {}
var captured: bool = false
var out: Dictionary = {}
var out_path: String = "C:/Users/Alex/gm8tools/godot_port/data/preview_snapshots.json"
var rt_dir: String = "C:/Users/Alex/gm8tools/godot_port/images/runtime_preview"
var rt_manifest: Array = []
var rt_seen: Dictionary = {}


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		out_path = args[0]
	root.add_child(load("res://scenes/game.tscn").instantiate())


func _process(_delta: float) -> bool:
	frames += 1
	if not started:
		if frames < settle:
			return false
		order = R.room_order
		started = true
		print("PREVIEW start %d rooms" % order.size())
		R.room_goto(null, int(order[0]))
		return false
	room_frames += 1
	var rid: int = int(order[idx])
	if room_frames == 1:
		base_ids.clear()
		for inst in R.instances:
			base_ids[inst.inst_id] = true
		captured = false
		# Normal rooms animate their entry view for the first ~40 steps; capture
		# once it is over the level content so editor framing lands on the level.
		# Fast system rooms must stay short or their loading code self-advances.
		cap = 40 if R.room_speed <= 60 else 4
	if room_frames == cap - 1 and not captured:
		captured = true
		_export_runtime_assets()
		out[str(rid)] = {"inst": _snapshot(rid), "bgs": _backgrounds(),
			"view": [R.view_xview[0], R.view_yview[0], R.view_wview[0], R.view_hview[0]]}
		R.draw_record.clear()
		R.draw_record_on = true
		# Static objects only run _draw once at spawn; force a redraw so their
		# custom draw calls land inside the recording window.
		for inst in R.instances:
			if inst.alive:
				inst.queue_redraw()
		print("PREVIEW room=%d inst=%d" % [rid, out[str(rid)]["inst"].size()])
	if room_frames >= cap:
		R.draw_record_on = false
		out[str(rid)]["draws"] = R.draw_record.duplicate()
		room_frames = 0
		idx += 1
		if idx >= order.size():
			var f := FileAccess.open(out_path, FileAccess.WRITE)
			f.store_string(JSON.stringify(out))
			f.close()
			var mf := FileAccess.open(rt_dir + "/manifest.json", FileAccess.WRITE)
			mf.store_string(JSON.stringify(rt_manifest))
			mf.close()
			print("PREVIEW done rooms=%d runtime_assets=%d" % [out.size(), rt_manifest.size()])
			quit(0)
			return true
		R.room_goto(null, int(order[idx]))
	return false


func _export_runtime_assets() -> void:
	# sprite_add/background_add create assets at runtime (ids >= 100000) that the
	# GM8 dump does not contain; save their pixels so editor previews can show them.
	DirAccess.make_dir_recursive_absolute(rt_dir)
	for idx in R.sprites:
		var i: int = int(idx)
		if i < 100000 or rt_seen.has("s%d" % i):
			continue
		var s: Dictionary = R.sprites[idx]
		if s["frames"].is_empty():
			continue
		var img: Image = s["frames"][0].get_image()
		if img == null:
			continue
		var rel := "s%d.png" % i
		img.save_png(rt_dir + "/" + rel)
		rt_seen["s%d" % i] = true
		rt_manifest.append({"kind": "sprites", "index": i, "name": str(s["name"]),
			"w": img.get_width(), "h": img.get_height(),
			"ox": s["origin"].x, "oy": s["origin"].y, "file": rel})
	for idx in R.backgrounds:
		var i: int = int(idx)
		if i < 100000 or rt_seen.has("b%d" % i):
			continue
		var b: Dictionary = R.backgrounds[idx]
		var tex: Texture2D = b.get("tex")
		if tex == null:
			continue
		var img: Image = tex.get_image()
		if img == null:
			continue
		var rel := "b%d.png" % i
		img.save_png(rt_dir + "/" + rel)
		rt_seen["b%d" % i] = true
		rt_manifest.append({"kind": "backgrounds", "index": i, "name": str(b["name"]),
			"w": img.get_width(), "h": img.get_height(), "file": rel})


func _backgrounds() -> Array:
	# Rooms assign their sky/ground background slots from code (script_backgrounds),
	# so the baked JSON slots are empty while the game shows a full backdrop.
	var entries: Array = []
	for i in 8:
		entries.append({
			"slot": i, "src": R.bg_index[i], "vis": R.bg_visible[i],
			"x": R.bg_x[i], "y": R.bg_y[i],
			"ht": R.bg_htiled[i], "vt": R.bg_vtiled[i], "fg": R.bg_foreground[i],
			"hs": R.bg_hspeed[i], "vs": R.bg_vspeed[i],
			"xs": R.bg_xscale[i], "ys": R.bg_yscale[i], "al": R.bg_alpha[i],
		})
	return entries


func _snapshot(rid: int) -> Array:
	var json_ids: Dictionary = {}
	for im in R.room_data.get("rooms", {}).get(str(rid), {}).get("instances", []):
		json_ids[int(im[3])] = true
	var entries: Array = []
	for inst in R.instances:
		if not inst.alive:
			continue
		var known: bool = json_ids.has(inst.inst_id)
		if not known and inst.g_persistent:
			continue
		entries.append({
			"id": inst.inst_id, "obj": int(inst.g_object_index),
			"x": inst.position.x, "y": inst.position.y,
			"sp": int(inst.g_sprite_index), "fr": int(inst.g_image_index),
			"vis": inst.visible, "an": float(inst.g_image_angle),
			"xs": float(inst.g_image_xscale), "ys": float(inst.g_image_yscale),
			"al": float(inst.g_image_alpha), "dp": float(inst.g_depth),
			"base": known,
		})
	return entries