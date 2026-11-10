class_name R extends RefCounted

## GameMaker 8.1 compatibility runtime. Every generated script talks to this class through
## static functions whose first argument is the running instance (S). State is static so it
## survives room changes, exactly like GameMaker's global room state.

## "No instance" sentinel. GameMaker's noone is -4 and is falsy in GML, but in
## GDScript any non-zero number is truthy, so instance-returning functions use
## null here to keep `if collision_rectangle(...)` behaving like the original.
const NOONE: Variant = null

# ---------------------------------------------------------------- scene / registry
static var root: Node2D = null
static var room_root: Node2D = null
static var camera: Camera2D = null
static var bg_rect: ColorRect = null
static var bg_back: Node2D = null
static var bg_front: Node2D = null
static var assets: Dictionary = {}
static var registry: Dictionary = {}
static var room_data: Dictionary = {}
static var room_order: Array = []
static var script_pairs: Array = []
static var objects: Dictionary = {}
static var obj_family: Dictionary = {}
static var obj_scripts: Dictionary = {}
static var obj_event_sets: Dictionary = {}
static var obj_key_events_cache: Dictionary = {}
static var handler_cache: Dictionary = {}
static var empty_args: Array = []
static var rooms_by_name: Dictionary = {}

# ---------------------------------------------------------------- live state
static var instances: Array = []
static var by_id: Dictionary = {}
static var by_object: Dictionary = {}
static var sprites: Dictionary = {}
static var backgrounds: Dictionary = {}
static var runtime_paths: Dictionary = {}
static var next_spr: int = 100000
static var next_bg: int = 100000
static var next_inst: int = 200000
static var room: int = -1
static var room_first: int = 0
static var room_last: int = 0
static var room_width: float = 800.0
static var room_height: float = 600.0
static var room_speed: int = 60
static var room_caption: String = ""
static var room_persistent: bool = false
static var pending_room: Variant = null
static var game_running: bool = true
static var tick_count: int = 0
static var start_ms: int = 0
static var fps: int = 60
static var fps_real: float = 60.0
static var perf_step_usec: int = 0
static var perf_begin_usec: int = 0
static var perf_keys_usec: int = 0
static var perf_logic_usec: int = 0
static var perf_motion_usec: int = 0
static var perf_anim_usec: int = 0
static var perf_end_usec: int = 0
static var perf_vis_usec: int = 0
static var perf_views_usec: int = 0
static var debug_load: bool = false
static var debug_create_usec: Dictionary = {}
static var debug_create_count: Dictionary = {}
static var debug_spawn_usec: Dictionary = {}
static var debug_tex_usec: int = 0
static var debug_tex_count: int = 0
static var debug_script_misses: int = 0
static var debug_script_hits: int = 0
static var debug_script_hit_usec: int = 0
static var debug_mode: bool = false
static var health: float = 0.0
static var lives: float = 0.0
static var score: float = 0.0
static var loop_count: int = 0
static var loop_id: Array = []
static var event_type: int = 0
static var event_number: int = 0
static var error_occurred: bool = false
static var last_error_text: String = ""

# ---------------------------------------------------------------- views / backgrounds
static var view_enabled: bool = false
static var view_current: int = 0
static var view_xview: Array = [0.0, 0, 0, 0, 0, 0, 0, 0]
static var view_yview: Array = [0.0, 0, 0, 0, 0, 0, 0, 0]
static var view_wview: Array = [800.0, 640, 640, 640, 640, 640, 640, 640]
static var view_hview: Array = [600.0, 480, 480, 480, 480, 480, 480, 480]
static var view_xport: Array = [0, 0, 0, 0, 0, 0, 0, 0]
static var view_yport: Array = [0, 0, 0, 0, 0, 0, 0, 0]
static var view_wport: Array = [800, 640, 640, 640, 640, 640, 640, 640]
static var view_hport: Array = [600, 480, 480, 480, 480, 480, 480, 480]
static var view_angle: Array = [0.0, 0, 0, 0, 0, 0, 0, 0]
static var view_hborder: Array = [32, 32, 32, 32, 32, 32, 32, 32]
static var view_vborder: Array = [32, 32, 32, 32, 32, 32, 32, 32]
static var view_hspeed: Array = [-1, -1, -1, -1, -1, -1, -1, -1]
static var view_vspeed: Array = [-1, -1, -1, -1, -1, -1, -1, -1]
static var view_object: Array = [-1, -1, -1, -1, -1, -1, -1, -1]
static var view_visible: Array = [true, false, false, false, false, false, false, false]
static var view_surface_id: Array = [-1, -1, -1, -1, -1, -1, -1, -1]
static var view_overrides: Dictionary = {}
static var bg_index: Array = [-1, -1, -1, -1, -1, -1, -1, -1]
static var bg_x: Array = [0.0, 0, 0, 0, 0, 0, 0, 0]
static var bg_y: Array = [0.0, 0, 0, 0, 0, 0, 0, 0]
static var bg_visible: Array = [false, false, false, false, false, false, false, false]
static var bg_foreground: Array = [false, false, false, false, false, false, false, false]
static var bg_alpha: Array = [1.0, 1, 1, 1, 1, 1, 1, 1]
static var bg_hspeed: Array = [0.0, 0, 0, 0, 0, 0, 0, 0]
static var bg_vspeed: Array = [0.0, 0, 0, 0, 0, 0, 0, 0]
static var bg_htiled: Array = [true, true, true, true, true, true, true, true]
static var bg_vtiled: Array = [true, true, true, true, true, true, true, true]
static var bg_xscale: Array = [1.0, 1, 1, 1, 1, 1, 1, 1]
static var bg_yscale: Array = [1.0, 1, 1, 1, 1, 1, 1, 1]
static var bg_width: Array = [0, 0, 0, 0, 0, 0, 0, 0]
static var bg_height: Array = [0, 0, 0, 0, 0, 0, 0, 0]
static var bg_hoffset: Array = [0.0, 0, 0, 0, 0, 0, 0, 0]
static var bg_voffset: Array = [0.0, 0, 0, 0, 0, 0, 0, 0]

# ---------------------------------------------------------------- input
static var keyboard_key: int = 0
static var keyboard_lastkey: int = 0
static var keyboard_string: String = ""
static var mouse_button: int = 0
static var mouse_lastbutton: int = 0
static var mouse_wheel: int = 0
static var mouse_trigger: int = 0
static var keys_down: Dictionary = {}
static var keys_pressed: Dictionary = {}
static var keys_released: Dictionary = {}
static var joy_buttons: Dictionary = {}

# ---------------------------------------------------------------- draw state
static var draw_ci: CanvasItem = null
static var draw_color: Color = Color.WHITE
static var draw_alpha: float = 1.0
static var draw_halign: int = 0
static var draw_valign: int = 0
static var draw_font: Variant = -1
static var draw_blend: int = 0
# Additive draws go through a child CanvasItem with an ADD material; the draw event
# buffers them here because Godot 4 has no per-draw blend mode on one canvas item.
static var draw_offset_override: Variant = null
static var _additive_material: CanvasItemMaterial = null

static var sprite_fonts: Dictionary = {}
static var fallback_font: Font = null

# ---------------------------------------------------------------- audio / misc
static var ext_funcs: Dictionary = {}
static var next_ext: int = 1
static var sfx_bank: Dictionary = {}
static var sfx_players: Array = []
static var music_player: AudioStreamPlayer = null
static var music_path: String = ""
static var sfx_master: float = 1.0
static var music_volume: float = 1.0
static var ds_maps: Dictionary = {}
static var next_ds: int = 1
static var bin_files: Dictionary = {}
static var next_bin: int = 1
static var ini_data: Dictionary = {}
static var ini_path: String = ""
static var particles: Dictionary = {}
static var part_types: Dictionary = {}
static var part_systems: Dictionary = {}
static var part_emitters: Dictionary = {}
static var next_part: int = 1
static var live_particles: Array = []
static var particle_node: Node2D = null
static var tiles: Dictionary = {}
static var next_tile: int = 1
static var surfaces: Dictionary = {}
static var paths: Dictionary = {}
static var app_width: int = 800
static var app_height: int = 600
static var game_id: int = 0
static var game_display_name: String = "NSMF"
static var game_project_name: String = "NSMF"
static var game_save_id: String = "nsmf"
static var working_directory: String = ""
static var temp_directory: String = ""
static var program_directory: String = ""
static var application_surface: int = -1
static var os_type: int = 0
static var os_device: String = ""
static var os_browser: String = ""
static var browser_width: int = 800
static var browser_height: int = 600
static var current_year: int = 2026
static var current_month: int = 1
static var current_day: int = 1
static var current_weekday: int = 0
static var current_hour: int = 0
static var current_minute: int = 0
static var current_second: int = 0
static var SCRIPT: Array = []
static var warnings: Dictionary = {}


static func warn(what: String) -> void:
	warnings[what] = int(warnings.get(what, 0)) + 1


static func _json(path: String) -> Dictionary:
	var txt := FileAccess.get_file_as_string(path)
	if txt.is_empty():
		return {}
	var v: Variant = JSON.parse_string(txt)
	return v if v is Dictionary else {}


# ---------------------------------------------------------------- boot
static func boot(scene_root: Node2D) -> void:
	root = scene_root
	start_ms = Time.get_ticks_msec()
	var _bt := Time.get_ticks_msec()
	assets = _json("res://data/assets.json")
	registry = _json("res://gen/registry.json")
	room_data = _json("res://gen/rooms.json")
	room_order = room_data.get("order", [])
	var _bt2 := Time.get_ticks_msec()
	print("BOOT json=%dms assets=%d rooms=%d" % [_bt2 - _bt, assets.size(), room_data.get("rooms", {}).size()])
	_bt2 = Time.get_ticks_msec()
	script_pairs = registry.get("scripts", [])
	SCRIPT = []
	for pair in script_pairs:
		SCRIPT.append(Callable() if pair == null else pair)
	fallback_font = ThemeDB.fallback_font
	for o in registry.get("objects", []):
		objects[int(o["i"])] = o
	for r in room_data.get("rooms", {}).values():
		rooms_by_name[r["name"]] = r
	print("BOOT scripts=%dms pairs=%d" % [Time.get_ticks_msec() - _bt2, SCRIPT.size()])
	_bt2 = Time.get_ticks_msec()
	_build_families()
	_init_sprites()
	_init_audio()
	print("BOOT init=%dms" % (Time.get_ticks_msec() - _bt2))
	_bt2 = Time.get_ticks_msec()
	working_directory = OS.get_user_data_dir()
	program_directory = OS.get_executable_path().get_base_dir()
	temp_directory = OS.get_temp_dir()
	room_first = int(room_order[0]) if room_order.size() > 0 else 0
	room_last = int(room_order[-1]) if room_order.size() > 0 else 0
	camera = Camera2D.new()
	root.add_child(camera)
	camera.enabled = true
	particle_node = GMParticleLayer.new()
	particle_node.sys_id = -1
	particle_node.z_index = 4090
	root.add_child(particle_node)
	bg_rect = ColorRect.new()
	bg_rect.z_index = -4096
	bg_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(bg_rect)
	bg_back = GMBgLayer.new()
	bg_back.front = false
	bg_back.z_index = -4095
	root.add_child(bg_back)
	bg_front = GMBgLayer.new()
	bg_front.front = true
	bg_front.z_index = 4095
	root.add_child(bg_front)
	if room_order.size() > 0:
		_load_room(int(room_order[0]))
	print("BOOT first_room=%dms total=%dms" % [Time.get_ticks_msec() - _bt2, Time.get_ticks_msec() - _bt])


static func _build_families() -> void:
	var kids: Dictionary = {}
	for i in objects:
		var p: int = objects[i]["parent"]
		if p >= 0:
			if not kids.has(p):
				kids[p] = []
			kids[p].append(i)
	for i in objects:
		var fam: Array = []
		var stack: Array = [i]
		while stack.size() > 0:
			var c: int = stack.pop_back()
			fam.append(c)
			for k in kids.get(c, []):
				stack.append(k)
		obj_family[i] = fam


static func _init_sprites() -> void:
	for key in assets.get("sprites", {}):
		var s: Dictionary = assets["sprites"][key]
		var bb: Array = s.get("bbox", [0, 0, 0, 0])
		var org: Array = s.get("origin", [0, 0])
		# GM stores the bbox corners unordered; an inverted pair must not produce a
		# negative Rect2 size (Godot errors on every collision check otherwise).
		var x0: int = mini(int(bb[0]), int(bb[1]))
		var x1: int = maxi(int(bb[0]), int(bb[1]))
		var y0: int = mini(int(bb[2]), int(bb[3]))
		var y1: int = maxi(int(bb[2]), int(bb[3]))
		sprites[int(key)] = {
			"paths": s.get("frames", []), "frames": [], "loaded": false,
			"origin": Vector2(org[0], org[1]), "size": Vector2.ZERO,
			"bbox": Rect2(x0 - org[0], y0 - org[1], x1 - x0 + 1, y1 - y0 + 1),
			"bbox_img": Vector4i(x0, y0, x1, y1),
			"name": s.get("name", ""),
			# GameMaker sprite collision mode: 0 = precise pixel mask, 1 = rectangle.
			"shape": int(s.get("shape", 1)),
			"alpha_tolerance": int(s.get("alpha_tolerance", 0)),
			"per_frame": int(s.get("per_frame_colliders", 0)) != 0,
			"masks": {},
		}
	for key in assets.get("backgrounds", {}):
		var b: Dictionary = assets["backgrounds"][key]
		backgrounds[int(key)] = {"paths": b.get("frames", []), "tex": null,
			"loaded": false, "name": b.get("name", "")}
	runtime_paths = assets.get("runtime_paths", {})


static func _init_audio() -> void:
	music_player = AudioStreamPlayer.new()
	root.add_child(music_player)
	for i in range(24):
		var p := AudioStreamPlayer.new()
		root.add_child(p)
		sfx_players.append(p)


# ---------------------------------------------------------------- sprites
static func sprite_info(idx: int) -> Dictionary:
	if not sprites.has(idx):
		return {"frames": [], "origin": Vector2.ZERO, "size": Vector2.ZERO,
			"bbox": Rect2(), "name": ""}
	var s: Dictionary = sprites[idx]
	if not s["loaded"]:
		var _st := Time.get_ticks_usec()
		s["loaded"] = true
		var fr: Array = []
		for p in s["paths"]:
			fr.append(_load_texture(p))
		s["frames"] = fr
		if fr.size() > 0 and fr[0] != null:
			s["size"] = fr[0].get_size()
		if debug_load and Time.get_ticks_usec() - _st > 20000:
			print("LOAD sprite=%d name=%s frames=%d ms=%.1f" % [
				idx, s["name"], fr.size(), (Time.get_ticks_usec() - _st) / 1000.0])
	return s


static func _load_texture(path: String) -> Texture2D:
	var tex := _load_texture_impl(path)
	if debug_load:
		debug_tex_count += 1
	return tex


static func _load_texture_impl(path: String) -> Texture2D:
	if path == null or str(path).is_empty():
		return null
	var p := _fix_case(str(path))
	var gp := _globalize(p)
	if not FileAccess.file_exists(gp) and p.get_extension().is_empty():
		for ext in [".png", ".jpg", ".jpeg", ".gif", ".bmp"]:
			var candidate := _fix_case(p + ext)
			if FileAccess.file_exists(_globalize(candidate)):
				p = candidate
				gp = _globalize(candidate)
				break
	if not FileAccess.file_exists(gp):
		return null
	var res: Variant = load(p)
	if res is Texture2D:
		return res
	var img := Image.new()
	var err := img.load(gp)
	if err == OK:
		return ImageTexture.create_from_image(img)
	warn("texture:" + p)
	return null


static func _globalize(path: String) -> String:
	var p := path.replace("\\", "/")
	if runtime_paths.has(p):
		p = runtime_paths[p]
	if p.begins_with("res://"):
		return ProjectSettings.globalize_path(p)
	if p.begins_with("./"):
		p = p.substr(2)
	if p.begins_with("data/"):
		return ProjectSettings.globalize_path("res://" + p)
	return p


static func sprite_add(S, fname: String, imgnumb = 1, removeback = 0, smooth = 0,
		xorig = 0, yorig = 0) -> Variant:
	var tex := _load_texture(_resolve_file(fname))
	var idx := next_spr
	next_spr += 1
	var frames: Array = []
	if tex != null:
		frames.append(tex)
	sprites[idx] = {"paths": [], "frames": frames, "loaded": true,
		"origin": Vector2(xorig, yorig), "size": tex.get_size() if tex else Vector2.ZERO,
		"bbox": Rect2(-xorig, -yorig, tex.get_size().x if tex else 0,
			tex.get_size().y if tex else 0), "name": fname,
		"bbox_img": Vector4i(0, 0, int(tex.get_size().x) - 1 if tex else 0,
			int(tex.get_size().y) - 1 if tex else 0),
		"shape": 0, "alpha_tolerance": 0, "per_frame": false, "masks": {}}
	return idx


static func sprite_replace(S, idx: int, fname: String, imgnumb = 1, removeback = 0,
		smooth = 0, xorig = 0, yorig = 0) -> Variant:
	var tex := _load_texture(_resolve_file(fname))
	if not sprites.has(idx):
		return 0
	if tex == null:
		return 0
	var s: Dictionary = sprites[idx]
	s["frames"] = [tex] if tex != null else []
	s["loaded"] = true
	s["origin"] = Vector2(xorig, yorig)
	s["size"] = tex.get_size() if tex else Vector2.ZERO
	s["bbox"] = Rect2(-xorig, -yorig, s["size"].x, s["size"].y)
	s["bbox_img"] = Vector4i(0, 0, int(s["size"].x) - 1, int(s["size"].y) - 1)
	s["masks"] = {}
	for inst in instances:
		if inst.alive and int(inst.g_sprite_index) == idx:
			inst.set_sprite(idx)
	return idx


