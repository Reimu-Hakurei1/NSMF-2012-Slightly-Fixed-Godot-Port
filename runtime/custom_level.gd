extends RefCounted

const ROOM_ID := 1000000

static func number(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value))

static func validate(value: Variant) -> Dictionary:
	if not value is Dictionary or value.get("version") != 1 or not number(value.get("template")):
		return {}
	var template := int(value.template)
	if not R.room_data.rooms.has(str(template)) or not value.get("room") is Dictionary:
		return {}
	var supplied: Dictionary = value.room
	if not supplied.get("name") is String or supplied.name.length() > 100:
		return {}
	for key in ["w", "h"]:
		if not number(supplied.get(key)) or float(supplied[key]) < (800 if key == "w" else 600) or float(supplied[key]) > 100000:
			return {}
	for key in ["instances", "tiles"]:
		if not supplied.get(key) is Array or supplied[key].size() > 20000:
			return {}
	var ids: Dictionary = {}
	for entry in supplied.instances:
		if not entry is Array or entry.size() != 4:
			return {}
		for item in entry:
			if not number(item) or absf(float(item)) > 1000000000:
				return {}
		if not R.objects.has(int(entry[2])) or int(entry[3]) < 0 or ids.has(int(entry[3])):
			return {}
		ids[int(entry[3])] = true
	for entry in supplied.tiles:
		if not entry is Array or entry.size() != 9:
			return {}
		for item in entry:
			if not number(item) or absf(float(item)) > 1000000000:
				return {}
		if not R.backgrounds.has(int(entry[2])) or entry[3] < 0 or entry[4] < 0 or entry[5] <= 0 or entry[6] <= 0 or entry[5] > 16384 or entry[6] > 16384:
			return {}
	var decorations: Variant = value.get("decorations", [])
	if not decorations is Array or decorations.size() > 20000:
		return {}
	for entry in decorations:
		if not entry is Array or entry.size() != 4:
			return {}
		for item in entry:
			if not number(item) or absf(float(item)) > 1000000000:
				return {}
		if not R.sprites.has(int(entry[2])):
			return {}
	var room: Dictionary = R.room_data.rooms[str(template)].duplicate(true)
	for key in ["name", "w", "h", "instances", "tiles"]:
		room[key] = supplied[key].duplicate(true) if supplied[key] is Array else supplied[key]
	if number(supplied.get("editor_music", 0)):
		room.editor_music = clampi(int(supplied.get("editor_music", 0)), 0, 132)
	else:
		return {}
	var background: Variant = supplied.get("editor_background", -1)
	if not number(background) or (int(background) != -1 and not R.backgrounds.has(int(background))):
		return {}
	room.editor_background = int(background)
	room.persistent = 0
	return {"version": 1, "template": template, "room": room, "decorations": decorations.duplicate(true)}

static func read_document(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null or file.get_length() > 16000000:
		return {}
	return validate(JSON.parse_string(file.get_as_text()))

static func install(document: Dictionary) -> bool:
	var valid := validate(document)
	if valid.is_empty():
		return false
	var template: int = valid.template
	var meta: Dictionary = valid.room.duplicate(true)
	meta.editor_decorations = valid.decorations
	if int(meta.get("editor_background", -1)) >= 0:
		meta.backgrounds[0].source_bg = int(meta.editor_background)
		meta.backgrounds[0].visible = 1
	R.room_data.rooms[str(ROOM_ID)] = meta
	if R.registry.room_create.has(str(template)):
		R.registry.room_create[str(ROOM_ID)] = R.registry.room_create[str(template)]
	for entry in meta.instances:
		var key := "%d:%d" % [template, int(entry[3])]
		if R.registry.inst_create.has(key):
			R.registry.inst_create["%d:%d" % [ROOM_ID, int(entry[3])]] = R.registry.inst_create[key]
	R._load_room(ROOM_ID)
	R.pending_room = null
	var globals = load("res://gen/globals.gd")
	globals.pauza = 0
	globals.blokuj_ruch_na_title_screenie = 0
	globals.title_screen_activated = 0
	globals.wychodz_z_rury_nastepny_etap = 0
	globals.level_music = int(meta.get("editor_music", 0))
	globals.zostaw_ta_sama_muzyke_w_nast_etapie = 8714917489
	R.view_enabled = true
	R.view_visible[0] = true
	for player in R.with_ids(null, 303):
		player.g_block_sterring = 0
		player.g_timer_skrot = 0
		player.g_music_tick_level = 0
	return true
