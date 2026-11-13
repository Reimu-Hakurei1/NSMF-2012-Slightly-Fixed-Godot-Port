extends CanvasLayer
## Standalone, static document editor. The host owns pausing and playtest installation.
signal closed
signal playtest_requested(document: Dictionary)

const Documents = preload("res://runtime/custom_level.gd")
const SAVE_DIR := "user://custom_editor"
const COMMON := [303, 1, 288]
var document: Dictionary = {}
var _saved := ""
var _undo: Array[Dictionary] = []
var _redo: Array[Dictionary] = []
var _before: Dictionary = {}
var _root: Control
var _canvas: Control
var _status: Label
var _search: LineEdit
var _palette: ItemList
var _category: OptionButton
var _templates: OptionButton
var _name: LineEdit
var _width: SpinBox
var _height: SpinBox
var _grid: SpinBox
var _snap: CheckBox
var _tool: OptionButton
var _tile_x: SpinBox
var _tile_y: SpinBox
var _tile_w: SpinBox
var _tile_h: SpinBox
var _depth: SpinBox
var _files: ItemList
var _filename: LineEdit
var _file_dialog: ConfirmationDialog
var _discard: ConfirmationDialog
var _pending: Callable
var _saving := false
var _syncing := false
var _asset := -1
var _selection: Array = []
var _pan := Vector2(24, 24)
var _zoom := 1.0
var _drag := false
var _panning := false
var _drag_start := Vector2.ZERO
var _original_position := Vector2.ZERO
var _last_cell := Vector2(INF, INF)
var _textures: Dictionary = {}

func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	_root.hide()

func open_editor() -> void:
	if _root == null:
		_build_ui()
	if R.room_data.get("rooms", {}).is_empty():
		_status.text = "Runtime assets are not initialized."
		_root.show()
		return
	_populate_templates()
	if document.is_empty():
		_new_starter()
		# Containers have not laid out the canvas on its first opening yet.
		call_deferred("_fit")
	_refresh_palette()
	_root.show()
	_sync_controls()
	_canvas.queue_redraw()