static func sprite_set_offset(S, idx: int, xoff: float, yoff: float) -> Variant:
	if sprites.has(idx):
		var s: Dictionary = sprites[idx]
		s["origin"] = Vector2(xoff, yoff)
		var sz: Vector2 = s["size"]
		s["bbox"] = Rect2(-xoff, -yoff, sz.x, sz.y)
	return 0


static func sprite_exists(S, idx: int) -> Variant:
	return sprites.has(idx) and sprites[idx]["frames"].size() > 0


static func sprite_get_width(S, idx: int) -> Variant:
	return sprite_info(idx)["size"].x


static func sprite_get_height(S, idx: int) -> Variant:
	return sprite_info(idx)["size"].y


static var _dir_cache: Dictionary = {}


static func _fix_case(path: String) -> String:
	# GM asset names are case-insensitive; Godot's import remap lookup is not.
	if not path.begins_with("res://"):
		return path
	var parts := path.substr(6).split("/", false)
	var cur := "res://"
	for part in parts:
		if not _dir_cache.has(cur):
			var names: Dictionary = {}
			var da := DirAccess.open(cur)
			if da != null:
				for n in da.get_files():
					names[n.to_lower()] = n
				for n in da.get_directories():
					names[n.to_lower()] = n
			_dir_cache[cur] = names
		var known: Dictionary = _dir_cache[cur]
		var lower := part.to_lower()
		cur = cur.path_join(known.get(lower, part))
	return cur


static func _resolve_file(fname: String) -> String:
	var p := fname.replace("\\", "/")
	if runtime_paths.has(p):
		return _fix_case(runtime_paths[p])
	if p.begins_with("./"):
		p = p.substr(2)
	if p.begins_with("data/") or p.begins_with("gfx/"):
		return _fix_case("res://" + p)
	return _fix_case(p)


# ---------------------------------------------------------------- objects / events
static func object_script(idx: int) -> GDScript:
	if obj_scripts.has(idx):
		if debug_load:
			var _h0 := Time.get_ticks_usec()
			var _hit: GDScript = obj_scripts[idx]
			debug_script_hit_usec += Time.get_ticks_usec() - _h0
			debug_script_hits += 1
			return _hit
		return obj_scripts[idx]
	debug_script_misses += 1
	var meta: Dictionary = objects.get(idx, {})
	var path: String = meta.get("script", "")
	var scr: GDScript = load(path) if path != "" else null
	obj_scripts[int(idx)] = scr
	return scr


static func object_events(idx: int) -> Dictionary:
	if obj_event_sets.has(idx):
		return obj_event_sets[idx]
	var set: Dictionary = {}
	for e in objects.get(idx, {}).get("events", []):
		set[int(e[0]) * 1000 + int(e[1])] = true
	obj_event_sets[idx] = set
	return set


static func handler(oi: int, eid: int) -> Variant:
	# Callables are resolved once per object/event pair; the dispatcher runs this
	# thousands of times per step, so no string formatting or parent walks after.
	var key: int = oi * 100000 + eid
	if handler_cache.has(key):
		return handler_cache[key]
	var cur: int = oi
	var result: Variant = null
	while cur >= 0:
		var scr := object_script(cur)
		if scr != null and object_events(cur).has(eid):
			result = Callable(scr, "ev_%d_%d" % [eid / 1000, eid % 1000])
			break
		cur = int(objects.get(cur, {}).get("parent", -1))
	handler_cache[key] = result
	return result


static func object_key_events(idx: int) -> Array:
	if obj_key_events_cache.has(idx):
		return obj_key_events_cache[idx]
	var out: Array = []
	var seen: Dictionary = {}
	var cur: int = idx
	while cur >= 0:
		for eid in object_events(cur):
			if seen.has(eid):
				continue
			seen[eid] = true
			var main: int = int(eid) / 1000
			if main == 5 or main == 9 or main == 10:
				out.append(int(eid))
		cur = int(objects.get(cur, {}).get("parent", -1))
	obj_key_events_cache[idx] = out
	return out


static func run_event(inst: GMInstance, main: int, sub: int) -> void:
	if inst == null or not inst.alive:
		return
	var c: Variant = handler(int(inst.g_object_index), main * 1000 + sub)
	if c != null:
		event_type = main
		event_number = sub
		c.call(inst, empty_args)


static func run_room_code(which: Dictionary, key: String, S) -> void:
	var e: Variant = which.get(key, null)
	if e == null:
		return
	var part: int = int(e[0])
	if part >= 0:
		var scr: GDScript = REG.room_part(part)
		if scr != null:
			scr.call(str(e[1]), S, [])


# ---------------------------------------------------------------- instances
static func _register(inst: GMInstance) -> void:
	fam_cache.clear()
	instances.append(inst)
	by_id[inst.inst_id] = inst
	var oi: int = int(inst.g_object_index)
	if not by_object.has(oi):
		by_object[oi] = []
	by_object[oi].append(inst)
	_mark_obj_dirty(oi)


static func instance_create(S, x: float, y: float, obj: int) -> Variant:
	var id := next_inst
	next_inst += 1
	return _spawn_at(x, y, obj, id)


static func _spawn_at(x: float, y: float, obj: int, id: int) -> Variant:
	if not objects.has(obj):
		return NOONE
	var _s0 := Time.get_ticks_usec()
	var inst := GMInstance.new()
	inst.position = Vector2(x, y)
	var _s1 := Time.get_ticks_usec()
	inst.init_instance(objects[obj], id)
	var _s2 := Time.get_ticks_usec()
	room_root.add_child(inst)
	var _s3 := Time.get_ticks_usec()
	_register(inst)
	_assign_depth(inst)
	var _s4 := Time.get_ticks_usec()
	if debug_load:
		var t0 := Time.get_ticks_usec()
		run_event(inst, 0, 0)
		var dt := Time.get_ticks_usec() - t0
		var k: int = int(inst.g_object_index)
		debug_create_usec[k] = int(debug_create_usec.get(k, 0)) + dt
		debug_create_count[k] = int(debug_create_count.get(k, 0)) + 1
		var _s5 := Time.get_ticks_usec()
		inst.created = true
		inst.sync_visuals()
		var _s6 := Time.get_ticks_usec()
		for pair in [["new", _s0, _s1], ["init", _s1, _s2], ["add", _s2, _s3],
				["reg", _s3, _s4], ["create", _s4, _s5], ["vis", _s5, _s6]]:
			debug_spawn_usec[pair[0]] = int(debug_spawn_usec.get(pair[0], 0)) + int(pair[2]) - int(pair[1])
	else:
		run_event(inst, 0, 0)
		inst.created = true
		inst.sync_visuals()
	return inst


static func instance_destroy(S, id: Variant = null) -> Variant:
	var inst: GMInstance = S if id == null else _as_inst(id)
	if inst == null or not inst.alive:
		return 0
	fam_cache.clear()
	inst.alive = false
	instances.erase(inst)
	by_id.erase(inst.inst_id)
	var oi: int = int(inst.g_object_index)
	if by_object.has(oi):
		by_object[oi].erase(inst)
	_mark_obj_dirty(oi)
	run_event(inst, 1, 0)
	inst.queue_free()
	return 0


static func _is_inst(v: Variant) -> bool:
	# `v is GMInstance` raises on a freed object; GM keeps stale instance ids.
	return is_instance_valid(v) and v is GMInstance


static func _as_inst(v: Variant) -> GMInstance:
	if is_instance_valid(v) and v is GMInstance:
		return v
	if v is int or v is float:
		return by_id.get(int(v), null)
	return null


static func _refresh_loop_ids() -> void:
	# GM8 exposes the current instance list as instance_count / instance_id[].
	loop_id.clear()
	for inst in instances:
		if inst.alive:
			loop_id.append(inst.inst_id)
	loop_count = loop_id.size()


static func lnot(v: Variant) -> int:
	if v is bool:
		return 0 if v else 1
	if v is int or v is float:
		return 1 if v == 0 else 0
	return 0 if v != null else 1


static func eqv(S, a: Variant, b: Variant) -> int:
	# GM compares instance handles as numbers; GDScript refuses Object == int.
	if a is bool:
		a = 1 if a else 0
	if b is bool:
		b = 1 if b else 0
	var ai := _is_inst(a)
	var bi := _is_inst(b)
	if ai or bi:
		if ai and bi:
			return 1 if a.inst_id == b.inst_id else 0
		if ai:
			if b is int or b is float:
				return 1 if a.inst_id == int(b) else 0
			return 0
		if a is int or a is float:
			return 1 if b.inst_id == int(a) else 0
		return 0
	return 1 if a == b else 0


static func instance_exists(S, id: Variant) -> Variant:
	if is_instance_valid(id) and id is GMInstance:
		return id.alive
	if id is int or id is float:
		var i: int = int(id)
		if i >= 0 and objects.has(i):
			return instance_number(S, i) > 0
		return by_id.has(i) and by_id[i].alive
	return false


static var fam_cache: Dictionary = {}


# Collision queries are called dozens of times per step (several NPC draw events
# scan the whole wall family), so the per-family list is reused until an instance
# is created or destroyed.
static func _family_instances(obj: int) -> Array:
	if obj == -3:
		return instances.duplicate()
	if obj < 0 or not obj_family.has(obj):
		return []
	if fam_cache.has(obj):
		return fam_cache[obj]
	var out: Array = []
	for oi in obj_family[obj]:
		for inst in by_object.get(oi, []):
			if inst.alive:
				out.append(inst)
	fam_cache[obj] = out
	return out


# Big families (walls, coins) are bucketed into a coarse grid; a query then only
# touches instances whose collision box shares a cell with the query box. Grids
# are rebuilt lazily after any member moves or a member is created/destroyed.
const GRID_CELL := 128
const GRID_OFFSET := 32768
static var fam_grid: Dictionary = {}
static var fam_dirty: Dictionary = {}
static var grid_watch: Dictionary = {}
static var grid_qid: int = 0


static func _mark_obj_dirty(oi: int) -> void:
	if fam_grid.is_empty():
		return
	var fs: Variant = grid_watch.get(oi)
	if fs == null:
		var arr: Array = []
		for f in obj_family:
			if obj_family[f].has(oi):
				arr.append(f)
		grid_watch[oi] = arr
		fs = arr
	for f in fs:
		fam_dirty[f] = true


static func _mark_moved(oi: int) -> void:
	var fs: Variant = grid_watch.get(oi)
	if fs == null:
		return
	for f in fs:
		fam_dirty[f] = true


static func _fam_grid_key(cx: int, cy: int) -> int:
	return (cy + GRID_OFFSET) * 65536 + (cx + GRID_OFFSET)


static func _family_grid(obj: int) -> Dictionary:
	var g: Variant = fam_grid.get(obj)
	if g != null and not bool(fam_dirty.get(obj, false)):
		return g
	var lst := _family_instances(obj)
	g = {"cells": {}, "big": []}
	var cells: Dictionary = g["cells"]
	var big: Array = g["big"]
	for inst in lst:
		if not inst.alive:
			continue
		var xs := absf(float(inst.g_image_xscale))
		var ys := absf(float(inst.g_image_yscale))
		var b: Rect2 = inst.mask_at(inst.position.x, inst.position.y)
		if xs != 1.0 or ys != 1.0 or b.size.x > 512.0 or b.size.y > 512.0:
			big.append(inst)
			continue
		var x0: int = floori(b.position.x / GRID_CELL)
		var x1: int = floori((b.end.x - 0.001) / GRID_CELL)
		var y0: int = floori(b.position.y / GRID_CELL)
		var y1: int = floori((b.end.y - 0.001) / GRID_CELL)
		for cy in range(y0, y1 + 1):
			for cx in range(x0, x1 + 1):
				var k := _fam_grid_key(cx, cy)
				if cells.has(k):
					cells[k].append(inst)
				else:
					cells[k] = [inst]
	fam_grid[obj] = g
	fam_dirty[obj] = false
	return g


static func _family_candidates(obj: int, a: Rect2) -> Array:
	var lst := _family_instances(obj)
	if obj < 0 or lst.size() < 24:
		return lst
	var g := _family_grid(obj)
	var out: Array = g["big"].duplicate()
	grid_qid += 1
	var q: int = grid_qid
	for inst in out:
		inst.qstamp = q
	var cells: Dictionary = g["cells"]
	var x0: int = floori(a.position.x / GRID_CELL)
	var x1: int = floori((a.end.x - 0.001) / GRID_CELL)
	var y0: int = floori(a.position.y / GRID_CELL)
	var y1: int = floori((a.end.y - 0.001) / GRID_CELL)
	for cy in range(y0, y1 + 1):
		for cx in range(x0, x1 + 1):
			var arr: Variant = cells.get(_fam_grid_key(cx, cy))
			if arr == null:
				continue
			for inst in arr:
				if inst.qstamp != q:
					inst.qstamp = q
					out.append(inst)
	return out


static func instance_number(S, obj: int) -> Variant:
	return _family_instances(obj).size()


static func instance_nearest(S, x: float, y: float, obj: int) -> Variant:
	var best: GMInstance = null
	var bd: float = 1e30
	for inst in _family_instances(obj):
		if inst == S:
			continue
		var d: float = Vector2(inst.position.x - x, inst.position.y - y).length_squared()
		if d < bd:
			bd = d
			best = inst
	return best if best != null else NOONE


static func with_ids(S, expr: Variant) -> Array:
	if is_instance_valid(expr) and expr is GMInstance:
		return [expr] if expr.alive else []
	if expr is int or expr is float:
		var i: int = int(expr)
		if i == -3:
			return instances.duplicate()
		if i == -5:
			return [S]
		if i == -6:
			var o: GMInstance = _as_inst(S.g_other)
			return [o] if o != null and o.alive else []
		if i >= 0:
			return _family_instances(i)
		var inst: GMInstance = by_id.get(i, null)
		return [inst] if inst != null and inst.alive else []
	return []


# GameMaker resolves obj.variable against instances of the object and its
# children (e.g. obj 725 only exists through child 729 in the save room).
static func get_obj_var(oid: int, name: String) -> Variant:
	for inst in _family_instances(oid):
		return member_get(inst, name)
	return 0


static func set_obj_var(oid: int, name: String, val: Variant) -> Variant:
	for inst in _family_instances(oid):
		member_set(inst, name, val)
		return 0
	return 0


static func member_get(inst: GMInstance, name: String) -> Variant:
	if name == "g_x":
		return inst.position.x
	if name == "g_y":
		return inst.position.y
	if name == "g_id":
		return inst.inst_id
	var v: Variant = inst.get(name)
	if v is Array:
		return aget(v, 0)
	return v


static func member_set(inst: GMInstance, name: String, val: Variant) -> void:
	if name == "g_x":
		inst.position.x = float(val)
		_mark_moved(int(inst.g_object_index))
	elif name == "g_y":
		inst.position.y = float(val)
		_mark_moved(int(inst.g_object_index))
	else:
		var old: Variant = inst.get(name)
		if old is Array:
			aset(old, 0, val)
		else:
			inst.set(name, val)


static func member_raw(inst: GMInstance, name: String) -> Variant:
	# The array itself, for subscripts, without element-0 unwrapping.
	return inst.get(name)


static func obj_var_raw(oid: int, name: String) -> Variant:
	var arr: Array = by_object.get(oid, [])
	for inst in arr:
		if inst.alive:
			return member_raw(inst, name)
	return []


static func inst_get_raw(id: Variant, name: String) -> Variant:
	var inst: GMInstance = _as_inst(id)
	if inst == null or not inst.alive:
		return []
	return member_raw(inst, "g_" + _san(name))


static func inst_get(id: Variant, name: String) -> Variant:
	var inst: GMInstance = _as_inst(id)
	if inst == null or not inst.alive:
		return 0
	return member_get(inst, "g_" + _san(name))


static func inst_set(id: Variant, name: String, val: Variant) -> Variant:
	var inst: GMInstance = _as_inst(id)
	if inst == null or not inst.alive:
		return 0
	member_set(inst, "g_" + _san(name), val)
	return 0


const GD_KEYWORDS := ["if", "elif", "else", "for", "while", "match", "break", "continue",
	"pass", "return", "class", "class_name", "extends", "is", "in", "as", "self", "signal",
	"func", "static", "const", "var", "await", "assert", "breakpoint", "preload", "super",
	"tool", "yield", "void", "enum", "namespace", "trait", "onready", "export", "master",
	"puppet", "remote", "sync", "and", "or", "not", "true", "false", "null", "when"]


static func _san(name: String) -> String:
	var out := ""
	for c in name:
		out += c if (c.is_valid_identifier() or c == "_" or (c >= "0" and c <= "9")) else "_"
	if out.is_empty():
		out = "_"
	if out[0].is_valid_int():
		out = "_" + out
	if out in GD_KEYWORDS:
		out += "_"
	return out


static func variable_local_exists(S, name: String) -> Variant:
	return S != null and ("g_" + _san(name)) in S


# ---------------------------------------------------------------- motion
static func get_speed(S) -> Variant:
	return Vector2(S.g_hspeed, S.g_vspeed).length()


static func get_direction(S) -> Variant:
	var v := Vector2(S.g_hspeed, S.g_vspeed)
	return rad_to_deg(atan2(-v.y, v.x)) if v.length() > 0 else 0.0


static func get_hspeed(S) -> Variant:
	return S.g_hspeed


