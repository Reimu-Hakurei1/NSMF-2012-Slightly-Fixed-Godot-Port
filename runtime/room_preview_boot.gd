extends Node2D

## Attached to every generated room scene. In the editor the scene stays a static
## preview; when it is run directly (F6 / --path <scene>) this boots the GameMaker
## runtime and jumps into the room the scene was generated from, once the normal
## boot/loading sequence has initialised the game globals.

var _target: int = -1
var _jumped: bool = false
var _acc: float = 0.0
var _savedir: String = ""


func _ready() -> void:
	# Only boot when this scene is the one that was launched. The viewer/play
	# tools instantiate room scenes as children, and editors preview statically.
	if Engine.is_editor_hint() or get_parent() != get_tree().root:
		return
	# Headless validation can redirect saves away from the player's real data.
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--savedir="):
			_savedir = a.substr(10).replace("\\", "/")
			DirAccess.make_dir_recursive_absolute(_savedir)
	var room_name: String = str(get_meta("gm_room", ""))
	# The preview nodes are plain sprite copies of the room; drop them so the
	# runtime's own renderer is the only thing drawing.
	for child in get_children():
		remove_child(child)
		child.queue_free()
	R.boot(self)
	_target = _find_room(room_name)
	print("ROOM_SCENE boot room='%s' target=%d" % [room_name, _target])


func _process(delta: float) -> void:
	if Engine.is_editor_hint() or R.root != self or not R.game_running:
		return
	if _savedir != "" and R.working_directory != _savedir:
		R.working_directory = _savedir
	if delta > 0.25:
		delta = 0.25
	var step_time: float = 1.0 / maxf(1.0, float(R.room_speed))
	_acc += delta
	var n: int = 0
	while _acc >= step_time and n < 8:
		R.step()
		_acc -= step_time
		n += 1
		_jump_to_target()
	if n >= 8:
		_acc = 0.0


func _input(event: InputEvent) -> void:
	if R.root == self:
		R.handle_input(event)


func _jump_to_target() -> void:
	# Wait for room 1 (game_initialize): room 2's loading screen has already run
	# script_generating_particlering there, so lives/player/map globals are set.
	# Jumping before 324 keeps the title screen from setting its input lock.
	if _jumped or _target < 0 or R.room != 1 or R.room == _target:
		return
	_jumped = true
	R.room_goto(self, _target)
	print("ROOM_SCENE jump target=%d name='%s'" % [_target, R.room_get_name(self, _target)])


func _find_room(room_name: String) -> int:
	if room_name.is_empty():
		return -1
	var rooms: Dictionary = R.room_data.get("rooms", {})
	for key: Variant in rooms:
		if str(rooms[key].get("name", "")) == room_name:
			return int(key)
	return -1