func _button(parent: Node, text: String, action: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.pressed.connect(action)
	parent.add_child(button)
	return button

func _spin(parent: Node, minimum: float, maximum: float, value: float) -> SpinBox:
	var spin := SpinBox.new()
	spin.min_value = minimum
	spin.max_value = maximum
	spin.value = value
	spin.custom_minimum_size.x = 72
	parent.add_child(spin)
	return spin

func _label(parent: Node, text: String) -> void:
	var label := Label.new()
	label.text = text
	parent.add_child(label)

func _build_ui() -> void:
	if _root != null:
		return
	_root = PanelContainer.new()
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_root)
	var layout := VBoxContainer.new()
	_root.add_child(layout)
	var top := HBoxContainer.new()
	layout.add_child(top)
	_button(top, "New", func(): _guard(_new_starter))
	_button(top, "Template", func(): _guard(_from_template))
	_button(top, "Save", func(): _show_files(true))
	_button(top, "Load", func(): _guard(func(): _show_files(false)))
	_button(top, "Undo", _undo_edit)
	_button(top, "Redo", _redo_edit)
	_button(top, "F5 Play", _playtest)
	_button(top, "Close", func(): _guard(_close))
	var meta := HBoxContainer.new()
	layout.add_child(meta)
	_name = LineEdit.new()
	_name.placeholder_text = "Room name"
	_name.max_length = 100
	_name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	meta.add_child(_name)
	_name.text_submitted.connect(func(_text): _apply_metadata())
	_name.focus_exited.connect(_apply_metadata)
	_label(meta, "W")
	_width = _spin(meta, 800, 100000, 1600)
	_label(meta, "H")
	_height = _spin(meta, 600, 100000, 600)
	_button(meta, "Apply size", _apply_metadata)
	_templates = OptionButton.new()
	_templates.custom_minimum_size.x = 170
	_templates.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var template_row := HBoxContainer.new()
	layout.add_child(template_row)
	_label(template_row, "Read-only source template")
	template_row.add_child(_templates)
	var tools := HBoxContainer.new()
	layout.add_child(tools)
	_tool = OptionButton.new()
	for text in ["Paint", "Erase", "Select / move"]:
		_tool.add_item(text)
	tools.add_child(_tool)
	_snap = CheckBox.new()
	_snap.text = "Snap"
	_snap.button_pressed = true
	tools.add_child(_snap)
	_grid = _spin(tools, 1, 256, 32)
	_button(tools, "Fit", _fit)
	var art_tools := HBoxContainer.new()
	layout.add_child(art_tools)
	_label(art_tools, "Tile X/Y W/H:")
	_tile_x = _spin(art_tools, 0, 16384, 0)
	_tile_y = _spin(art_tools, 0, 16384, 0)
	_tile_w = _spin(art_tools, 1, 16384, 32)
	_tile_h = _spin(art_tools, 1, 16384, 32)
	_label(art_tools, "Depth")
	_depth = _spin(art_tools, -1000000, 1000000, 100)
	var body := HSplitContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(body)
	var left := VBoxContainer.new()
	left.custom_minimum_size.x = 220
	body.add_child(left)
	_category = OptionButton.new()
	for text in ["Common objects", "All objects (advanced)", "Decorations / sprites", "Tiles / backgrounds"]:
		_category.add_item(text)
	left.add_child(_category)
	_category.item_selected.connect(func(_index): _refresh_palette())
	_search = LineEdit.new()
	_search.placeholder_text = "Search name or ID"
	left.add_child(_search)
	_search.text_changed.connect(func(_text): _refresh_palette())
	_palette = ItemList.new()
	_palette.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_palette.fixed_icon_size = Vector2i(32, 32)
	left.add_child(_palette)
	_palette.item_selected.connect(func(index): _asset = int(_palette.get_item_metadata(index)))
	_canvas = Control.new()
	_canvas.custom_minimum_size = Vector2(240, 200)
	_canvas.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_canvas.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_canvas.clip_contents = true
	_canvas.mouse_filter = Control.MOUSE_FILTER_STOP
	_canvas.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	body.add_child(_canvas)
	_canvas.draw.connect(_draw_canvas)
	_canvas.gui_input.connect(_canvas_input)
	_status = Label.new()
	_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status.custom_minimum_size.y = 36
	_status.text = "Middle drag: pan | Wheel: zoom | Right click: erase | Delete: remove selection | Ctrl+Z/Y/S | F5"
	layout.add_child(_status)
	_discard = ConfirmationDialog.new()
	_discard.dialog_text = "Discard unsaved changes?"
	_discard.confirmed.connect(func():
		var action := _pending
		_pending = Callable()
		if action.is_valid(): action.call())
	add_child(_discard)
	_file_dialog = ConfirmationDialog.new()
	_file_dialog.title = "Custom editor JSON files"
	var file_box := VBoxContainer.new()
	_file_dialog.add_child(file_box)
	_label(file_box, "Only user://custom_editor/*.json is accessible.")
	_files = ItemList.new()
	_files.custom_minimum_size = Vector2(420, 220)
	file_box.add_child(_files)
	_filename = LineEdit.new()
	_filename.placeholder_text = "my_level.json"
	file_box.add_child(_filename)
	_files.item_selected.connect(func(index): _filename.text = _files.get_item_text(index))
	_file_dialog.confirmed.connect(_file_confirmed)
	add_child(_file_dialog)

func _populate_templates() -> void:
	_templates.clear()
	var ids: Array = R.room_data.rooms.keys()
	ids.sort_custom(func(a, b): return int(a) < int(b))
	for key in ids:
		if int(key) == Documents.ROOM_ID: continue
		_templates.add_item("%s: %s" % [key, R.room_data.rooms[key].name], int(key))
		if int(key) == 264: _templates.select(_templates.item_count - 1)

func _new_starter() -> void:
	if not R.room_data.get("rooms", {}).has("264"): return
	var room: Dictionary = R.room_data.rooms["264"].duplicate(true)
	room.name = "My new level"
	room.w = 1600
	room.h = 600
	room.instances = [[96, 480, 303, 900000001], [1472, 480, 288, 900000002]]
	for x in range(0, 1600, 32):
		room.instances.append([x, 544, 1, 900000003 + x / 32])
	room.tiles = []
	room.editor_music = 0
	room.editor_background = -1
	_set_document({"version": 1, "template": 264, "room": room, "decorations": []}, false)
	_fit()

func _from_template() -> void:
	if _templates.selected < 0: return
	var id := _templates.get_selected_id()
	_set_document({"version": 1, "template": id, "room": R.room_data.rooms[str(id)].duplicate(true), "decorations": []}, false)
	_fit()

func _set_document(value: Dictionary, saved: bool) -> void:
	var valid: Dictionary = Documents.validate(value)
	if valid.is_empty():
		_status.text = "Invalid level document; nothing changed."
		return
	document = valid
	_saved = JSON.stringify(document) if saved else ""
	_undo.clear()
	_redo.clear()
	_selection.clear()
	_sync_controls()
	_canvas.queue_redraw()