static func get_vspeed(S) -> Variant:
	return S.g_vspeed


static func _sync_sd(S) -> void:
	S.g_speed = get_speed(S)
	S.g_direction = get_direction(S)


static func set_speed(S, v: float) -> Variant:
	var d: float = deg_to_rad(float(S.g_direction))
	S.g_hspeed = cos(d) * float(v)
	S.g_vspeed = -sin(d) * float(v)
	S.g_speed = float(v)
	return 0


static func set_direction(S, d: float) -> Variant:
	var sp: float = float(S.g_speed)
	var r: float = deg_to_rad(float(d))
	S.g_hspeed = cos(r) * sp
	S.g_vspeed = -sin(r) * sp
	S.g_direction = float(d)
	return 0


static func set_hspeed(S, v: float) -> Variant:
	S.g_hspeed = float(v)
	_sync_sd(S)
	return 0


static func set_vspeed(S, v: float) -> Variant:
	S.g_vspeed = float(v)
	_sync_sd(S)
	return 0


static func motion_set(S, dir: float, spd: float) -> Variant:
	var r: float = deg_to_rad(float(dir))
	S.g_hspeed = cos(r) * float(spd)
	S.g_vspeed = -sin(r) * float(spd)
	_sync_sd(S)
	return 0


static func motion_add(S, dir: float, spd: float) -> Variant:
	var r: float = deg_to_rad(float(dir))
	S.g_hspeed += cos(r) * float(spd)
	S.g_vspeed += -sin(r) * float(spd)
	_sync_sd(S)
	return 0


static func get_visible(S) -> Variant:
	return S.g_visible


static func set_visible(S, v: Variant) -> Variant:
	S.g_visible = float(v) > 0.5 if (v is int or v is float) else bool(v)
	S.visible = S.g_visible
	return 0


static func get_persistent(S) -> Variant:
	return S.g_persistent


static func set_persistent(S, v: Variant) -> Variant:
	S.g_persistent = bool(v)
	return 0


# ---------------------------------------------------------------- collision
# GM8 sprites have two mask kinds: a rectangle (shape 1) or a precise pixel mask
# (shape 0). The original game builds every slope out of precise sprites, so an
# AABB-only test turns them into 40px stairs. Build the pixel mask lazily from
# the frame image and test it the way the GM8 runner does.
static func _mask_of(inst) -> Dictionary:
	if inst == null or not inst.alive:
		return {}
	var mi: int = int(inst.g_mask_index)
	var idx: int = mi if mi >= 0 else int(inst.g_sprite_index)
	return _mask_for(idx, int(inst.g_image_index))


static func _mask_for(idx: int, image_index: int) -> Dictionary:
	if not sprites.has(idx):
		return {}
	var s: Dictionary = sprites[idx]
	if int(s["shape"]) != 0:
		return {}
	if not s["loaded"]:
		sprite_info(idx)
	var frames: Array = s["frames"]
	if frames.is_empty():
		return {}
	var key: int = posmod(image_index, frames.size()) if bool(s["per_frame"]) else -1
	var masks: Dictionary = s["masks"]
	if masks.has(key):
		return masks[key]
	var m := _build_mask(idx, key)
	masks[key] = m
	return m


static func _build_mask(idx: int, frame_key: int) -> Dictionary:
	var s: Dictionary = sprites[idx]
	var frames: Array = s["frames"]
	var bi: Vector4i = s["bbox_img"]
	var imgs: Array = []
	var which: Array = []
	if frame_key >= 0:
		which = [frame_key]
	else:
		for i in frames.size():
			which.append(i)
	var w := 0
	var h := 0
	for fi in which:
		var tex: Texture2D = frames[fi]
		if tex == null:
			continue
		var im: Image = tex.get_image()
		if im == null:
			continue
		im = im.duplicate()
		im.convert(Image.FORMAT_RGBA8)
		w = maxi(w, im.get_width())
		h = maxi(h, im.get_height())
		imgs.append(im)
	if imgs.is_empty() or w <= 0 or h <= 0:
		return {}
	var x0: int = clampi(bi.x, 0, w - 1)
	var y0: int = clampi(bi.y, 0, h - 1)
	var x1: int = clampi(bi.z, 0, w - 1)
	var y1: int = clampi(bi.w, 0, h - 1)
	if x1 < x0 or y1 < y0:
		return {}
	var tol: int = int(s["alpha_tolerance"])
	var bits := PackedByteArray()
	bits.resize(w * h)
	var runs: Array = []
	runs.resize(h)
	var solid := false
	var full := true
	for y in h:
		var rr := PackedInt32Array()
		if y >= y0 and y <= y1:
			var run_start := -1
			for x in range(x0, x1 + 2):
				var on := false
				if x <= x1:
					for im in imgs:
						if int(im.get_pixel(x, y).a8) > tol:
							on = true
							break
				if on:
					bits[y * w + x] = 1
					solid = true
					if run_start < 0:
						run_start = x
				elif run_start >= 0:
					rr.append(run_start)
					rr.append(x)
					run_start = -1
			for x in range(x0, x1 + 1):
				if bits[y * w + x] == 0:
					full = false
		else:
			full = false
		runs[y] = rr
	if not solid:
		full = false
	return {"w": w, "h": h, "x0": x0, "y0": y0, "x1": x1, "y1": y1,
		"bits": bits, "runs": runs, "full": full}


static func _pin_mask(inst) -> Dictionary:
	var mi: int = int(inst.g_mask_index)
	var idx: int = mi if mi >= 0 else int(inst.g_sprite_index)
	var key: int = idx * 4096 + posmod(int(inst.g_image_index), 4096)
	if inst.pm_key == key:
		return inst.pm_val
	var m := _mask_for(idx, int(inst.g_image_index))
	var val: Dictionary = {}
	if not m.is_empty() and not bool(m["full"]):
		val = m
	inst.pm_key = key
	inst.pm_val = val
	return val


# Both instances' transforms are integer scale/mirror and unrotated: intersect the
# per-row solid spans instead of walking every pixel (this is the hot path).
static func _mask_fast_ok(inst) -> bool:
	if float(inst.g_image_angle) != 0.0:
		return false
	var xs := absf(float(inst.g_image_xscale))
	var ys := absf(float(inst.g_image_yscale))
	return xs == 1.0 and ys == 1.0


static func _hit_spans(S, px: float, py: float, ma: Dictionary, other, mb: Dictionary,
		a: Rect2, b: Rect2) -> bool:
	var y0: int = int(ceil(maxf(a.position.y, b.position.y)))
	var y1: int = int(floor(minf(a.end.y, b.end.y) - 1.0))
	var ax: int = roundi(px)
	var bx: int = roundi(other.position.x)
	var asx: int = 1 if float(S.g_image_xscale) > 0.0 else -1
	var bsx: int = 1 if float(other.g_image_xscale) > 0.0 else -1
	var asy: int = 1 if float(S.g_image_yscale) > 0.0 else -1
	var bsy: int = 1 if float(other.g_image_yscale) > 0.0 else -1
	var aoy: int = int(S.mask_origin.y)
	var boy: int = int(other.mask_origin.y)
	var aox: int = int(S.mask_origin.x)
	var box: int = int(other.mask_origin.x)
	var bmin: int = int(floor(b.position.x))
	var bmax: int = int(ceil(b.end.x) - 1.0)
	var amin: int = int(floor(a.position.x))
	var amax: int = int(ceil(a.end.x) - 1.0)
	for wy in range(y0, y1 + 1):
		var aruns := PackedInt32Array()
		if not ma.is_empty():
			var la: int = aoy + (wy - roundi(py)) * asy
			if la < 0 or la >= int(ma["h"]):
				continue
			aruns = ma["runs"][la]
		var bruns := PackedInt32Array()
		if not mb.is_empty():
			var lb: int = boy + (wy - roundi(other.position.y)) * bsy
			if lb < 0 or lb >= int(mb["h"]):
				continue
			bruns = mb["runs"][lb]
		if ma.is_empty():
			if _spans_hit_rect(bruns, bx, box, bsx, amin, amax):
				return true
		elif mb.is_empty():
			if _spans_hit_rect(aruns, ax, aox, asx, bmin, bmax):
				return true
		elif _spans_hit(aruns, ax, aox, asx, bruns, bx, box, bsx):
			return true
	return false


static func _spans_hit_rect(runs: PackedInt32Array, base: int, o: int, s: int,
		rmin: int, rmax: int) -> bool:
	var i := 0
	while i + 1 < runs.size():
		var lo: int = base + (runs[i] - o) * s
		var hi: int = base + (runs[i + 1] - o) * s
		if lo > hi:
			var t := lo
			lo = hi
			hi = t
		if lo <= rmax and rmin < hi:
			return true
		i += 2
	return false


static func _spans_hit(aruns: PackedInt32Array, abase: int, ao: int, asx: int,
		bruns: PackedInt32Array, bbase: int, bo: int, bsx: int) -> bool:
	var i := 0
	var j := 0
	while i + 1 < aruns.size() and j + 1 < bruns.size():
		var alo: int = abase + (aruns[i] - ao) * asx
		var ahi: int = abase + (aruns[i + 1] - ao) * asx
		if alo > ahi:
			var t := alo
			alo = ahi
			ahi = t
		var blo: int = bbase + (bruns[j] - bo) * bsx
		var bhi: int = bbase + (bruns[j + 1] - bo) * bsx
		if blo > bhi:
			var t2 := blo
			blo = bhi
			bhi = t2
		if alo < bhi and blo < ahi:
			return true
		if ahi <= bhi:
			i += 2
		else:
			j += 2
	return false


static func _hit_pixels(S, px: float, py: float, ma: Dictionary, other, mb: Dictionary,
		a: Rect2, b: Rect2) -> bool:
	var x0: int = int(ceil(maxf(a.position.x, b.position.x)))
	var x1: int = int(floor(minf(a.end.x, b.end.x) - 1.0))
	var y0: int = int(ceil(maxf(a.position.y, b.position.y)))
	var y1: int = int(floor(minf(a.end.y, b.end.y) - 1.0))
	for wy in range(y0, y1 + 1):
		for wx in range(x0, x1 + 1):
			if not ma.is_empty() and not _pixel_hit(S, px, py, ma, wx, wy):
				continue
			if not mb.is_empty() and not _pixel_hit(other, other.position.x,
					other.position.y, mb, wx, wy):
				continue
			return true
	return false


static func _pixel_hit(inst, px: float, py: float, m: Dictionary, wx: int, wy: int) -> bool:
	var dx: float = float(wx) - roundf(px)
	var dy: float = float(wy) - roundf(py)
	var ang := float(inst.g_image_angle)
	if ang != 0.0:
		var rad := deg_to_rad(ang)
		var ca := cos(rad)
		var sa := sin(rad)
		var rx := dx * ca - dy * sa
		dy = dx * sa + dy * ca
		dx = rx
	var xs := float(inst.g_image_xscale)
	var ys := float(inst.g_image_yscale)
	if xs == 0.0 or ys == 0.0:
		return false
	var lx: int = int(floorf(inst.mask_origin.x + dx / xs))
	var ly: int = int(floorf(inst.mask_origin.y + dy / ys))
	if lx < int(m["x0"]) or lx > int(m["x1"]) or ly < int(m["y0"]) or ly > int(m["y1"]):
		return false
	return m["bits"][ly * int(m["w"]) + lx] != 0


static func place_meeting(S, x: float, y: float, obj: int) -> Variant:
	var a: Rect2 = S.mask_at(x, y)
	var ma: Dictionary = _pin_mask(S)
	var fast: bool = _mask_fast_ok(S)
	var lst: Array = _family_candidates(obj, a)
	for k in lst.size():
		var inst: GMInstance = lst[k]
		if inst == S or not inst.alive:
			continue
		var b: Rect2 = inst.mask_at(inst.position.x, inst.position.y)
		if not a.intersects(b):
			continue
		var mb: Dictionary = _pin_mask(inst)
		if ma.is_empty() and mb.is_empty():
			return true
		if fast and _mask_fast_ok(inst):
			if _hit_spans(S, x, y, ma, inst, mb, a, b):
				return true
		elif _hit_pixels(S, x, y, ma, inst, mb, a, b):
			return true
	return false


static func instance_place(S, x: float, y: float, obj: int) -> Variant:
	var a: Rect2 = S.mask_at(x, y)
	var ma: Dictionary = _pin_mask(S)
	var fast: bool = _mask_fast_ok(S)
	var lst: Array = _family_candidates(obj, a)
	for k in lst.size():
		var inst: GMInstance = lst[k]
		if inst == S or not inst.alive:
			continue
		var b: Rect2 = inst.mask_at(inst.position.x, inst.position.y)
		if not a.intersects(b):
			continue
		var mb: Dictionary = _pin_mask(inst)
		if ma.is_empty() and mb.is_empty():
			return inst
		if fast and _mask_fast_ok(inst):
			if _hit_spans(S, x, y, ma, inst, mb, a, b):
				return inst
		elif _hit_pixels(S, x, y, ma, inst, mb, a, b):
			return inst
	return NOONE


static var _pipe_guard_ticks: int = 0
static var _pipe_guard_x: float = 0.0
static var _pipe_guard_y: float = 0.0


# Pipe traversal can dead-end: a follow-route (pauza=5) whose timer expires while
# Mario is inside a wall and whose speed is 0 never satisfies the "free of wall"
# exit test, so input stays disabled forever. Separately, Mario can end up embedded
# in a pipe's solid collision at pauza=0 (normal control) and be unable to move in
# any direction. Both traps share one signature: zero movement for a sustained
# stretch while in a pipe state OR inside solid collision. A freely-standing or
# normally-walking Mario is never inside solid collision, so this never fires in
# healthy play. When detected, clear the traversal state and lift Mario to the
# nearest free spot so the caller can drop pauza back to 0. Shared by every room.
static func pipe_softlock_guard(S, pauza: int) -> bool:
	var px: float = S.position.x
	var py: float = S.position.y
	var pipe_state: bool = pauza == 1 or pauza == 2 or pauza == 5 or pauza == 11
	var embedded: bool = place_meeting(S, px, py, 1)
	if not pipe_state and not embedded:
		_pipe_guard_ticks = 0
		_pipe_guard_x = px
		_pipe_guard_y = py
		return false
	if absf(px - _pipe_guard_x) > 0.5 or absf(py - _pipe_guard_y) > 0.5:
		_pipe_guard_ticks = 0
		_pipe_guard_x = px
		_pipe_guard_y = py
		return false
	_pipe_guard_ticks += 1
	if _pipe_guard_ticks < 90:
		return false
	_pipe_guard_ticks = 0
	member_set(S, "g_podazaj_skrotem", 0)
	member_set(S, "g_skrot_podazaj_speed", 0)
	member_set(S, "g_timer_skrot", 0)
	member_set(S, "g_checked_id_rurowe_przejscie", 0)
	member_set(S, "g_kierunek_podazania", 0)
	member_set(S, "g_grawitacja", 0)
	member_set(S, "g_sekwencja", 0)
	member_set(S, "g_szybkosc", 0)
	if place_meeting(S, px, py, 1):
		var freed := false
		for r in range(8, 320, 8):
			for off in [Vector2(0, -r), Vector2(r, 0), Vector2(-r, 0),
					Vector2(r, -r), Vector2(-r, -r), Vector2(0, r)]:
				var q: Vector2 = Vector2(px, py) + Vector2(off)
				if not place_meeting(S, q.x, q.y, 1):
					S.position = q
					_mark_moved(int(S.g_object_index))
					freed = true
					break
			if freed:
				break
	return true


static func collision_point(S, x: float, y: float, obj: int, prec = 0, notme = 0) -> Variant:
	var p := Vector2(x, y)
	for inst in _family_instances(obj):
		if notme and inst == S:
			continue
		var r: Rect2 = inst.mask_at(inst.position.x, inst.position.y)
		if not r.has_point(p):
			continue
		if prec:
			var m := _pin_mask(inst)
			if not m.is_empty() and not _pixel_hit(inst, inst.position.x, inst.position.y,
					m, roundi(x), roundi(y)):
				continue
		return inst
	return NOONE


static func collision_rectangle(S, x1: float, y1: float, x2: float, y2: float,
		obj: int, prec = 0, notme = 0) -> Variant:
	var r := Rect2(Vector2(minf(x1, x2), minf(y1, y2)), Vector2(absf(x2 - x1), absf(y2 - y1)))
	for inst in _family_candidates(obj, r):
		if notme and inst == S:
			continue
		if not r.intersects(inst.mask_at(inst.position.x, inst.position.y)):
			continue
		if prec:
			var m := _pin_mask(inst)
			if not m.is_empty():
				var rx0: int = int(ceil(r.position.x))
				var rx1: int = int(floor(r.end.x - 1.0))
				var ry0: int = int(ceil(r.position.y))
				var ry1: int = int(floor(r.end.y - 1.0))
				var hit := false
				for wy in range(ry0, ry1 + 1):
					for wx in range(rx0, rx1 + 1):
						if _pixel_hit(inst, inst.position.x, inst.position.y, m, wx, wy):
							hit = true
							break
					if hit:
						break
				if not hit:
					continue
		return inst
	return NOONE


