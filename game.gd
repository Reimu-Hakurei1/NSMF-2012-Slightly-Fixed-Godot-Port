extends Node2D

## Main scene: boots the GameMaker runtime and drives fixed logic ticks at room_speed.

var acc: float = 0.0
var _savedir: String = ""
var _editor: CanvasLayer
var _editor_active := false
var _hidden_layers: Dictionary = {}
var _editor_play := ""
var _play_ready := false
var _startup_editor := false


func _clear_input() -> void:
	R.keys_down.clear()
	R.keys_pressed.clear()
	R.keys_released.clear()
	R.mouse_down.clear()
	R.mouse_pressed.clear()
	R.joy_buttons.clear()
	R.keyboard_key = 0
	R.keyboard_lastkey = 0
	R.keyboard_string = ""
	R.mouse_button = 0
	R.mouse_lastbutton = 0
	R.mouse_wheel = 0
	R.mouse_trigger = 0


func open_level_editor() -> void:
	R.editor_open_pending = false
	if not _editor_play.is_empty():
		return
	if _editor == null:
		_editor = load("res://runtime/level_editor.gd").new()
		add_child(_editor)
		_editor.closed.connect(_close_level_editor)
		_editor.playtest_requested.connect(_playtest)
	if not _editor_active:
		_editor_active = true
		acc = 0.0
		_clear_input()
		for node in [R.room_root, R.particle_node, R.bg_rect, R.bg_back, R.bg_front]:
			if is_instance_valid(node):
				_hidden_layers[node] = node.visible
				node.hide()
	_editor.open_editor()


func _close_level_editor() -> void:
	for node in _hidden_layers:
		if is_instance_valid(node):
			node.visible = _hidden_layers[node]
	_hidden_layers.clear()
	_editor_active = false
	acc = 0.0
	_clear_input()


func _playtest(document: Dictionary) -> void:
	# The editor hides its Control before emitting; reopen even on launch failure.
	_editor.call_deferred("open_editor")
	var valid: Dictionary = load("res://runtime/custom_level.gd").validate(document)
	if valid.is_empty():
		push_error("Invalid editor playtest document")
		return
	var base := ProjectSettings.globalize_path("user://custom_editor/playtests")
	var unique := "%d-%d-%s" % [OS.get_process_id(), Time.get_ticks_usec(), Crypto.new().generate_random_bytes(8).hex_encode()]
	var directory := base.path_join(unique)
	if DirAccess.make_dir_recursive_absolute(directory) != OK:
		push_error("Cannot create playtest sandbox")
		return
	var path := directory.path_join("level.json")
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Cannot write playtest document")
		return
	file.store_string(JSON.stringify(valid))
	file.close()
	var pid := OS.create_process(OS.get_executable_path(), PackedStringArray([
		"--path", ProjectSettings.globalize_path("res://"), "--",
		"--editor-play=" + path, "--savedir=" + directory.path_join("saves")]))
	if pid == -1:
		push_error("Cannot launch editor playtest")


func _initialize_editor_runtime() -> bool:
	# Run Create/Step/Draw initializers before either editing or playing.
	for tick in 600:
		if R.room not in [117, 265, 2, 1] and R.pending_room == null:
			return true
		R.step()
		R.draw_state_passes(1)
	push_error("Editor startup initialization did not finish")
	return false


func _prepare_playtest() -> void:
	if not _initialize_editor_runtime():
		get_tree().quit(1)
		return
	var documents = load("res://runtime/custom_level.gd")
	var document: Dictionary = documents.read_document(_editor_play)
	if document.is_empty() or not documents.install(document):
		push_error("Cannot install editor playtest")
		get_tree().quit(1)
		return
	_play_ready = true
	_clear_input()
	_follow_playtest_player()


func _follow_playtest_player() -> void:
	for player in R.with_ids(null, 303):
		R.view_xview[0] = clampf(float(player.x) - float(R.view_wview[0]) / 2.0, 0.0, maxf(0.0, R.room_width - float(R.view_wview[0])))
		R.view_yview[0] = clampf(float(player.y) - float(R.view_hview[0]) / 2.0, 0.0, maxf(0.0, R.room_height - float(R.view_hview[0])))
		break
	R.update_camera()


func _ready() -> void:
	Engine.max_fps = 60
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--savedir="):
			_savedir = a.substr(10).replace("\\", "/")
		elif a.begins_with("--editor-play="):
			_editor_play = a.substr(14).replace("\\", "/")
		elif a == "--level-editor":
			_startup_editor = true
	# A manually launched playtest also gets a sandbox before the first Create.
	if not _editor_play.is_empty() and _savedir.is_empty():
		_savedir = ProjectSettings.globalize_path("user://custom_editor/playtests").path_join("manual-%d-%d" % [OS.get_process_id(), Time.get_ticks_usec()]).path_join("saves")
	R.boot(self, _savedir)
	if _startup_editor and _editor_play.is_empty():
		if not _initialize_editor_runtime():
			get_tree().quit(1)
			return
		call_deferred("open_level_editor")


func _process(delta: float) -> void:
	if not R.game_running or _editor_active or R.editor_open_pending:
		return
	if not _editor_play.is_empty() and not _play_ready:
		_prepare_playtest()
		return
	if delta > 0.25:
		delta = 0.25
	var step_time: float = 1.0 / maxf(1.0, float(R.room_speed))
	# Normal rooms advance a single step per frame, like GM8 does when it cannot
	# keep up. Only the 1000 Hz system rooms need real catch-up, otherwise a slow
	# frame would replay several expensive steps and make the slowdown compound.
	var max_steps: int = 1 if R.room_speed <= 60 else maxi(2, int(ceil(float(R.room_speed) / 30.0)))
	acc += delta
	var n := 0
	var t0 := Time.get_ticks_usec()
	while acc >= step_time and n < max_steps and not R.editor_open_pending:
		R.step()
		acc -= step_time
		n += 1
	R.perf_step_usec = Time.get_ticks_usec() - t0
	# One rendered draw covers one step; only high-speed rooms need the rest.
	if n > 1 and R.room_speed > 60 and not R.editor_open_pending:
		R.draw_state_passes(n - 1)
	if acc > step_time * 4.0:
		acc = 0.0
	if _play_ready:
		_follow_playtest_player()


func _input(event: InputEvent) -> void:
	if not _editor_play.is_empty() and event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().quit()
		get_viewport().set_input_as_handled()
		return
	if _editor_active or R.editor_open_pending or (not _editor_play.is_empty() and not _play_ready):
		return
	R.handle_input(event)