func _sync_controls() -> void:
	if document.is_empty(): return
	_syncing = true
	_name.text = document.room.name
	_width.value = document.room.w
	_height.value = document.room.h
	_syncing = false

func _apply_metadata() -> void:
	if _syncing or document.is_empty(): return
	if document.room.name == _name.text and document.room.w == _width.value and document.room.h == _height.value: return
	_begin_edit()
	document.room.name = _name.text
	document.room.w = int(_width.value)
	document.room.h = int(_height.value)
	_end_edit()

func _begin_edit() -> void:
	_before = document.duplicate(true)

func _end_edit() -> void:
	if not _before.is_empty() and _before != document:
		_undo.append(_before)
		if _undo.size() > 100: _undo.pop_front()
		_redo.clear()
	_before = {}
	_canvas.queue_redraw()

func _undo_edit() -> void:
	_finish_drag()
	if _undo.is_empty(): return
	_redo.append(document.duplicate(true))
	document = _undo.pop_back()
	_selection.clear()
	_sync_controls()
	_canvas.queue_redraw()

func _redo_edit() -> void:
	_finish_drag()
	if _redo.is_empty(): return
	_undo.append(document.duplicate(true))
	document = _redo.pop_back()
	_selection.clear()
	_sync_controls()
	_canvas.queue_redraw()

func _guard(action: Callable) -> void:
	_finish_drag()
	_apply_metadata()
	if not document.is_empty() and JSON.stringify(document) != _saved:
		_pending = action
		_discard.dialog_text = "Discard unsaved changes?"
		_discard.popup_centered()
	else:
		action.call()

func _close() -> void:
	_root.hide()
	closed.emit()

func _playtest() -> void:
	_finish_drag()
	_apply_metadata()
	var valid: Dictionary = Documents.validate(document)
	if valid.is_empty():
		_status.text = "Cannot play: invalid document."
		return
	_root.hide()
	playtest_requested.emit(valid.duplicate(true))

func _sprite_id(object_id: int) -> int:
	return int(R.objects.get(object_id, {}).get("sprite", -1))

func _texture(kind: String, id: int) -> Texture2D:
	var key := "%s:%d" % [kind, id]
	if _textures.has(key): return _textures[key]
	var texture: Texture2D = null
	if kind == "background":
		texture = R._bg_texture(id)
	elif R.sprites.has(id):
		# Load only frame zero, not every animation frame in a large palette.
		var sprite: Dictionary = R.sprites[id]
		var frames: Array = sprite.get("frames", [])
		if not frames.is_empty(): texture = frames[0]
		elif not sprite.get("paths", []).is_empty(): texture = R._load_texture(str(sprite.paths[0]))
	_textures[key] = texture
	return texture

func _refresh_palette() -> void:
	_palette.clear()
	_asset = -1
	var mode := _category.selected
	var source: Dictionary = R.objects if mode < 2 else (R.sprites if mode == 2 else R.backgrounds)
	var ids: Array = source.keys()
	ids.sort()
	var query := _search.text.strip_edges().to_lower()
	for key in ids:
		var id := int(key)
		# Startup also creates transient runtime sprites/backgrounds, not source assets.
		if mode == 2 and not R.assets.sprites.has(str(id)): continue
		if mode == 3 and not R.assets.backgrounds.has(str(id)): continue
		var name := str(source[key].get("name", source[key].get("n", "unnamed")))
		var friendly := "Mario" if id == 303 else ("Solid ground" if id == 1 else ("Goal" if id == 288 else name))
		if mode == 0 and not (id in COMMON or name.to_lower().contains("goomba") or name.to_lower().contains("coin") or name.to_lower().contains("koopa") or name.to_lower().contains("brick")): continue
		var text := "%d  %s" % [id, friendly if mode == 0 else name]
		if not query.is_empty() and not (text + " " + name).to_lower().contains(query): continue
		var texture := _texture("background" if mode == 3 else "sprite", _sprite_id(id) if mode < 2 else id)
		var index := _palette.add_item(text, texture)
		_palette.set_item_metadata(index, id)
		_palette.set_item_tooltip(index, "%s\nID %d — %s" % [name, id, "Gameplay object (advanced objects may require room scripts)" if mode < 2 else "Static artwork"])
	if _palette.item_count > 0:
		_palette.select(0)
		_asset = int(_palette.get_item_metadata(0))