static func collision_circle(S, x: float, y: float, radius: float, obj: int,
		prec = 0, notme = 0) -> Variant:
	var c := Vector2(x, y)
	var cb := Rect2(x - radius, y - radius, radius * 2.0, radius * 2.0)
	for inst in _family_candidates(obj, cb):
		if notme and inst == S:
			continue
		var mr: Rect2 = inst.mask_at(inst.position.x, inst.position.y)
		var closest := Vector2(clampf(c.x, mr.position.x, mr.end.x),
			clampf(c.y, mr.position.y, mr.end.y))
		if c.distance_to(closest) > radius:
			continue
		if prec:
			var m := _pin_mask(inst)
			if not m.is_empty():
				var rr := int(ceil(radius))
				var hit := false
				for wy in range(roundi(y) - rr, roundi(y) + rr + 1):
					for wx in range(roundi(x) - rr, roundi(x) + rr + 1):
						if Vector2(wx - x, wy - y).length() > radius:
							continue
						if _pixel_hit(inst, inst.position.x, inst.position.y, m, wx, wy):
							hit = true
							break
					if hit:
						break
				if not hit:
					continue
		return inst
	return NOONE


# ---------------------------------------------------------------- math / value
static func now() -> Variant:
	return Time.get_ticks_msec() - start_ms


static func abs(S, v: float) -> Variant:
	return absf(float(v))


static func sign(S, v: float) -> Variant:
	return signf(float(v))


static func sin(S, v: float) -> Variant:
	return sin(float(v))


static func cos(S, v: float) -> Variant:
	return cos(float(v))


static func degtorad(S, v: float) -> Variant:
	return deg_to_rad(float(v))


static func sqrt(S, v: float) -> Variant:
	return sqrt(maxf(0.0, float(v)))


static func floor(S, v: float) -> Variant:
	return floorf(float(v))


static func ceil(S, v: float) -> Variant:
	return ceilf(float(v))


static func round(S, v: float) -> Variant:
	return roundf(float(v))


static func min(S, a: float, b: float) -> Variant:
	return minf(float(a), float(b))


static func max(S, a: float, b: float) -> Variant:
	return maxf(float(a), float(b))


static func modv(S, a: Variant, b: Variant) -> Variant:
	# GameMaker's mod accepts reals; GDScript's % insists on two ints or two floats.
	if (a is int or a is float) and (b is int or b is float):
		var bi := float(b)
		if bi == 0.0:
			return 0.0
		if a is int and b is int:
			return int(a) % int(b)
		return fmod(float(a), bi)
	return 0.0



static func point_distance(S, x1: float, y1: float, x2: float, y2: float) -> Variant:
	return Vector2(x1, y1).distance_to(Vector2(x2, y2))


static func point_direction(S, x1: float, y1: float, x2: float, y2: float) -> Variant:
	return rad_to_deg(atan2(-(float(y2) - float(y1)), float(x2) - float(x1)))


static func random(S, n: float) -> Variant:
	return randf() * float(n)


static func make_color_rgb(S, r: float, g: float, b: float) -> Variant:
	return int(r) + int(g) * 256 + int(b) * 65536


static func real(S, v: Variant) -> Variant:
	return float(v) if str(v).is_valid_float() else 0.0


static func ord(S, s: String) -> Variant:
	return s.unicode_at(0) if s.length() > 0 else 0


static func concat(a: Variant, b: Variant) -> Variant:
	return gm_string(null, a) + gm_string(null, b)


static func aget(arr: Variant, i: Variant) -> Variant:
	if arr is Array:
		var idx: int = int(i)
		if idx >= 0 and idx < arr.size():
			return arr[idx]
	return 0


static func aset(arr: Variant, i: Variant, v: Variant) -> Variant:
	if arr is Array:
		var idx: int = int(i)
		if idx >= 0:
			while arr.size() <= idx:
				arr.append(0)
			arr[idx] = v
	return 0


static func aget2(arr: Variant, i: Variant, j: Variant) -> Variant:
	return aget(aget(arr, i), j)


static func aset2(arr: Variant, i: Variant, j: Variant, v: Variant) -> Variant:
	if arr is Array:
		var idx: int = int(i)
		if idx >= 0:
			while arr.size() <= idx:
				arr.append([])
			if not arr[idx] is Array:
				arr[idx] = []
			aset(arr[idx], j, v)
	return 0


# ---------------------------------------------------------------- string
static func gm_string(S, v: Variant) -> String:
	if v is String:
		return v
	if v is float:
		if v == floorf(v) and absf(v) < 1e15:
			return str(int(v))
		return str(v)
	if v is bool:
		return "1" if v else "0"
	if v == null:
		return "0"
	return str(v)


static func string(S, v: Variant) -> Variant:
	return gm_string(S, v)


static func string_length(S, s: Variant) -> Variant:
	return gm_string(S, s).length()


static func string_pos(S, sub: Variant, s: Variant) -> Variant:
	return gm_string(S, s).find(gm_string(S, sub)) + 1


static func string_copy(S, s: Variant, index: float, count: float) -> Variant:
	var text := gm_string(S, s)
	var i: int = maxi(0, int(index) - 1)
	return text.substr(i, maxi(0, int(count)))


static func string_char_at(S, s: Variant, index: float) -> Variant:
	var text := gm_string(S, s)
	var i: int = int(index) - 1
	return text.substr(i, 1) if i >= 0 and i < text.length() else ""


static func string_delete(S, s: Variant, index: float, count: float) -> Variant:
	var text := gm_string(S, s)
	var i: int = maxi(0, int(index) - 1)
	return text.substr(0, i) + text.substr(i + maxi(0, int(count)))


static func string_insert(S, sub: Variant, s: Variant, index: float) -> Variant:
	var text := gm_string(S, s)
	var add := gm_string(S, sub)
	var i: int = maxi(0, int(index) - 1)
	return text.substr(0, i) + add + text.substr(i)


static func string_replace(S, s: Variant, sub: Variant, by: Variant) -> Variant:
	var text := gm_string(S, s)
	var find := gm_string(S, sub)
	var i := text.find(find)
	if i < 0:
		return text
	return text.substr(0, i) + gm_string(S, by) + text.substr(i + find.length())


static func string_replace_all(S, s: Variant, sub: Variant, by: Variant) -> Variant:
	return gm_string(S, s).replace(gm_string(S, sub), gm_string(S, by))


static func string_count(S, sub: Variant, s: Variant) -> Variant:
	return gm_string(S, s).count(gm_string(S, sub))


static func string_lower(S, s: Variant) -> Variant:
	return gm_string(S, s).to_lower()


static func string_digits(S, s: Variant) -> Variant:
	var out := ""
	for c in gm_string(S, s):
		if c >= "0" and c <= "9":
			out += c
	return out


static func string_width(S, s: Variant) -> Variant:
	return _text_width(gm_string(S, s))


static func string_height(S, s: Variant = "") -> Variant:
	return _text_height()


# ---------------------------------------------------------------- arrays for GM globals
static func mouse_x(S) -> Variant:
	return root.get_global_mouse_position().x


static func mouse_y(S) -> Variant:
	return root.get_global_mouse_position().y


# ---------------------------------------------------------------- room loading
static var room_depth_ranks: Dictionary = {}
static var room_depth_sorted: Array = []
static var room_depth_rank_list: Array = []
static var tile_layers: Dictionary = {}
static var room_ci: GMInstance = null
static var room_bg_colour: Color = Color.BLACK
static var lives_fired: bool = false
static var mouse_down: Dictionary = {}
static var mouse_pressed: Dictionary = {}
static var next_font: int = 1


static func _depth_z(depth: float) -> int:
	if room_depth_ranks.has(depth):
		return int(room_depth_ranks[depth])
	var n := room_depth_sorted.size()
	if n == 0:
		return clampi(-int(depth), -4096, 4096)
	# GameMaker drawing order is numeric depth (lower = in front); z_index is
	# inverted and capped at +-4096, so instead of clamping unknown depths in
	# front of everything we slot them between their numeric neighbours.
	var lo := 0
	var hi := n
	while lo < hi:
		var mid := (lo + hi) >> 1
		if float(room_depth_sorted[mid]) < depth:
			lo = mid + 1
		else:
			hi = mid
	if lo == 0:
		return mini(int(room_depth_rank_list[0]) + 1, 4096)
	if lo == n:
		return maxi(int(room_depth_rank_list[n - 1]) - 1, -4096)
	var d0: float = float(room_depth_sorted[lo - 1])
	var d1: float = float(room_depth_sorted[lo])
	var r0: float = float(room_depth_rank_list[lo - 1])
	var r1: float = float(room_depth_rank_list[lo])
	var frac: float = clampf((depth - d0) / (d1 - d0), 0.0, 1.0)
	return clampi(roundi(r0 + (r1 - r0) * frac), -4096, 4096)


static func _assign_depth(inst: GMInstance) -> void:
	inst.last_depth = float(inst.g_depth)
	inst.z_index = _depth_z(float(inst.g_depth))
	inst.z_as_relative = false


static func _resolve_room(target: Variant) -> int:
	if target is int or target is float:
		return int(target)
	var name := str(target)
	for key in room_data.get("rooms", {}):
		if room_data["rooms"][key]["name"] == name:
			return int(key)
	warn("room_name:" + name)
	return -1


# Some rooms spawn Mario inside a pipe shaft and rely on the pipe-exit intro to
# lift him out; that flag is normally set by the pipe in the previous room, so
# map entry and standalone scene boots would leave him wedged.
static func _start_pipe_intro_if_embedded() -> void:
	if G.wychodz_z_rury_nastepny_etap != 0:
		return
	var player: Variant = null
	for inst in instances:
		if inst.alive and int(inst.g_object_index) == 303:
			player = inst
			break
	if player == null:
		return
	var px: float = player.position.x
	var py: float = player.position.y
	# A 1px overlap is a normal ground rest; still embedded 6px up means a pipe.
	if not place_meeting(player, px, py, 1) or not place_meeting(player, px, py - 6, 1):
		return
	G.wychodz_z_rury_nastepny_etap = 1


static func _load_room(idx: int) -> void:
	var meta: Dictionary = room_data.get("rooms", {}).get(str(idx), {})
	if meta.is_empty():
		warn("room_missing:%d" % idx)
		return
	var _lt := Time.get_ticks_usec()
	if debug_load:
		debug_create_usec.clear()
		debug_create_count.clear()
		debug_spawn_usec.clear()
		debug_script_misses = 0
		debug_script_hits = 0
		debug_script_hit_usec = 0
	var keep: Array = []
	fam_cache.clear()
	fam_grid.clear()
	fam_dirty.clear()
	grid_watch.clear()
	if room_root != null:
		for inst in instances.duplicate():
			if inst.alive:
				run_event(inst, 7, 5)
		for inst in instances.duplicate():
			if not inst.alive:
				continue
			if inst.g_persistent:
				room_root.remove_child(inst)
				keep.append(inst)
			else:
				inst.alive = false
				instances.erase(inst)
				by_id.erase(inst.inst_id)
				var oi: int = int(inst.g_object_index)
				if by_object.has(oi):
					by_object[oi].erase(inst)
				inst.queue_free()
		for node in tile_layers.values():
			node.queue_free()
		tile_layers.clear()
		tiles.clear()
		room_root.queue_free()
	var _unload_us := Time.get_ticks_usec() - _lt
	_lt = Time.get_ticks_usec()
	room = idx
	room_width = float(meta.get("w", 800))
	room_height = float(meta.get("h", 600))
	room_speed = maxi(1, int(meta.get("speed", 60)))
	room_persistent = int(meta.get("persistent", 0)) != 0
	room_caption = str(meta.get("name", ""))
	room_bg_colour = _gm_color(meta.get("bg_colour", 0))
	room_depth_ranks = {}
	var depths: Dictionary = {}
	for im in meta.get("instances", []):
		depths[float(objects.get(int(im[2]), {}).get("depth", 0))] = true
	for t in meta.get("tiles", []):
		depths[float(t[7])] = true
	for inst in keep:
		depths[float(inst.g_depth)] = true
	var sorted_d: Array = depths.keys()
	sorted_d.sort()
	var n := sorted_d.size()
	room_depth_sorted = sorted_d
	room_depth_rank_list = []
	for i in n:
		var rank := 4000 - roundi(8000.0 * i / maxi(1, n - 1)) if n > 1 else 0
		room_depth_ranks[float(sorted_d[i])] = rank
		room_depth_rank_list.append(rank)
	view_enabled = int(meta.get("views_enabled", 0)) != 0
	var views: Array = meta.get("views", [])
	for i in mini(8, views.size()):
		var v: Dictionary = views[i]
		view_visible[i] = int(v.get("visible", 0)) != 0
		view_xview[i] = float(v.get("source_x", 0))
		view_yview[i] = float(v.get("source_y", 0))
		view_wview[i] = float(v.get("source_w", 800))
		view_hview[i] = float(v.get("source_h", 600))
		view_xport[i] = int(v.get("port_x", 0))
		view_yport[i] = int(v.get("port_y", 0))
		view_wport[i] = int(v.get("port_w", 800))
		view_hport[i] = int(v.get("port_h", 600))
		view_hborder[i] = int(v.get("hborder", 32))
		view_vborder[i] = int(v.get("vborder", 32))
		view_hspeed[i] = int(v.get("hspeed", -1))
		view_vspeed[i] = int(v.get("vspeed", -1))
		view_object[i] = int(v.get("target", -1))
		view_angle[i] = 0.0
	var ov: Dictionary = view_overrides.get(idx, {})
	for vi in ov:
		_apply_view_cfg(int(vi), ov[vi])
	var bgs: Array = meta.get("backgrounds", [])
	for i in mini(8, bgs.size()):
		var b: Dictionary = bgs[i]
		bg_index[i] = int(b.get("source_bg", -1))
		bg_visible[i] = int(b.get("visible", 0)) != 0 and bg_index[i] >= 0
		bg_foreground[i] = int(b.get("foreground", 0)) != 0
		var xo: float = float(b.get("xoffset", 0))
		var yo: float = float(b.get("yoffset", 0))
		bg_x[i] = 0.0 if xo < -900000 else xo
		bg_y[i] = 0.0 if yo < -900000 else yo
		bg_htiled[i] = int(b.get("tile_horz", 1)) != 0
		bg_vtiled[i] = int(b.get("tile_vert", 1)) != 0
		bg_hspeed[i] = float(b.get("hspeed", 0))
		bg_vspeed[i] = float(b.get("vspeed", 0))
		bg_alpha[i] = 1.0
		bg_xscale[i] = 1.0
		bg_yscale[i] = 1.0
	var _meta_us := Time.get_ticks_usec() - _lt
	_lt = Time.get_ticks_usec()
	room_root = Node2D.new()
	root.add_child(room_root)
	for inst in keep:
		room_root.add_child(inst)
		_assign_depth(inst)
	for im in meta.get("instances", []):
		var spawned: Variant = _spawn_at(float(im[0]), float(im[1]), int(im[2]), int(im[3]))
		next_inst = maxi(next_inst, int(im[3]) + 1)
		if spawned is GMInstance:
			run_room_code(registry.get("inst_create", {}), "%d:%d" % [idx, int(im[3])], spawned)
	var _spawn_us := Time.get_ticks_usec() - _lt
	_lt = Time.get_ticks_usec()
	for t in meta.get("tiles", []):
		_tile_new(float(t[0]), float(t[1]), int(t[2]), float(t[3]), float(t[4]),
			float(t[5]), float(t[6]), float(t[7]), int(t[8]))
	var _tiles_us := Time.get_ticks_usec() - _lt
	_lt = Time.get_ticks_usec()
	room_ci = GMInstance.new()
	room_ci.init_instance({"i": -1, "depth": 0, "visible": 0, "persistent": 0,
		"solid": 0, "mask": -1, "sprite": -1}, -1)
	run_room_code(registry.get("room_create", {}), str(idx), room_ci)
	_start_pipe_intro_if_embedded()
	# A death that restarts the same room skips the map room, which is what
	# normally clears this latch; otherwise the player considers the level song
	# still running and never starts it again.
	if music_player != null and not music_player.playing \
			and eqv(null, G.zostaw_ta_sama_muzyke_w_nast_etapie, G.level_music):
		G.zostaw_ta_sama_muzyke_w_nast_etapie = 8714917489
	if debug_load:
		print("LOAD room=%d unload=%.1f meta=%.1f spawn=%.1f tiles=%.1f room_create=%.1f inst=%d" % [
			idx, _unload_us / 1000.0, _meta_us / 1000.0, _spawn_us / 1000.0,
			_tiles_us / 1000.0, (Time.get_ticks_usec() - _lt) / 1000.0, instances.size()])
		print("LOAD script_misses=%d cached=%d hits=%d hit_us=%.1f" % [
			debug_script_misses, obj_scripts.size(), debug_script_hits,
			debug_script_hit_usec / 1000.0])
		var ks: Array = debug_create_usec.keys()
		ks.sort_custom(func(a, b): return int(debug_create_usec[a]) > int(debug_create_usec[b]))
		var top: Array = []
		for ii in mini(6, ks.size()):
			var oi: int = int(ks[ii])
			top.append("obj%d:%dms/%dx" % [oi, int(debug_create_usec[oi]) / 1000,
				int(debug_create_count[oi])])
		print("LOAD create_top " + " ".join(top))
		var sparts: Array = []
		for pk in ["new", "init", "i_script", "i_events", "i_handler", "i_sprite", "add", "reg", "create", "vis"]:
			sparts.append("%s=%.1f" % [pk, int(debug_spawn_usec.get(pk, 0)) / 1000.0])
		print("LOAD spawn_parts " + " ".join(sparts))
	for inst in instances:
		inst.sync_visuals()
	_refresh_loop_ids()
	lives_fired = false
	update_camera()
	for inst in instances.duplicate():
		if inst.alive:
			run_event(inst, 7, 4)


# ---------------------------------------------------------------- tick driver
static func step() -> void:
	if pending_room != null:
		var target: Variant = pending_room
		pending_room = null
		var idx := _resolve_room(target)
		if idx >= 0 and room_data.get("rooms", {}).has(str(idx)):
			_load_room(idx)
		elif room >= 0:
			# Death returns to global.return_name_of_map, which standalone boots
			# never set; restart the current room instead of leaving it running.
			warn("room_invalid_target:%s restarting:%d" % [str(target), room])
			_load_room(room)
	if room < 0 or room_root == null:
		return
	tick_count += 1
	fps = room_speed
	var _t := Time.get_ticks_usec()
	_refresh_loop_ids()
	for inst in instances:
		inst.g_xprevious = inst.position.x
		inst.g_yprevious = inst.position.y
	for inst in instances.duplicate():
		if inst.alive and inst.has_begin:
			run_event(inst, 3, 1)
	perf_begin_usec = Time.get_ticks_usec() - _t
	_t = Time.get_ticks_usec()
	for inst in instances.duplicate():
		if not inst.alive:
			continue
		for eid in inst.key_events:
			var k: int = int(eid) % 1000
			var main: int = int(eid) / 1000
			if main == 5:
				if keys_down.has(k):
					run_event(inst, 5, k)
			elif main == 9:
				if keys_pressed.has(k):
					run_event(inst, 9, k)
			elif keys_released.has(k):
				run_event(inst, 10, k)
	perf_keys_usec = Time.get_ticks_usec() - _t
	_t = Time.get_ticks_usec()
	for inst in instances.duplicate():
		if inst.alive and inst.has_step:
			run_event(inst, 3, 0)
	perf_logic_usec = Time.get_ticks_usec() - _t
	_t = Time.get_ticks_usec()
	for inst in instances.duplicate():
		if not inst.alive:
			continue
		if int(inst.g_path_index) >= 0:
			_path_move(inst)
		elif float(inst.g_gravity) != 0.0 or float(inst.g_friction) != 0.0 \
				or float(inst.g_hspeed) != 0.0 or float(inst.g_vspeed) != 0.0:
			if float(inst.g_gravity) != 0.0:
				motion_add(inst, float(inst.g_gravity_direction), float(inst.g_gravity))
			var fr: float = float(inst.g_friction)
			if fr != 0.0:
				var sp: float = get_speed(inst)
				if sp > 0.0:
					set_speed(inst, maxf(0.0, sp - fr))
			inst.position.x += float(inst.g_hspeed)
			inst.position.y += float(inst.g_vspeed)
			_mark_moved(int(inst.g_object_index))
	perf_motion_usec = Time.get_ticks_usec() - _t
	_t = Time.get_ticks_usec()
	for inst in instances.duplicate():
		if not inst.alive:
			continue
		var n: int = inst.frames.size()
		if n > 0 and float(inst.g_image_speed) != 0.0:
			var ii: float = float(inst.g_image_index) + float(inst.g_image_speed)
			if ii >= float(n) or ii < 0.0:
				ii = fposmod(ii, float(n))
				inst.g_image_index = ii
				if inst.has_anim_end:
					run_event(inst, 7, 7)
			else:
				inst.g_image_index = ii
	perf_anim_usec = Time.get_ticks_usec() - _t
	_t = Time.get_ticks_usec()
	for inst in instances.duplicate():
		if inst.alive and inst.has_end:
			run_event(inst, 3, 2)
	perf_end_usec = Time.get_ticks_usec() - _t
	_t = Time.get_ticks_usec()
	for inst in instances:
		if inst.sync_visuals():
			inst.queue_redraw()
	perf_vis_usec = Time.get_ticks_usec() - _t
	_t = Time.get_ticks_usec()
	_update_particles()
	for i in 8:
		bg_x[i] = float(bg_x[i]) + float(bg_hspeed[i])
		bg_y[i] = float(bg_y[i]) + float(bg_vspeed[i])
	_update_views()
	if lives <= 0 and not lives_fired:
		lives_fired = true
		for inst in instances.duplicate():
			if inst.alive:
				run_event(inst, 7, 6)
	keys_pressed.clear()
	keys_released.clear()
	mouse_pressed.clear()
	update_camera()
	if bg_back != null:
		bg_back.queue_redraw()
	if bg_front != null:
		bg_front.queue_redraw()
	perf_views_usec = Time.get_ticks_usec() - _t


# GM8 runs every draw event once per logic step, but Godot only renders once per
# frame. High-speed system rooms (the 1000 Hz loading screen) advance their state
# from the draw event, so replay it for the extra steps. draw_ci stays null here,
# which makes all draw_* calls no-ops while the event's side effects still run.
static func draw_state_passes(count: int) -> void:
	for _p in count:
		for inst in instances.duplicate():
			if inst.alive and inst.has_draw:
				run_event(inst, 8, 0)


static func _update_views() -> void:
	if not view_enabled:
		return
	for i in 8:
		if not view_visible[i] or int(view_object[i]) < 0:
			continue
		var o: GMInstance = _as_inst(view_object[i])
		if o == null or not o.alive:
			continue
		var w: float = float(view_wview[i])
		var h: float = float(view_hview[i])
		var tx: float = o.position.x - w / 2.0
		var ty: float = o.position.y - h / 2.0
		var hb: float = float(view_hborder[i])
		var vb: float = float(view_vborder[i])
		var cx: float = float(view_xview[i])
		var cy: float = float(view_yview[i])
		if o.position.x < cx + hb:
			tx = o.position.x - hb
		elif o.position.x > cx + w - hb:
			tx = o.position.x - w + hb
		else:
			tx = cx
		if o.position.y < cy + vb:
			ty = o.position.y - vb
		elif o.position.y > cy + h - vb:
			ty = o.position.y - h + vb
		else:
			ty = cy
		var hs: float = float(view_hspeed[i])
		var vs: float = float(view_vspeed[i])
		if hs >= 0:
			tx = clampf(tx, cx - hs, cx + hs)
		if vs >= 0:
			ty = clampf(ty, cy - vs, cy + vs)
		view_xview[i] = clampf(tx, 0.0, maxf(0.0, room_width - w))
		view_yview[i] = clampf(ty, 0.0, maxf(0.0, room_height - h))


static func update_camera() -> void:
	if camera == null or root == null:
		return
	var x := 0.0
	var y := 0.0
	var w := 800.0
	var h := 600.0
	if view_enabled and view_visible[0]:
		w = maxf(1.0, float(view_wview[0]))
		h = maxf(1.0, float(view_hview[0]))
		x = clampf(float(view_xview[0]), 0.0, maxf(0.0, room_width - w))
		y = clampf(float(view_yview[0]), 0.0, maxf(0.0, room_height - h))
		view_xview[0] = x
		view_yview[0] = y
	var vp: Vector2 = root.get_viewport_rect().size
	camera.position = Vector2(x + w / 2.0, y + h / 2.0)
	camera.zoom = Vector2(vp.x / w, vp.y / h)
	if bg_rect != null:
		bg_rect.position = Vector2(x, y)
		bg_rect.size = Vector2(w, h)
		bg_rect.color = room_bg_colour


# ---------------------------------------------------------------- room navigation
static func set_room(target: Variant) -> Variant:
	pending_room = target
	return 0


static func set_room_speed(v: float) -> Variant:
	room_speed = maxi(1, int(v))
	return 0


static func room_goto(S, target: Variant) -> Variant:
	pending_room = target
	return 0


static func room_goto_next(S) -> Variant:
	var pos := _room_order_pos()
	if pos >= 0 and pos + 1 < room_order.size():
		pending_room = int(room_order[pos + 1])
	return 0


static func room_goto_previous(S) -> Variant:
	var pos := _room_order_pos()
	if pos > 0:
		pending_room = int(room_order[pos - 1])
	return 0


static func _room_order_pos() -> int:
	for i in room_order.size():
		if int(room_order[i]) == room:
			return i
	return -1


static func room_get_name(S, idx: int) -> Variant:
	return str(room_data.get("rooms", {}).get(str(idx), {}).get("name", ""))


static func room_set_view(S, ind: int, vind: int, vis: Variant, xview: float, yview: float,
		wview: float, hview: float, xport: int, yport: int, wport: int, hport: int,
		hborder: int, vborder: int, hspeed: int, vspeed: int, obj = -1) -> Variant:
	# GameMaker 8: (ind, vind, vis, xview, yview, wview, hview, xport, yport, wport,
	# hport, hborder, vborder, hspeed, vspeed, obj). Affects the stored room, not
	# necessarily the one currently running.
	var rid := int(ind)
	var vi := clampi(int(vind), 0, 7)
	var cfg := {
		"visible": bool(vis),
		"xview": float(xview), "yview": float(yview),
		"wview": float(wview), "hview": float(hview),
		"xport": int(xport), "yport": int(yport), "wport": int(wport), "hport": int(hport),
		"hborder": int(hborder), "vborder": int(vborder),
		"hspeed": int(hspeed), "vspeed": int(vspeed), "obj": int(obj),
	}
	if not view_overrides.has(rid):
		view_overrides[rid] = {}
	var mine: Dictionary = view_overrides[rid]
	mine[vi] = cfg
	if rid == room:
		_apply_view_cfg(vi, cfg)
		update_camera()
	return 0


static func _apply_view_cfg(vi: int, cfg: Dictionary) -> void:
	view_visible[vi] = bool(cfg["visible"])
	view_xview[vi] = float(cfg["xview"])
	view_yview[vi] = float(cfg["yview"])
	view_wview[vi] = float(cfg["wview"])
	view_hview[vi] = float(cfg["hview"])
	view_xport[vi] = int(cfg["xport"])
	view_yport[vi] = int(cfg["yport"])
	view_wport[vi] = int(cfg["wport"])
	view_hport[vi] = int(cfg["hport"])
	view_hborder[vi] = int(cfg["hborder"])
	view_vborder[vi] = int(cfg["vborder"])
	view_hspeed[vi] = int(cfg["hspeed"])
	view_vspeed[vi] = int(cfg["vspeed"])
	view_object[vi] = int(cfg["obj"])


# ---------------------------------------------------------------- drawing
static func _gm_color(c: Variant) -> Color:
	var v: int = int(c)
	return Color(float(v & 255) / 255.0, float((v >> 8) & 255) / 255.0,
		float((v >> 16) & 255) / 255.0)


static func _restore_xform() -> void:
	if draw_ci is Node2D:
		draw_ci.draw_set_transform(-(draw_ci as Node2D).position, 0.0, Vector2.ONE)
	else:
		draw_ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


static func _draw_offset() -> Vector2:
	# Draw events use room coordinates, but the canvas item itself is positioned at
	# the instance; every absolute transform must cancel that node transform.
	if draw_offset_override != null:
		return draw_offset_override
	if draw_ci is Node2D:
		return -(draw_ci as Node2D).position
	return Vector2.ZERO


static func _draw_color() -> Color:
	var c := draw_color
	c.a *= clampf(draw_alpha, 0.0, 1.0)
	return c


static func draw_set_color(S, c: Variant) -> Variant:
	draw_color = _gm_color(c)
	return 0


static func draw_set_alpha(S, a: float) -> Variant:
	draw_alpha = clampf(float(a), 0.0, 1.0)
	return 0


static func draw_set_halign(S, a: int) -> Variant:
	draw_halign = int(a)
	return 0


static func draw_set_valign(S, a: int) -> Variant:
	draw_valign = int(a)
	return 0


static func draw_set_font(S, f: Variant) -> Variant:
	draw_font = f
	return 0


static func draw_set_blend_mode(S, mode: int) -> Variant:
	draw_blend = int(mode)
	return 0


static func draw_set_blend_mode_ext(S, src: int, dest: int) -> Variant:
	draw_blend = 1 if int(src) != 0 else 0
	return 0


static func _sprite_frame(spr: int, subimg: float, S) -> Dictionary:
	var info := sprite_info(spr)
	var frames: Array = info["frames"]
	if frames.is_empty():
		return {}
	var fi: int
	if subimg < 0:
		fi = int(S.g_image_index) if S is GMInstance else 0
	else:
		fi = int(subimg)
	fi = posmod(fi, frames.size())
	if frames[fi] == null:
		return {}
	return {"tex": frames[fi], "origin": info["origin"]}


static func draw_sprite(S, spr: int, subimg: float, x: float, y: float) -> Variant:
	return draw_sprite_ext(S, spr, subimg, x, y, 1, 1, 0, 0xFFFFFF, 1)


static func draw_sprite_ext(S, spr: int, subimg: float, x: float, y: float,
		xscale: float, yscale: float, rot: float, color: Variant, alpha: float) -> Variant:
	if draw_ci == null:
		return 0
	if draw_blend == 1 and draw_ci is GMInstance:
		(draw_ci as GMInstance).add_cmds.append([0, S, spr, subimg, x, y, xscale, yscale,
			rot, color, alpha])
		return 0
	var f := _sprite_frame(int(spr), float(subimg), S)
	if f.is_empty():
		return 0
	var c := _gm_color(color)
	c.a *= clampf(float(alpha), 0.0, 1.0)
	draw_ci.draw_set_transform(Vector2(x, y) + _draw_offset(), -deg_to_rad(float(rot)),
		Vector2(float(xscale), float(yscale)))
	draw_ci.draw_texture(f["tex"], -f["origin"], c)
	_restore_xform()
	return 0


static func additive_material() -> CanvasItemMaterial:
	if _additive_material == null:
		_additive_material = CanvasItemMaterial.new()
		_additive_material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	return _additive_material


static func replay_additive(S, cmd: Array) -> Variant:
	match int(cmd[0]):
		0:
			return draw_sprite_ext(cmd[1], cmd[2], cmd[3], cmd[4], cmd[5], cmd[6],
				cmd[7], cmd[8], cmd[9], cmd[10])
		1:
			var saved_col := draw_color
			var saved_alpha := draw_alpha
			var saved_font: Variant = draw_font
			var saved_h := draw_halign
			var saved_v := draw_valign
			draw_color = cmd[7]
			draw_alpha = cmd[8]
			draw_font = cmd[9]
			draw_halign = int(cmd[10])
			draw_valign = int(cmd[11])
			_draw_text_line(cmd[2], cmd[3], cmd[1], cmd[4], cmd[5], cmd[6])
			draw_color = saved_col
			draw_alpha = saved_alpha
			draw_font = saved_font
			draw_halign = saved_h
			draw_valign = saved_v
		2:
			var sc := draw_color
			var sa := draw_alpha
			var sf2: Variant = draw_font
			var sh := draw_halign
			var sv := draw_valign
			draw_color = cmd[9]
			draw_alpha = cmd[10]
			draw_font = cmd[11]
			draw_halign = int(cmd[12])
			draw_valign = int(cmd[13])
			draw_text_ext_transformed(null, cmd[1], cmd[2], cmd[3], cmd[4], cmd[5],
				cmd[6], cmd[7], cmd[8])
			draw_color = sc
			draw_alpha = sa
			draw_font = sf2
			draw_halign = sh
			draw_valign = sv
	return 0


static func draw_sprite_part_ext(S, spr: int, subimg: float, left: float, top: float,
		width: float, height: float, x: float, y: float, xscale: float, yscale: float,
		color: Variant, alpha: float) -> Variant:
	if draw_ci == null:
		return 0
	var f := _sprite_frame(int(spr), float(subimg), S)
	if f.is_empty():
		return 0
	var c := _gm_color(color)
	c.a *= clampf(float(alpha), 0.0, 1.0)
	draw_ci.draw_set_transform(Vector2(x, y) + _draw_offset(), 0.0,
		Vector2(float(xscale), float(yscale)))
	draw_ci.draw_texture_rect_region(f["tex"], Rect2(0, 0, width, height),
		Rect2(left, top, width, height), c)
	_restore_xform()
	return 0


static func _bg_texture(idx: int) -> Texture2D:
	if not backgrounds.has(idx):
		return null
	var b: Dictionary = backgrounds[idx]
	if not b["loaded"]:
		b["loaded"] = true
		var paths: Array = b.get("paths", [])
		if paths.size() > 0:
			b["tex"] = _load_texture(str(paths[0]))
	return b["tex"]


static func draw_background(S, back: int, x: float, y: float, tiled = 0) -> Variant:
	if draw_ci == null:
		return 0
	var tex := _bg_texture(int(back))
	if tex == null:
		return 0
	if int(tiled) != 0:
		var vp: Vector2 = root.get_viewport_rect().size
		draw_ci.draw_texture_rect(tex, Rect2(x, y, vp.x * 4, vp.y * 4), true, _draw_color())
	else:
		draw_ci.draw_texture(tex, Vector2(x, y), _draw_color())
	return 0


static func draw_background_ext(S, back: int, x: float, y: float, xscale: float,
		yscale: float, blend: Variant, color: Variant, alpha: float) -> Variant:
	if draw_ci == null:
		return 0
	var tex := _bg_texture(int(back))
	if tex == null:
		return 0
	var c := _gm_color(color)
	c.a *= clampf(float(alpha), 0.0, 1.0)
	draw_ci.draw_set_transform(Vector2(x, y) + _draw_offset(), 0.0,
		Vector2(float(xscale), float(yscale)))
	draw_ci.draw_texture(tex, Vector2.ZERO, c)
	_restore_xform()
	return 0


static func draw_background_stretched(S, back: int, x: float, y: float,
		w: float, h: float) -> Variant:
	return draw_background_stretched_ext(S, back, x, y, w, h, 0xFFFFFF, 1)