func _world(point: Vector2) -> Vector2:
	return (point - _pan) / _zoom

func _snapped(point: Vector2) -> Vector2:
	return point.snapped(Vector2.ONE * _grid.value) if _snap.button_pressed else point.round()

func _fit() -> void:
	if document.is_empty(): return
	_zoom = clampf(minf((_canvas.size.x - 48) / float(document.room.w), (_canvas.size.y - 48) / float(document.room.h)), 0.05, 8.0)
	_pan = Vector2(24, 24)
	_canvas.queue_redraw()

func _entries(kind: String) -> Array:
	return document.decorations if kind == "decorations" else document.room[kind]

func _bounds(kind: String, entry: Array) -> Rect2:
	var position := Vector2(entry[0], entry[1])
	if kind == "tiles": return Rect2(position, Vector2(entry[5], entry[6]))
	var id := _sprite_id(int(entry[2])) if kind == "instances" else int(entry[2])
	var texture := _texture("sprite", id)
	var origin: Vector2 = R.sprites.get(id, {}).get("origin", Vector2.ZERO)
	return Rect2(position - origin, texture.get_size() if texture != null else Vector2(24, 24))

func _render_entries() -> Array:
	var result: Array = []
	for kind in ["tiles", "instances", "decorations"]:
		var entries := _entries(kind)
		for i in range(entries.size()):
			var entry: Array = entries[i]
			var depth := float(entry[7]) if kind == "tiles" else (float(R.objects.get(int(entry[2]), {}).get("depth", 0)) if kind == "instances" else float(entry[3]))
			result.append([kind, i, depth])
	result.sort_custom(func(a, b): return a[2] > b[2])
	return result

func _hit(point: Vector2) -> Array:
	var ordered := _render_entries()
	ordered.reverse()
	for item in ordered:
		if _bounds(item[0], _entries(item[0])[item[1]]).has_point(point): return [item[0], item[1]]
	return []

func _draw_backgrounds(front: bool, visible: Rect2) -> void:
	# Mirror R.draw_bg_layer so the preview matches the running game, including the
	# editor_background override that custom_level.install() applies to slot 0.
	var bgs: Array = document.room.get("backgrounds", [])
	var override: int = int(document.room.get("editor_background", -1))
	for i in range(mini(8, bgs.size())):
		var b: Dictionary = bgs[i]
		var src: int = int(b.get("source_bg", -1))
		var vis: bool = int(b.get("visible", 0)) != 0 and src >= 0
		if i == 0 and override >= 0:
			src = override
			vis = true
		if not vis or (int(b.get("foreground", 0)) != 0) != front:
			continue
		var tex := R._bg_texture(src)
		if tex == null:
			continue
		var xo: float = float(b.get("xoffset", 0))
		var yo: float = float(b.get("yoffset", 0))
		var bx: float = 0.0 if xo < -900000 else xo
		var by: float = 0.0 if yo < -900000 else yo
		var ts: Vector2 = tex.get_size()
		if ts.x <= 0.0 or ts.y <= 0.0:
			continue
		var ht: bool = int(b.get("tile_horz", 1)) != 0
		var vt: bool = int(b.get("tile_vert", 1)) != 0
		var x0: float = bx + floorf((visible.position.x - bx) / ts.x) * ts.x if ht else bx
		var y0: float = by + floorf((visible.position.y - by) / ts.y) * ts.y if vt else by
		var x1: float = visible.end.x if ht else bx + ts.x
		var y1: float = visible.end.y if vt else by + ts.y
		var yy: float = y0
		while yy < y1:
			var xx: float = x0
			while xx < x1:
				_canvas.draw_texture_rect(tex, Rect2(xx, yy, ts.x, ts.y), false)
				xx += ts.x
			yy += ts.y