static func draw_background_stretched_ext(S, back: int, x: float, y: float,
		w: float, h: float, color: Variant, alpha: float) -> Variant:
	if draw_ci == null:
		return 0
	var tex := _bg_texture(int(back))
	if tex == null:
		return 0
	var c := _gm_color(color)
	c.a *= clampf(float(alpha), 0.0, 1.0)
	draw_ci.draw_texture_rect(tex, Rect2(x, y, w, h), false, c)
	return 0


static func draw_background_part_ext(S, back: int, left: float, top: float,
		width: float, height: float, x: float, y: float, xscale: float, yscale: float,
		color: Variant, alpha: float) -> Variant:
	if draw_ci == null:
		return 0
	var tex := _bg_texture(int(back))
	if tex == null:
		return 0
	var c := _gm_color(color)
	c.a *= clampf(float(alpha), 0.0, 1.0)
	draw_ci.draw_set_transform(Vector2(x, y) + _draw_offset(), 0.0,
		Vector2(float(xscale), float(yscale)))
	draw_ci.draw_texture_rect_region(tex, Rect2(0, 0, width, height),
		Rect2(left, top, width, height), c)
	_restore_xform()
	return 0


static func draw_rectangle(S, x1: float, y1: float, x2: float, y2: float,
		outline: Variant) -> Variant:
	if draw_ci == null:
		return 0
	var r := Rect2(Vector2(minf(x1, x2), minf(y1, y2)),
		Vector2(absf(x2 - x1) + 1, absf(y2 - y1) + 1))
	if bool(outline):
		draw_ci.draw_rect(r, _draw_color(), false, 1.0)
	else:
		draw_ci.draw_rect(r, _draw_color(), true)
	return 0


static func draw_clear_alpha(S, col: Variant, alpha: float) -> Variant:
	if draw_ci == null:
		return 0
	var c := _gm_color(col)
	c.a = clampf(float(alpha), 0.0, 1.0)
	var x: float = float(view_xview[0])
	var y: float = float(view_yview[0])
	draw_ci.draw_rect(Rect2(x, y, float(view_wview[0]), float(view_hview[0])), c, true)
	return 0


static func draw_surface_ext(S, surf: int, x: float, y: float, xscale: float,
		yscale: float, rot: float, color: Variant, alpha: float) -> Variant:
	if draw_ci == null or not surfaces.has(int(surf)):
		return 0
	var tex: Texture2D = surfaces[int(surf)].get("tex", null)
	if tex == null:
		return 0
	var c := _gm_color(color)
	c.a *= clampf(float(alpha), 0.0, 1.0)
	draw_ci.draw_set_transform(Vector2(x, y) + _draw_offset(), -deg_to_rad(float(rot)),
		Vector2(float(xscale), float(yscale)))
	draw_ci.draw_texture(tex, Vector2.ZERO, c)
	_restore_xform()
	return 0


# ---------------------------------------------------------------- text / fonts
static func font_add_sprite(S, spr: int, first: int, prop: Variant, sep: float) -> Variant:
	var id := next_font
	next_font += 1
	sprite_fonts[id] = {"spr": int(spr), "first": int(first),
		"prop": int(prop) != 0, "sep": float(sep)}
	return id


static func font_exists(S, id: Variant) -> Variant:
	return sprite_fonts.has(int(id))


static func _font() -> Font:
	return fallback_font if fallback_font != null else ThemeDB.fallback_font


static func _font_metrics(sf: Dictionary) -> Array:
	if sf.has("metrics"):
		return sf["metrics"]
	var info := sprite_info(int(sf["spr"]))
	var frames: Array = info["frames"]
	var prop: bool = bool(sf["prop"])
	var sep: int = int(sf["sep"])
	var out: Array = []
	for tex in frames:
		if tex == null:
			out.append(Vector2i(0, 0))
			continue
		var width: int = tex.get_width()
		var left := 0
		var adv: int = width + sep
		if prop:
			var img: Image = tex.get_image()
			if img != null:
				img = img.duplicate()
				img.convert(Image.FORMAT_RGBA8)
				var l: int = width
				var r := -1
				for x in width:
					for y in img.get_height():
						if int(img.get_pixel(x, y).a8) > 0:
							if x < l:
								l = x
							if x > r:
								r = x
							break
				if r >= 0:
					left = l
					# GM8 sprite fonts advance by the opaque width minus one plus sep.
					adv = r + sep - l
				else:
					adv = sep
		out.append(Vector2i(left, adv))
	sf["metrics"] = out
	return out


static func _glyph_width(sf: Dictionary, ch: String) -> float:
	var metrics: Array = _font_metrics(sf)
	var fi: int = ch.unicode_at(0) - int(sf["first"])
	if fi >= 0 and fi < metrics.size():
		return float((metrics[fi] as Vector2i).y)
	# Characters missing from the sprite font (e.g. space) advance like the first glyph.
	return float((metrics[0] as Vector2i).y) if not metrics.is_empty() else 8.0


static func _text_width(text: String) -> float:
	if (draw_font is int or draw_font is float) and sprite_fonts.has(int(draw_font)):
		var sf: Dictionary = sprite_fonts[int(draw_font)]
		var w := 0.0
		for ch in text:
			w += _glyph_width(sf, ch)
		return maxf(0.0, w)
	return _font().get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x


static func _text_height() -> float:
	if (draw_font is int or draw_font is float) and sprite_fonts.has(int(draw_font)):
		var info := sprite_info(int(sprite_fonts[int(draw_font)]["spr"]))
		return maxf(1.0, info["size"].y)
	return _font().get_height(16)


static func _draw_text_line(x: float, y: float, text: String, xs: float, ys: float,
		rot: float) -> void:
	var w := _text_width(text)
	var h := _text_height()
	var ox := 0.0
	if draw_halign == 1:
		ox = -w / 2.0
	elif draw_halign == 2:
		ox = -w
	var oy := 0.0
	if draw_valign == 1:
		oy = -h / 2.0
	elif draw_valign == 2:
		oy = -h
	draw_ci.draw_set_transform(Vector2(x, y) + _draw_offset(), -deg_to_rad(float(rot)),
		Vector2(xs, ys))
	if (draw_font is int or draw_font is float) and sprite_fonts.has(int(draw_font)):
		var sf: Dictionary = sprite_fonts[int(draw_font)]
		var info := sprite_info(int(sf["spr"]))
		var frames: Array = info["frames"]
		var metrics: Array = _font_metrics(sf)
		var cx := ox
		var col := _draw_color()
		for ch in text:
			var fi: int = ch.unicode_at(0) - int(sf["first"])
			if fi >= 0 and fi < frames.size() and frames[fi] != null:
				var mm: Vector2i = metrics[fi]
				draw_ci.draw_texture(frames[fi], Vector2(cx - mm.x, oy) - info["origin"], col)
				cx += float(mm.y)
			elif not metrics.is_empty():
				cx += float((metrics[0] as Vector2i).y)
	else:
		var col2 := _draw_color()
		draw_ci.draw_string(_font(), Vector2(ox, oy + _font().get_ascent(16)), text,
			HORIZONTAL_ALIGNMENT_LEFT, -1, 16, col2)
	_restore_xform()


static func draw_text(S, x: float, y: float, text: Variant) -> Variant:
	if draw_ci == null:
		return 0
	_draw_text_line(float(x), float(y), gm_string(S, text), 1.0, 1.0, 0.0)
	return 0


static func draw_text_transformed(S, x: float, y: float, text: Variant,
		xscale: float, yscale: float, rot: float) -> Variant:
	if draw_ci == null:
		return 0
	var s := gm_string(S, text)
	if draw_blend == 1 and draw_ci is GMInstance:
		(draw_ci as GMInstance).add_cmds.append([1, s, x, y, xscale, yscale, rot,
			draw_color, draw_alpha, draw_font, draw_halign, draw_valign])
		return 0
	_draw_text_line(float(x), float(y), s,
		float(xscale), float(yscale), float(rot))
	return 0


static func draw_text_ext_transformed(S, x: float, y: float, text: Variant,
		sep: float, w: float, xscale: float, yscale: float, rot: float) -> Variant:
	if draw_ci == null:
		return 0
	var s := gm_string(S, text)
	if draw_blend == 1 and draw_ci is GMInstance:
		(draw_ci as GMInstance).add_cmds.append([2, x, y, s, sep, w, xscale, yscale, rot,
			draw_color, draw_alpha, draw_font, draw_halign, draw_valign])
		return 0
	var max_w: float = float(w)
	var line_h: float = _text_height() + float(sep)
	if max_w <= 0:
		_draw_text_line(float(x), float(y), s, float(xscale), float(yscale), float(rot))
		return 0
	var line := ""
	var yy: float = float(y)
	for word in s.split(" "):
		var test := word if line.is_empty() else line + " " + word
		if _text_width(test) > max_w and not line.is_empty():
			_draw_text_line(float(x), yy, line, float(xscale), float(yscale), float(rot))
			yy += line_h * float(yscale)
			line = word
		else:
			line = test
	if not line.is_empty():
		_draw_text_line(float(x), yy, line, float(xscale), float(yscale), float(rot))
	return 0


# ---------------------------------------------------------------- input
static func _vk(keycode: int) -> int:
	match keycode:
		KEY_LEFT: return 37
		KEY_UP: return 38
		KEY_RIGHT: return 39
		KEY_DOWN: return 40
		KEY_ESCAPE: return 27
		KEY_ENTER, KEY_KP_ENTER: return 13
		KEY_SPACE: return 32
		KEY_TAB: return 9
		KEY_BACKSPACE: return 8
		KEY_SHIFT: return 16
		KEY_CTRL: return 17
		KEY_ALT: return 18
		KEY_CAPSLOCK: return 20
		KEY_INSERT: return 45
		KEY_DELETE: return 46
		KEY_HOME: return 36
		KEY_END: return 35
		KEY_PAGEUP: return 33
		KEY_PAGEDOWN: return 34
		KEY_F1: return 112
		KEY_F2: return 113
		KEY_F3: return 114
		KEY_F4: return 115
		KEY_F5: return 116
		KEY_F6: return 117
		KEY_F7: return 118
		KEY_F8: return 119
		KEY_F9: return 120
		KEY_F10: return 121
		KEY_F11: return 122
		KEY_F12: return 123
		KEY_KP_0: return 96
		KEY_KP_1: return 97
		KEY_KP_2: return 98
		KEY_KP_3: return 99
		KEY_KP_4: return 100
		KEY_KP_5: return 101
		KEY_KP_6: return 102
		KEY_KP_7: return 103
		KEY_KP_8: return 104
		KEY_KP_9: return 105
		KEY_KP_MULTIPLY: return 106
		KEY_KP_ADD: return 107
		KEY_KP_SUBTRACT: return 109
		KEY_KP_PERIOD: return 110
		KEY_KP_DIVIDE: return 111
		KEY_MINUS: return 189
		KEY_EQUAL: return 187
		KEY_BRACKETLEFT: return 219
		KEY_BRACKETRIGHT: return 221
		KEY_SEMICOLON: return 186
		KEY_APOSTROPHE: return 222
		KEY_COMMA: return 188
		KEY_PERIOD: return 190
		KEY_SLASH: return 191
		KEY_BACKSLASH: return 220
		KEY_QUOTELEFT: return 192
	if keycode >= 65 and keycode <= 90:
		return keycode
	if keycode >= 48 and keycode <= 57:
		return keycode
	return 0


static func handle_input(ev: InputEvent) -> void:
	if ev is InputEventKey:
		var k := _vk(ev.keycode)
		if k == 0:
			return
		if ev.pressed:
			if not keys_down.has(k):
				keys_pressed[k] = true
			keys_down[k] = true
			keyboard_lastkey = k
			keyboard_key = k
			if ev.unicode > 0 and keyboard_string.length() < 1024:
				keyboard_string += String.chr(ev.unicode)
		else:
			keys_down.erase(k)
			keys_released[k] = true
			if keyboard_key == k:
				keyboard_key = 0
	elif ev is InputEventMouseButton:
		var b := 0
		match ev.button_index:
			MOUSE_BUTTON_LEFT: b = 1
			MOUSE_BUTTON_RIGHT: b = 2
			MOUSE_BUTTON_MIDDLE: b = 3
			MOUSE_BUTTON_WHEEL_UP: mouse_wheel += 1
			MOUSE_BUTTON_WHEEL_DOWN: mouse_wheel -= 1
		if b > 0:
			if ev.pressed:
				mouse_down[b] = true
				mouse_pressed[b] = true
				mouse_lastbutton = b
				mouse_button = b
			else:
				mouse_down.erase(b)
				if mouse_button == b:
					mouse_button = 0


static func keyboard_check(S, key: int) -> Variant:
	# GM8: 0 = vk_nokey, 1 = vk_anykey.
	var k := int(key)
	if k == 1:
		return not keys_down.is_empty()
	if k == 0:
		return keys_down.is_empty()
	return keys_down.has(k)


static func keyboard_check_pressed(S, key: int) -> Variant:
	var k := int(key)
	if k == 1:
		return not keys_pressed.is_empty()
	if k == 0:
		return keys_pressed.is_empty()
	return keys_pressed.has(k)


static func keyboard_check_released(S, key: int) -> Variant:
	var k := int(key)
	if k == 1:
		return not keys_released.is_empty()
	if k == 0:
		return keys_released.is_empty()
	return keys_released.has(k)


static func keyboard_key_press(S, key: int) -> Variant:
	var k := int(key)
	if not keys_down.has(k):
		keys_pressed[k] = true
	keys_down[k] = true
	keyboard_lastkey = k
	return 0


static func keyboard_key_release(S, key: int) -> Variant:
	var k := int(key)
	keys_down.erase(k)
	keys_released[k] = true
	return 0


static func joystick_check_button(S, id: int, btn: int) -> Variant:
	var dev := maxi(0, int(id) - 1)
	if not Input.get_connected_joypads().has(dev):
		return false
	return Input.is_joy_button_pressed(dev, maxi(0, int(btn) - 1))


static func joystick_xpos(S, id: int) -> Variant:
	var dev := maxi(0, int(id) - 1)
	if not Input.get_connected_joypads().has(dev):
		return 0.0
	return Input.get_joy_axis(dev, JOY_AXIS_LEFT_X) * 1000.0


static func joystick_ypos(S, id: int) -> Variant:
	var dev := maxi(0, int(id) - 1)
	if not Input.get_connected_joypads().has(dev):
		return 0.0
	return Input.get_joy_axis(dev, JOY_AXIS_LEFT_Y) * 1000.0


static func mouse_check_button(S, btn: int) -> Variant:
	return mouse_down.has(int(btn))


static func mouse_check_button_pressed(S, btn: int) -> Variant:
	return mouse_pressed.has(int(btn))


static func mouse_check_button_released(S, btn: int) -> Variant:
	return false


# ---------------------------------------------------------------- particles
static func part_type_create(S) -> Variant:
	var id := next_part
	next_part += 1
	part_types[id] = {
		"shape": 0, "spr": -1, "anim": false, "stretch": false, "random": false,
		"size_min": 1.0, "size_max": 1.0, "size_incr": 0.0, "size_wiggle": 0.0,
		"xscale": 1.0, "yscale": 1.0,
		"speed_min": 0.0, "speed_max": 0.0, "speed_incr": 0.0, "speed_wiggle": 0.0,
		"dir_min": 0.0, "dir_max": 360.0, "dir_incr": 0.0, "dir_wiggle": 0.0,
		"orient_min": 0.0, "orient_max": 0.0, "orient_incr": 0.0, "orient_wiggle": 0.0,
		"orient_relative": false,
		"grav_amount": 0.0, "grav_dir": 270.0,
		"life_min": 100.0, "life_max": 100.0,
		"alpha1": 1.0, "alpha2": 1.0, "alpha3": 1.0,
		"color1": Color.WHITE, "color2": Color.WHITE, "color_mix": 0.0,
		"blend": false,
	}
	return id


static func _pt(id: int) -> Dictionary:
	return part_types.get(int(id), {})


static func part_type_shape(S, id: int, shape: int) -> Variant:
	if part_types.has(int(id)):
		part_types[int(id)]["shape"] = int(shape)
	return 0


static func part_type_sprite(S, id: int, spr: int, anim: Variant, stretch: Variant,
		random: Variant) -> Variant:
	if part_types.has(int(id)):
		var t: Dictionary = part_types[int(id)]
		t["spr"] = int(spr)
		t["anim"] = float(anim) != 0
		t["stretch"] = float(stretch) != 0
		t["random"] = float(random) != 0
	return 0


static func part_type_size(S, id: int, vmin: float, vmax: float, incr: float,
		wiggle = 0) -> Variant:
	if part_types.has(int(id)):
		var t: Dictionary = part_types[int(id)]
		t["size_min"] = float(vmin)
		t["size_max"] = float(vmax)
		t["size_incr"] = float(incr)
		t["size_wiggle"] = float(wiggle)
	return 0


static func part_type_scale(S, id: int, xs: float, ys: float) -> Variant:
	if part_types.has(int(id)):
		part_types[int(id)]["xscale"] = float(xs)
		part_types[int(id)]["yscale"] = float(ys)
	return 0


static func part_type_speed(S, id: int, vmin: float, vmax: float, incr: float,
		wiggle = 0) -> Variant:
	if part_types.has(int(id)):
		var t: Dictionary = part_types[int(id)]
		t["speed_min"] = float(vmin)
		t["speed_max"] = float(vmax)
		t["speed_incr"] = float(incr)
		t["speed_wiggle"] = float(wiggle)
	return 0


static func part_type_direction(S, id: int, vmin: float, vmax: float, incr: float,
		wiggle = 0) -> Variant:
	if part_types.has(int(id)):
		var t: Dictionary = part_types[int(id)]
		t["dir_min"] = float(vmin)
		t["dir_max"] = float(vmax)
		t["dir_incr"] = float(incr)
		t["dir_wiggle"] = float(wiggle)
	return 0


static func part_type_orientation(S, id: int, vmin: float, vmax: float, incr: float,
		wiggle: float, relative: Variant) -> Variant:
	if part_types.has(int(id)):
		var t: Dictionary = part_types[int(id)]
		t["orient_min"] = float(vmin)
		t["orient_max"] = float(vmax)
		t["orient_incr"] = float(incr)
		t["orient_wiggle"] = float(wiggle)
		t["orient_relative"] = float(relative) != 0
	return 0


static func part_type_gravity(S, id: int, amount: float, dir: float) -> Variant:
	if part_types.has(int(id)):
		part_types[int(id)]["grav_amount"] = float(amount)
		part_types[int(id)]["grav_dir"] = float(dir)
	return 0


static func part_type_life(S, id: int, vmin: float, vmax: float) -> Variant:
	if part_types.has(int(id)):
		part_types[int(id)]["life_min"] = float(vmin)
		part_types[int(id)]["life_max"] = float(vmax)
	return 0


static func part_type_alpha2(S, id: int, a1: float, a2: float) -> Variant:
	if part_types.has(int(id)):
		var t: Dictionary = part_types[int(id)]
		t["alpha1"] = float(a1)
		t["alpha2"] = float(a2)
		t["alpha3"] = float(a2)
	return 0


static func part_type_alpha3(S, id: int, a1: float, a2: float, a3: float) -> Variant:
	if part_types.has(int(id)):
		var t: Dictionary = part_types[int(id)]
		t["alpha1"] = float(a1)
		t["alpha2"] = float(a2)
		t["alpha3"] = float(a3)
	return 0


static func part_type_color1(S, id: int, c1: Variant) -> Variant:
	if part_types.has(int(id)):
		part_types[int(id)]["color1"] = _gm_color(c1)
	return 0


static func part_type_color_mix(S, id: int, c1: Variant, c2: Variant, mix: float = 0.5) -> Variant:
	if part_types.has(int(id)):
		var t: Dictionary = part_types[int(id)]
		t["color1"] = _gm_color(c1)
		t["color2"] = _gm_color(c2)
		t["color_mix"] = clampf(float(mix), 0.0, 1.0)
	return 0


static func part_type_blend(S, id: int, additive: Variant) -> Variant:
	if part_types.has(int(id)):
		part_types[int(id)]["blend"] = float(additive) != 0
	return 0


static func part_system_create(S) -> Variant:
	var id := next_part
	next_part += 1
	var node := GMParticleLayer.new()
	node.sys_id = id
	root.add_child(node)
	part_systems[id] = {"node": node, "automatic": true}
	return id


static func part_system_depth(S, id: int, depth: float) -> Variant:
	if part_systems.has(int(id)):
		part_systems[int(id)]["node"].z_index = clampi(-int(depth), -4096, 4096)
	return 0


static func part_system_automatic_update(S, id: int, automatic: Variant) -> Variant:
	if part_systems.has(int(id)):
		part_systems[int(id)]["automatic"] = float(automatic) != 0
	return 0


static func part_emitter_create(S, sys: int) -> Variant:
	var id := next_part
	next_part += 1
	part_emitters[id] = {"sys": int(sys), "xmin": 0.0, "xmax": 0.0,
		"ymin": 0.0, "ymax": 0.0, "shape": 0, "distrib": 0}
	return id


static func part_emitter_region(S, sys: int, emitter: int, xmin: float, xmax: float,
		ymin: float, ymax: float, shape: int, distrib: int) -> Variant:
	if part_emitters.has(int(emitter)):
		var e: Dictionary = part_emitters[int(emitter)]
		e["sys"] = int(sys)
		e["xmin"] = minf(xmin, xmax)
		e["xmax"] = maxf(xmin, xmax)
		e["ymin"] = minf(ymin, ymax)
		e["ymax"] = maxf(ymin, ymax)
		e["shape"] = int(shape)
		e["distrib"] = int(distrib)
	return 0


static func part_emitter_burst(S, sys: int, emitter: int, type_id: int, numb: int) -> Variant:
	if not part_emitters.has(int(emitter)):
		return 0
	var e: Dictionary = part_emitters[int(emitter)]
	for i in maxi(0, int(numb)):
		var x: float = randf_range(float(e["xmin"]), float(e["xmax"]))
		var y: float = randf_range(float(e["ymin"]), float(e["ymax"]))
		_spawn_particle(int(sys), int(type_id), x, y)
	return 0


static func part_particles_create(S, sys: int, type_id: int, x: float, y: float,
		numb: int) -> Variant:
	for i in maxi(0, int(numb)):
		_spawn_particle(int(sys), int(type_id), float(x), float(y))
	return 0


static func _spawn_particle(sys: int, type_id: int, x: float, y: float) -> void:
	var t := _pt(type_id)
	if t.is_empty():
		return
	var life: float = randf_range(float(t["life_min"]), float(t["life_max"]))
	var speed: float = randf_range(float(t["speed_min"]), float(t["speed_max"]))
	var dir: float = randf_range(float(t["dir_min"]), float(t["dir_max"]))
	var size: float = randf_range(float(t["size_min"]), float(t["size_max"]))
	var orient: float = randf_range(float(t["orient_min"]), float(t["orient_max"]))
	var col: Color = t["color1"]
	if float(t["color_mix"]) > 0:
		col = col.lerp(t["color2"], randf() * float(t["color_mix"]))
	var sub: float = 0.0
	if int(t["spr"]) >= 0 and t["random"]:
		sub = float(randi() % maxi(1, sprite_info(int(t["spr"]))["frames"].size()))
	live_particles.append({
		"sys": sys, "type": type_id, "x": x, "y": y,
		"speed": speed, "dir": dir, "size": size, "orient": orient,
		"age": 0.0, "life": maxf(1.0, life), "color": col, "sub": sub,
	})


static func _update_particles() -> void:
	var i := 0
	while i < live_particles.size():
		var p: Dictionary = live_particles[i]
		p["age"] = float(p["age"]) + 1.0
		if float(p["age"]) >= float(p["life"]):
			live_particles.remove_at(i)
			continue
		if int(p["sys"]) == -1:
			p["x"] = float(p["x"]) + cos(deg_to_rad(float(p["dir"]))) * float(p["speed"])
			p["y"] = float(p["y"]) - sin(deg_to_rad(float(p["dir"]))) * float(p["speed"])
			i += 1
			continue
		var sys: Dictionary = part_systems.get(int(p["sys"]), {})
		if sys.is_empty() or not sys.get("automatic", true):
			i += 1
			continue
		var t := _pt(int(p["type"]))
		if t.is_empty():
			live_particles.remove_at(i)
			continue
		p["speed"] = float(p["speed"]) + float(t.get("speed_incr", 0))
		p["dir"] = float(p["dir"]) + float(t.get("dir_incr", 0))
		p["size"] = maxf(0.0, float(p["size"]) + float(t.get("size_incr", 0)))
		p["orient"] = float(p["orient"]) + float(t.get("orient_incr", 0))
		var ga: float = float(t.get("grav_amount", 0))
		var vx: float = cos(deg_to_rad(float(p["dir"]))) * float(p["speed"])
		var vy: float = -sin(deg_to_rad(float(p["dir"]))) * float(p["speed"])
		if ga != 0:
			var gd: float = deg_to_rad(float(t.get("grav_dir", 270)))
			vx += cos(gd) * ga
			vy += -sin(gd) * ga
			p["speed"] = Vector2(vx, vy).length()
			p["dir"] = rad_to_deg(atan2(-vy, vx))
		p["x"] = float(p["x"]) + vx
		p["y"] = float(p["y"]) + vy
		if int(t["spr"]) >= 0 and t["anim"]:
			p["sub"] = float(p["sub"]) + 1.0
		i += 1
	for sys_id in part_systems:
		part_systems[sys_id]["node"].queue_redraw()
	if particle_node != null:
		particle_node.queue_redraw()


static func draw_particles(layer: Node2D, sys_id: int) -> void:
	for p in live_particles:
		if int(p["sys"]) != sys_id:
			continue
		var t := _pt(int(p["type"]))
		if t.is_empty():
			continue
		var frac: float = clampf(float(p["age"]) / float(p["life"]), 0.0, 1.0)
		var alpha: float
		if frac < 0.5:
			alpha = lerpf(float(t["alpha1"]), float(t["alpha2"]), frac * 2.0)
		else:
			alpha = lerpf(float(t["alpha2"]), float(t["alpha3"]), (frac - 0.5) * 2.0)
		var col: Color = p["color"]
		col.a *= clampf(alpha, 0.0, 1.0)
		if col.a <= 0.0:
			continue
		var pos := Vector2(float(p["x"]), float(p["y"]))
		var size: float = float(p["size"])
		if int(t["spr"]) >= 0:
			var info := sprite_info(int(t["spr"]))
			var frames: Array = info["frames"]
			if frames.is_empty():
				continue
			var fi: int = posmod(int(p["sub"]), frames.size())
			if frames[fi] == null:
				continue
			var orient: float = float(p["orient"])
			if t["orient_relative"]:
				orient += float(p["dir"])
			var sc := Vector2(float(t["xscale"]), float(t["yscale"]))
			if t["stretch"]:
				sc *= size
			layer.draw_set_transform(pos, -deg_to_rad(orient), sc)
			layer.draw_texture(frames[fi], -info["origin"], col)
			layer.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			continue
		match int(t["shape"]):
			0:
				layer.draw_rect(Rect2(pos, Vector2(maxf(1, size), maxf(1, size))), col, true)
			1:
				layer.draw_line(pos, pos + Vector2(size * 4, 0), col, 1.0)
			2, 3:
				layer.draw_rect(Rect2(pos - Vector2(size, size) / 2, Vector2(size, size)), col, true)
			5:
				layer.draw_circle(pos, maxf(0.5, size), col, false, 1.0)
			_:
				layer.draw_circle(pos, maxf(0.5, size), col, true)


static func effect_create_above(S, kind: int, x: float, y: float, size: float,
		color: Variant) -> Variant:
	var col := _gm_color(color)
	var count := clampi(int(size) * 8 + 4, 4, 60)
	for i in count:
		var dir := randf() * 360.0
		var speed := randf_range(0.5, 2.5) * maxf(0.5, float(size))
		live_particles.append({
			"sys": -1, "type": -1, "x": float(x), "y": float(y),
			"speed": speed, "dir": dir, "size": randf_range(1.0, 3.0) * maxf(0.5, float(size)),
			"orient": 0.0, "age": 0.0, "life": randf_range(15.0, 40.0),
			"color": col, "sub": 0.0, "effect": int(kind),
		})
	if particle_node != null:
		particle_node.queue_redraw()
	return 0


static func draw_effects(layer: Node2D) -> void:
	for p in live_particles:
		if int(p["sys"]) != -1:
			continue
		var frac: float = clampf(float(p["age"]) / float(p["life"]), 0.0, 1.0)
		var col: Color = p["color"]
		col.a *= 1.0 - frac
		if col.a <= 0:
			continue
		var pos := Vector2(float(p["x"]), float(p["y"]))
		layer.draw_circle(pos, maxf(0.5, float(p["size"]) * (1.0 - frac * 0.5)), col, true)


# ---------------------------------------------------------------- external calls (SXMS audio DLL)
static func external_define(S, dll: String, fname: String, calltype = 0, restype = 0,
		argcount = 0, t0 = null, t1 = null, t2 = null, t3 = null, t4 = null,
		t5 = null, t6 = null, t7 = null, t8 = null) -> Variant:
	var id := next_ext
	next_ext += 1
	ext_funcs[id] = fname
	return id


static func external_free(S, id: int) -> Variant:
	ext_funcs.erase(int(id))
	return 0


static func _load_stream(path: String) -> AudioStream:
	var p := _resolve_file(path)
	if not ResourceLoader.exists(p):
		warn("sound:" + p)
		return null
	var res: Variant = load(p)
	return res if res is AudioStream else null


static func _vol_db(v: float) -> float:
	return linear_to_db(clampf(float(v) / 255.0, 0.0, 1.0)) if float(v) > 0 else -80.0