func _draw_canvas() -> void:
	_canvas.draw_rect(Rect2(Vector2.ZERO, _canvas.size), Color("202530"))
	if document.is_empty(): return
	_canvas.draw_set_transform(_pan, 0, Vector2.ONE * _zoom)
	var room_rect := Rect2(0, 0, document.room.w, document.room.h)
	_canvas.draw_rect(room_rect, R._gm_color(document.room.get("bg_colour", 0)))
	var visible := Rect2(_world(Vector2.ZERO), _canvas.size / _zoom)
	_draw_backgrounds(false, visible)
	# Static tile and sprite previews only: never invoke object scripts or spawn nodes.
	for item in _render_entries():
		var kind: String = item[0]
		var entry: Array = _entries(kind)[item[1]]
		var rect := _bounds(kind, entry)
		if not rect.intersects(visible): continue
		var id := int(entry[2])
		var texture := _texture("background" if kind == "tiles" else "sprite", _sprite_id(id) if kind == "instances" else id)
		if texture == null:
			_canvas.draw_rect(rect, Color("e9b75f"), false, 1.0 / _zoom)
			_canvas.draw_string(ThemeDB.fallback_font, rect.position + Vector2(0, 14), str(id), HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color.WHITE)
		elif kind == "tiles":
			_canvas.draw_texture_rect_region(texture, rect, Rect2(entry[3], entry[4], entry[5], entry[6]))
		else:
			_canvas.draw_texture_rect(texture, rect, false)
	_draw_backgrounds(true, visible)
	if _snap.button_pressed and _grid.value * _zoom >= 8:
		var start := visible.position.max(Vector2.ZERO).snapped(Vector2.ONE * _grid.value)
		var end := visible.end.min(room_rect.end)
		for x in range(int(start.x), int(end.x) + 1, int(_grid.value)):
			_canvas.draw_line(Vector2(x, maxf(0, visible.position.y)), Vector2(x, end.y), Color(1, 1, 1, 0.12), 1 / _zoom)
		for y in range(int(start.y), int(end.y) + 1, int(_grid.value)):
			_canvas.draw_line(Vector2(maxf(0, visible.position.x), y), Vector2(end.x, y), Color(1, 1, 1, 0.12), 1 / _zoom)
	_canvas.draw_rect(room_rect, Color.WHITE, false, 2 / _zoom)
	if not _selection.is_empty() and _selection[1] < _entries(_selection[0]).size():
		_canvas.draw_rect(_bounds(_selection[0], _entries(_selection[0])[_selection[1]]), Color.YELLOW, false, 2 / _zoom)
	_canvas.draw_set_transform(Vector2.ZERO)

func _canvas_input(event: InputEvent) -> void:
	if document.is_empty(): return
	if event is InputEventMouseButton:
		var point: Vector2 = event.position
		if event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN] and event.pressed:
			var anchor := _world(point)
			_zoom = clampf(_zoom * (1.2 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 1 / 1.2), 0.05, 8)
			_pan = point - anchor * _zoom
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			_panning = event.pressed
		elif event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT]:
			if event.pressed:
				_drag = true
				_begin_edit()
				_last_cell = Vector2(INF, INF)
				_drag_start = _world(point)
				if _tool.selected == 2 and event.button_index == MOUSE_BUTTON_LEFT:
					_selection = _hit(_drag_start)
					if not _selection.is_empty():
						var entry: Array = _entries(_selection[0])[_selection[1]]
						_original_position = Vector2(entry[0], entry[1])
				else:
					_stamp(_world(point), event.button_index == MOUSE_BUTTON_RIGHT or _tool.selected == 1)
			else:
				_finish_drag()
	elif event is InputEventMouseMotion:
		if _panning:
			_pan += event.relative
		elif _drag:
			if _tool.selected == 2 and not _selection.is_empty() and (event.button_mask & MOUSE_BUTTON_MASK_LEFT):
				var position := _snapped(_original_position + _world(event.position) - _drag_start)
				var entry: Array = _entries(_selection[0])[_selection[1]]
				entry[0] = position.x
				entry[1] = position.y
			else:
				_stamp(_world(event.position), (event.button_mask & MOUSE_BUTTON_MASK_RIGHT) != 0 or _tool.selected == 1)
	_canvas.queue_redraw()
	_canvas.accept_event()

func _finish_drag() -> void:
	if _drag:
		_drag = false
		_end_edit()
	_panning = false

func _stamp(point: Vector2, erase: bool) -> void:
	var position := _snapped(point)
	if position == _last_cell: return
	_last_cell = position
	if erase:
		var hit := _hit(point)
		if not hit.is_empty():
			_entries(hit[0]).remove_at(hit[1])
			_selection.clear()
		return
	if _asset < 0 or _tool.selected == 2: return
	if not Rect2(0, 0, document.room.w, document.room.h).has_point(position): return
	var kind := "instances" if _category.selected < 2 else ("decorations" if _category.selected == 2 else "tiles")
	var entries := _entries(kind)
	if entries.size() >= 20000:
		_status.text = "This layer has reached the 20,000 entry limit."
		return
	for entry in entries:
		if entry[0] == position.x and entry[1] == position.y and int(entry[2]) == _asset: return
	if kind == "instances":
		var id := 900000000
		for entry in entries: id = maxi(id, int(entry[3]) + 1)
		if id > 1000000000: return
		entries.append([position.x, position.y, _asset, id])
	elif kind == "decorations":
		entries.append([position.x, position.y, _asset, int(_depth.value)])
	else:
		var texture := _texture("background", _asset)
		if texture == null or _tile_x.value + _tile_w.value > texture.get_width() or _tile_y.value + _tile_h.value > texture.get_height():
			_status.text = "Tile source rectangle must fit the selected background texture."
			return
		var id := 900000000
		for entry in entries: id = maxi(id, int(entry[8]) + 1)
		entries.append([position.x, position.y, _asset, int(_tile_x.value), int(_tile_y.value), int(_tile_w.value), int(_tile_h.value), int(_depth.value), id])