static func _sfx_play(idx: int, vol: float, pan: float, loop: bool) -> void:
	var stream: AudioStream = sfx_bank.get(idx, null)
	if stream == null:
		return
	for p in sfx_players:
		if not p.playing:
			p.stream = stream
			p.volume_db = _vol_db(vol * sfx_master)
			p.set_meta("sfx_idx", idx)
			if stream is AudioStreamWAV:
				(stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_FORWARD if loop else AudioStreamWAV.LOOP_DISABLED
			p.play()
			return
	warn("sfx_pool_full")


static func external_call(S, id: int, a0: Variant = null, a1: Variant = null,
		a2: Variant = null, a3: Variant = null, a4: Variant = null, a5: Variant = null,
		a6: Variant = null, a7: Variant = null, a8: Variant = null,
		a9: Variant = null) -> Variant:
	var fname: String = str(ext_funcs.get(int(id), ""))
	match fname:
		"SXMS_I_Init":
			return 1
		"SXMS_I_Close", "SXMS_I_About":
			return 0
		"SXMS_SFX_Load":
			var stream := _load_stream(str(a1))
			if stream != null:
				sfx_bank[int(a0)] = stream
			return 1
		"SXMS_SFX_LoadBank":
			return 1
		"SXMS_SFX_Play":
			_sfx_play(int(a0), 255.0, 128.0, float(a1) != 0)
			return 1
		"SXMS_SFX_PlayExt":
			_sfx_play(int(a0), float(a2), float(a1), false)
			return 1
		"SXMS_SFX_Stop":
			for p in sfx_players:
				if p.has_meta("sfx_idx") and int(p.get_meta("sfx_idx")) == int(a0):
					p.stop()
			return 0
		"SXMS_SFX_Pause":
			for p in sfx_players:
				if p.has_meta("sfx_idx") and int(p.get_meta("sfx_idx")) == int(a0):
					p.stream_paused = float(a1) != 0
			return 0
		"SXMS_SFX_Volume", "SXMS_SFX_VolumeAbsolute":
			for p in sfx_players:
				if p.has_meta("sfx_idx") and int(p.get_meta("sfx_idx")) == int(a0):
					p.volume_db = _vol_db(float(a1))
			return 0
		"SXMS_SFX_MasterVolume":
			sfx_master = clampf(float(a0) / 255.0, 0.0, 1.0)
			return 0
		"SXMS_SFX_GetLength":
			var st: AudioStream = sfx_bank.get(int(a0), null)
			return st.get_length() * 1000.0 if st != null else 0
		"SXMS_SFX_Free":
			sfx_bank.erase(int(a0))
			return 0
		"SXMS_SFX_Name":
			return ""
		"SXMS_C_Play":
			var stream := _load_stream(str(a0))
			if stream == null:
				return 0
			if stream is AudioStreamMP3:
				(stream as AudioStreamMP3).loop = true
			elif stream is AudioStreamOggVorbis:
				(stream as AudioStreamOggVorbis).loop = true
			music_player.stream = stream
			music_player.volume_db = _vol_db(music_volume)
			music_player.play()
			music_path = str(a0)
			return 1
		"SXMS_C_Stop":
			music_player.stop()
			return 0
		"SXMS_C_Pause":
			music_player.stream_paused = float(a0) != 0
			return 0
		"SXMS_C_Loop":
			if music_player.stream is AudioStreamMP3:
				(music_player.stream as AudioStreamMP3).loop = float(a0) != 0
			elif music_player.stream is AudioStreamOggVorbis:
				(music_player.stream as AudioStreamOggVorbis).loop = float(a0) != 0
			return 0
		"SXMS_C_Volume":
			music_volume = clampf(float(a0), 0.0, 255.0)
			music_player.volume_db = _vol_db(music_volume)
			return 0
		"SXMS_C_IsPlaying":
			return 1 if music_player.playing else 0
		"SXMS_C_PercentComplete":
			if music_player.stream != null and music_player.stream.get_length() > 0:
				return music_player.get_playback_position() / music_player.stream.get_length() * 100.0
			return 0
		"SXMS_C_Time":
			return music_player.get_playback_position() * 1000.0
		"SXMS_C_Current":
			return music_path
		"SXMS_WAP_Init":
			return 0
		"SXMS_WAP_IsPlaying":
			return 0
		"SXMS_WAP_GetLength", "SXMS_WAP_GetOutputTime":
			return 0
	if fname.begins_with("SXMS_"):
		warn("sxms_noop:" + fname)
		return 0
	warn("external:" + fname)
	return 0


# ---------------------------------------------------------------- ds_map
static func ds_map_create(S) -> Variant:
	var id := next_ds
	next_ds += 1
	ds_maps[id] = {}
	return id


static func ds_map_destroy(S, id: int) -> Variant:
	ds_maps.erase(int(id))
	return 0


static func ds_map_add(S, id: int, key: Variant, val: Variant) -> Variant:
	if ds_maps.has(int(id)):
		ds_maps[int(id)][key] = val
	return 0


static func ds_map_find_value(S, id: int, key: Variant) -> Variant:
	var m: Dictionary = ds_maps.get(int(id), {})
	return m.get(key, 0)


static func ds_map_exists(S, id: int, key: Variant) -> Variant:
	var m: Dictionary = ds_maps.get(int(id), {})
	return m.has(key)


# ---------------------------------------------------------------- files
static func _user_path(fname: String) -> String:
	var p := fname.replace("\\", "/")
	if p.begins_with("user://") or p.begins_with("res://"):
		return p
	if p.length() > 1 and p[1] == ":":
		return p
	return working_directory.path_join(p)


static func file_exists(S, fname: String) -> Variant:
	return FileAccess.file_exists(_user_path(fname))


static func file_bin_open(S, fname: String, mode: int) -> Variant:
	var path := _user_path(fname)
	var fa: FileAccess = null
	match int(mode):
		0:
			fa = FileAccess.open(path, FileAccess.READ)
		1:
			fa = FileAccess.open(path, FileAccess.WRITE)
		_:
			if FileAccess.file_exists(path):
				fa = FileAccess.open(path, FileAccess.READ_WRITE)
			else:
				fa = FileAccess.open(path, FileAccess.WRITE)
	if fa == null:
		return -1
	var id := next_bin
	next_bin += 1
	bin_files[id] = fa
	return id


static func file_bin_close(S, id: int) -> Variant:
	if bin_files.has(int(id)):
		bin_files[int(id)].close()
		bin_files.erase(int(id))
	return 0


static func file_bin_read_byte(S, id: int) -> Variant:
	var fa: FileAccess = bin_files.get(int(id), null)
	if fa == null or fa.get_position() >= fa.get_length():
		return 0
	return fa.get_8()


static func file_bin_write_byte(S, id: int, val: int) -> Variant:
	var fa: FileAccess = bin_files.get(int(id), null)
	if fa != null:
		fa.store_8(int(val) & 255)
	return 0


static func file_bin_seek(S, id: int, pos: int) -> Variant:
	var fa: FileAccess = bin_files.get(int(id), null)
	if fa != null:
		fa.seek(clampi(int(pos), 0, int(fa.get_length())))
	return 0


static func file_bin_size(S, id: int) -> Variant:
	var fa: FileAccess = bin_files.get(int(id), null)
	return fa.get_length() if fa != null else 0


static var text_files: Dictionary = {}
static var next_text: int = 1


static func file_text_open_read(S, fname: String) -> Variant:
	var path := _user_path(fname)
	if not FileAccess.file_exists(path):
		return -1
	var content := FileAccess.get_file_as_string(path)
	var id := next_text
	next_text += 1
	text_files[id] = {"lines": content.split("\n"), "line": 0, "pos": 0}
	return id


static func file_text_eof(S, id: int) -> Variant:
	var f: Dictionary = text_files.get(int(id), {})
	if f.is_empty():
		return true
	return int(f["line"]) >= f["lines"].size()


static func file_text_read_string(S, id: int) -> Variant:
	var f: Dictionary = text_files.get(int(id), {})
	if f.is_empty() or int(f["line"]) >= f["lines"].size():
		return ""
	var line: String = str(f["lines"][int(f["line"])])
	var pos: int = int(f["pos"])
	while pos < line.length() and (line[pos] == " " or line[pos] == "\t" or line[pos] == "\r"):
		pos += 1
	var start := pos
	while pos < line.length() and line[pos] != " " and line[pos] != "\t" and line[pos] != "\r":
		pos += 1
	f["pos"] = pos
	return line.substr(start, pos - start)


static func file_text_readln(S, id: int) -> Variant:
	var f: Dictionary = text_files.get(int(id), {})
	if f.is_empty() or int(f["line"]) >= f["lines"].size():
		return ""
	var line: String = str(f["lines"][int(f["line"])])
	var rest := line.substr(int(f["pos"]))
	f["line"] = int(f["line"]) + 1
	f["pos"] = 0
	return rest


static func file_text_close(S, id: int) -> Variant:
	text_files.erase(int(id))
	return 0


static func ini_open(S, fname: String) -> Variant:
	ini_path = _user_path(fname)
	ini_data = {}
	var cf := ConfigFile.new()
	if cf.load(ini_path) == OK:
		for section in cf.get_sections():
			ini_data[section] = {}
			for key in cf.get_section_keys(section):
				ini_data[section][key] = cf.get_value(section, key)
	return 0


static func ini_read_real(S, section: String, key: String, default: float) -> Variant:
	var sec: Dictionary = ini_data.get(section, {})
	if sec.has(key):
		return float(sec[key])
	return float(default)


static func ini_write_real(S, section: String, key: String, val: float) -> Variant:
	if not ini_data.has(section):
		ini_data[section] = {}
	ini_data[section][key] = val
	return 0


static func ini_close(S) -> Variant:
	if ini_path.is_empty():
		return 0
	var cf := ConfigFile.new()
	for section in ini_data:
		for key in ini_data[section]:
			cf.set_value(section, key, ini_data[section][key])
	cf.save(ini_path)
	ini_path = ""
	return 0


# ---------------------------------------------------------------- tiles
static func _tile_layer(depth: float) -> Node2D:
	if tile_layers.has(depth):
		return tile_layers[depth]
	var node := GMTileLayer.new()
	node.layer_depth = depth
	node.z_index = _depth_z(depth)
	node.z_as_relative = false
	room_root.add_child(node)
	tile_layers[depth] = node
	return node


static func _tile_new(x: float, y: float, bg: int, tx: float, ty: float,
		w: float, h: float, depth: float, id: int) -> void:
	tiles[id] = {"x": x, "y": y, "bg": bg, "tx": tx, "ty": ty,
		"w": w, "h": h, "depth": depth, "alpha": 1.0, "blend": 0xFFFFFF}
	var node := _tile_layer(depth)
	node.queue_redraw()


static func tile_add(S, bg: int, left: float, top: float, width: float, height: float,
		x: float, y: float, depth: float) -> Variant:
	var id := next_tile
	next_tile += 1
	_tile_new(float(x), float(y), int(bg), float(left), float(top),
		float(width), float(height), float(depth), id)
	return id


static func tile_delete(S, id: int) -> Variant:
	if tiles.has(int(id)):
		var depth: float = tiles[int(id)]["depth"]
		tiles.erase(int(id))
		if tile_layers.has(depth):
			tile_layers[depth].queue_redraw()
	return 0


static func tile_exists(S, id: int) -> Variant:
	return tiles.has(int(id))


static func tile_get_x(S, id: int) -> Variant:
	return tiles.get(int(id), {}).get("x", 0)


static func tile_get_y(S, id: int) -> Variant:
	return tiles.get(int(id), {}).get("y", 0)


static func tile_get_width(S, id: int) -> Variant:
	return tiles.get(int(id), {}).get("w", 0)


static func tile_get_height(S, id: int) -> Variant:
	return tiles.get(int(id), {}).get("h", 0)


static func tile_get_depth(S, id: int) -> Variant:
	return tiles.get(int(id), {}).get("depth", 0)


static func tile_set_alpha(S, id: int, alpha: float) -> Variant:
	if tiles.has(int(id)):
		tiles[int(id)]["alpha"] = clampf(float(alpha), 0.0, 1.0)
		var depth: float = tiles[int(id)]["depth"]
		if tile_layers.has(depth):
			tile_layers[depth].queue_redraw()
	return 0


static func tile_set_blend(S, id: int, blend: Variant) -> Variant:
	if tiles.has(int(id)):
		tiles[int(id)]["blend"] = blend
		var depth: float = tiles[int(id)]["depth"]
		if tile_layers.has(depth):
			tile_layers[depth].queue_redraw()
	return 0


static func tile_layer_find(S, depth: float, x: float = 0, y: float = 0) -> Variant:
	var p := Vector2(x, y)
	for id in tiles:
		var t: Dictionary = tiles[id]
		if float(t["depth"]) != float(depth):
			continue
		if Rect2(float(t["x"]), float(t["y"]), float(t["w"]), float(t["h"])).has_point(p):
			return id
	return -1


static func draw_tiles_at(layer: Node2D, depth: float) -> void:
	for id in tiles:
		var t: Dictionary = tiles[id]
		if float(t["depth"]) != depth:
			continue
		var tex := _bg_texture(int(t["bg"]))
		if tex == null:
			continue
		var c := _gm_color(t["blend"])
		c.a = float(t["alpha"])
		layer.draw_texture_rect_region(tex,
			Rect2(float(t["x"]), float(t["y"]), float(t["w"]), float(t["h"])),
			Rect2(float(t["tx"]), float(t["ty"]), float(t["w"]), float(t["h"])), c)


static func draw_bg_layer(layer: Node2D, front: bool) -> void:
	if not view_enabled and room < 0:
		return
	var vx: float = float(view_xview[0])
	var vy: float = float(view_yview[0])
	var vw: float = float(view_wview[0])
	var vh: float = float(view_hview[0])
	for i in 8:
		if not bg_visible[i] or bool(bg_foreground[i]) != front:
			continue
		var tex := _bg_texture(int(bg_index[i]))
		if tex == null:
			continue
		var c := Color(1, 1, 1, clampf(float(bg_alpha[i]), 0.0, 1.0))
		# background_x/y are room coordinates; the canvas transform already
		# subtracts the view, so no view offset is added here.
		var bx: float = float(bg_x[i])
		var by: float = float(bg_y[i])
		var ts: Vector2 = tex.get_size() * Vector2(float(bg_xscale[i]), float(bg_yscale[i]))
		if ts.x <= 0.0 or ts.y <= 0.0:
			continue
		var ht: bool = bool(bg_htiled[i])
		var vt: bool = bool(bg_vtiled[i])
		# Tile only along the enabled axes: a horizontal-only layer is a single
		# band at background_y, as in GameMaker.
		var x0: float = bx + floorf((vx - bx) / ts.x) * ts.x if ht else bx
		var y0: float = by + floorf((vy - by) / ts.y) * ts.y if vt else by
		var x1: float = vx + vw if ht else bx + ts.x
		var y1: float = vy + vh if vt else by + ts.y
		var yy: float = y0
		while yy < y1:
			var xx: float = x0
			while xx < x1:
				layer.draw_texture_rect(tex, Rect2(xx, yy, ts.x, ts.y), false, c)
				xx += ts.x
			yy += ts.y


# ---------------------------------------------------------------- surfaces
static var next_surface: int = 1


static func surface_create(S, w: int, h: int) -> Variant:
	var id := next_surface
	next_surface += 1
	surfaces[id] = {"w": maxi(1, int(w)), "h": maxi(1, int(h)), "tex": null}
	return id


static func surface_free(S, id: int) -> Variant:
	surfaces.erase(int(id))
	return 0


static func surface_set_target(S, id: int) -> Variant:
	return 0


static func surface_reset_target(S) -> Variant:
	return 0


static func surface_save(S, id: int, fname: String) -> Variant:
	if not surfaces.has(int(id)):
		return 0
	warn("surface_save_approx")
	var info: Dictionary = surfaces[int(id)]
	var img := Image.create(int(info["w"]), int(info["h"]), false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	img.save_png(_user_path(fname))
	return 1


# ---------------------------------------------------------------- paths
static var next_path: int = 1
static var path_origins: Dictionary = {}


static func path_add(S) -> Variant:
	var id := next_path
	next_path += 1
	paths[id] = {"points": [], "closed": false, "kind": 0, "precision": 4}
	return id


static func path_add_point(S, id: int, x: float, y: float, speed: float) -> Variant:
	if paths.has(int(id)):
		paths[int(id)]["points"].append(Vector3(x, y, speed))
	return 0


static func path_set_closed(S, id: int, closed: Variant) -> Variant:
	if paths.has(int(id)):
		paths[int(id)]["closed"] = float(closed) != 0
	return 0


static func path_set_kind(S, id: int, kind: int) -> Variant:
	if paths.has(int(id)):
		paths[int(id)]["kind"] = int(kind)
	return 0


static func path_set_precision(S, id: int, prec: int) -> Variant:
	if paths.has(int(id)):
		paths[int(id)]["precision"] = int(prec)
	return 0


static func path_start(S, id: int, speed: float, endaction: int, absolute: Variant) -> Variant:
	if not paths.has(int(id)) or S == null:
		return 0
	S.g_path_index = int(id)
	S.g_path_position = 0.0
	S.g_path_speed = float(speed)
	S.g_path_endaction = int(endaction)
	var pts: Array = paths[int(id)]["points"]
	if pts.size() > 0:
		if float(absolute) != 0:
			S.position = Vector2(pts[0].x, pts[0].y)
			path_origins[S.inst_id] = Vector2.ZERO
		else:
			path_origins[S.inst_id] = S.position - Vector2(pts[0].x, pts[0].y)
	return 0


static func _path_length(pts: Array, closed: bool) -> float:
	var total := 0.0
	for i in pts.size() - 1:
		total += Vector2(pts[i].x, pts[i].y).distance_to(Vector2(pts[i + 1].x, pts[i + 1].y))
	if closed and pts.size() > 1:
		total += Vector2(pts[-1].x, pts[-1].y).distance_to(Vector2(pts[0].x, pts[0].y))
	return total


static func _path_point(pts: Array, closed: bool, frac: float) -> Vector2:
	var total := _path_length(pts, closed)
	if total <= 0 or pts.is_empty():
		return Vector2(pts[0].x, pts[0].y) if pts.size() > 0 else Vector2.ZERO
	var want := frac * total
	var count := pts.size() if closed else pts.size() - 1
	for i in count:
		var a := Vector2(pts[i].x, pts[i].y)
		var b := Vector2(pts[(i + 1) % pts.size()].x, pts[(i + 1) % pts.size()].y)
		var seg := a.distance_to(b)
		if want <= seg:
			return a.lerp(b, want / seg if seg > 0 else 0.0)
		want -= seg
	return Vector2(pts[-1].x, pts[-1].y)


static func _path_move(inst: GMInstance) -> void:
	var p: Dictionary = paths.get(int(inst.g_path_index), {})
	if p.is_empty():
		inst.g_path_index = -1
		return
	var pts: Array = p["points"]
	if pts.size() < 2:
		return
	var total := _path_length(pts, bool(p["closed"]))
	if total <= 0:
		return
	var pos: float = float(inst.g_path_position) + float(inst.g_path_speed) / total
	if pos >= 1.0 or pos < 0.0:
		match int(inst.g_path_endaction):
			0:
				inst.g_path_index = -1
				inst.g_path_position = clampf(pos, 0.0, 1.0)
				return
			1:
				pos = fposmod(pos, 1.0)
			2:
				inst.g_path_speed = -float(inst.g_path_speed)
				pos = clampf(pos, 0.0, 1.0)
			_:
				pos = 0.0
	inst.g_path_position = pos
	var origin: Vector2 = path_origins.get(inst.inst_id, Vector2.ZERO)
	inst.position = origin + _path_point(pts, bool(p["closed"]), pos)
	_mark_moved(int(inst.g_object_index))


# ---------------------------------------------------------------- window / display
static func window_get_width(S) -> Variant:
	return DisplayServer.window_get_size().x


static func window_get_height(S) -> Variant:
	return DisplayServer.window_get_size().y


static func display_get_width(S) -> Variant:
	return DisplayServer.screen_get_size().x


static func display_get_height(S) -> Variant:
	return DisplayServer.screen_get_size().y


static func window_set_size(S, w: int, h: int) -> Variant:
	DisplayServer.window_set_size(Vector2i(maxi(1, int(w)), maxi(1, int(h))))
	return 0


static func window_set_position(S, x: int, y: int) -> Variant:
	DisplayServer.window_set_position(Vector2i(int(x), int(y)))
	return 0


static func window_set_fullscreen(S, full: Variant) -> Variant:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if float(full) != 0
		else DisplayServer.WINDOW_MODE_WINDOWED)
	return 0


static func window_set_visible(S, vis: Variant) -> Variant:
	root.get_window().visible = float(vis) != 0
	return 0


static func window_set_fixed(S, fixed: Variant) -> Variant:
	return 0


static func window_set_region_size(S, w: int, h: int, interpolate = 0) -> Variant:
	return 0


static func window_handle(S) -> Variant:
	return 1


static func window_has_focus(S) -> Variant:
	return DisplayServer.window_is_focused()


# ---------------------------------------------------------------- misc builtins
static func game_end(S) -> Variant:
	game_running = false
	if root != null:
		root.get_tree().quit()
	return 0


static func show_message(S, msg: Variant) -> Variant:
	OS.alert(gm_string(S, msg), "NSMF")
	return 0


static func get_string(S, prompt: Variant, default: Variant) -> Variant:
	return default


static func execute_shell(S, cmd: String, wait: Variant) -> Variant:
	OS.shell_open(cmd)
	return 0


static func execute_program(S, prog: String, args: String, wait: Variant) -> Variant:
	var path := prog
	if not FileAccess.file_exists(path):
		path = program_directory.path_join(prog)
	if not FileAccess.file_exists(path):
		warn("execute_program:" + prog)
		return 0
	OS.create_process(path, args.split(" ", false))
	return 0


static func execute_string(S, gml: String) -> Variant:
	warn("execute_string")
	return 0


static func screen_refresh(S) -> Variant:
	return 0


static func script_execute(S, scr: Variant, a0: Variant = null, a1: Variant = null,
		a2: Variant = null, a3: Variant = null) -> Variant:
	if scr is Array:
		if scr.is_empty():
			return 0
		scr = Callable(REG.part(int(scr[0])), str(scr[1]))
	if scr is Callable and scr.is_valid():
		var args: Array = []
		for a in [a0, a1, a2, a3]:
			if a != null:
				args.append(a)
		return scr.call(S, args)
	return 0


static func event_perform(S, main: int, sub: int) -> Variant:
	if S is GMInstance:
		run_event(S, int(main), int(sub))
	return 0


static func background_add(S, fname: String, removeback = 0, smooth = 0) -> Variant:
	var tex := _load_texture(_resolve_file(fname))
	var idx := next_bg
	next_bg += 1
	backgrounds[idx] = {"paths": [], "tex": tex, "loaded": true, "name": fname}
	return idx