func _input(event: InputEvent) -> void:
	if _root == null or not _root.visible: return
	if event is InputEventMouseButton and not event.pressed:
		if event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT]: _finish_drag()
		if event.button_index == MOUSE_BUTTON_MIDDLE: _panning = false
	if not event is InputEventKey or not event.pressed or event.echo: return
	if _file_dialog.visible or _discard.visible: return
	if get_viewport().gui_get_focus_owner() is LineEdit and event.keycode in [KEY_Z, KEY_Y, KEY_DELETE]: return
	if event.keycode == KEY_F5:
		_playtest()
	elif event.keycode == KEY_ESCAPE:
		_guard(_close)
	elif event.ctrl_pressed and event.keycode == KEY_S:
		_show_files(true)
	elif event.ctrl_pressed and event.keycode == KEY_Z:
		_redo_edit() if event.shift_pressed else _undo_edit()
	elif event.ctrl_pressed and event.keycode == KEY_Y:
		_redo_edit()
	elif event.keycode == KEY_DELETE and not _selection.is_empty() and not get_viewport().gui_get_focus_owner() is LineEdit:
		_begin_edit()
		_entries(_selection[0]).remove_at(_selection[1])
		_selection.clear()
		_end_edit()
	else: return
	get_viewport().set_input_as_handled()

func _show_files(saving: bool) -> void:
	_finish_drag()
	_apply_metadata()
	_saving = saving
	_files.clear()
	var directory := DirAccess.open(SAVE_DIR)
	if directory != null:
		var names := directory.get_files()
		names.sort()
		for name in names:
			if name.ends_with(".json"): _files.add_item(name)
	_file_dialog.title = "Save custom level" if saving else "Load custom level"
	_file_dialog.get_ok_button().text = "Save" if saving else "Load"
	_file_dialog.popup_centered(Vector2i(460, 340))

func _safe_path() -> String:
	var name := _filename.text.strip_edges()
	if name.ends_with(".json"): name = name.left(-5)
	if name.is_empty() or name.length() > 80: return ""
	for i in range(name.length()):
		var code := name.unicode_at(i)
		if not ((code >= 48 and code <= 57) or (code >= 65 and code <= 90) or (code >= 97 and code <= 122) or name[i] in ["_", "-"]): return ""
	return SAVE_DIR + "/" + name + ".json"

func _file_confirmed() -> void:
	var path := _safe_path()
	if path.is_empty():
		_status.text = "Use a filename containing only letters, numbers, underscores or hyphens."
		return
	if not _saving:
		var loaded: Dictionary = Documents.read_document(path)
		if loaded.is_empty():
			_status.text = "Load failed: missing, oversized or invalid JSON."
		else:
			_set_document(loaded, true)
			_fit()
			_status.text = "Loaded " + path
		return
	if FileAccess.file_exists(path):
		_pending = func(): _save_to(path)
		_discard.dialog_text = "Overwrite this custom editor file?"
		_discard.popup_centered()
	else: _save_to(path)

func _save_to(path: String) -> void:
	var valid: Dictionary = Documents.validate(document)
	if valid.is_empty():
		_status.text = "Save failed: document is invalid."
		return
	var error := DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(SAVE_DIR))
	if error != OK:
		_status.text = "Cannot create custom editor directory: " + error_string(error)
		return
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		_status.text = "Cannot write custom editor file: " + error_string(FileAccess.get_open_error())
		return
	file.store_string(JSON.stringify(valid, "\t"))
	file.flush()
	if file.get_error() != OK:
		_status.text = "Write failed; level remains unsaved."
		file.close()
		return
	file.close()
	document = valid
	_saved = JSON.stringify(document)
	_status.text = "Saved " + path
