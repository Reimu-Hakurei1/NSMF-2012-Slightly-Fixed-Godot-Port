extends Node2D

var rooms: Array = []
var current := 0
var level: Node2D
var cam: Camera2D
var hud: Label
var speed := 1200.0
var shot := ""
var frames := 0

func _ready() -> void:
	if get_parent() == get_tree().root and OS.get_cmdline_user_args().is_empty():
		_launch_full_game()
		return
	var f := FileAccess.open("res://data/levels/index.json", FileAccess.READ)
	if f == null:
		return
	rooms = JSON.parse_string(f.get_as_text())
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		current = int(args[0])
	_load(current)
	if args.size() > 2:
		cam.position = Vector2(float(args[1]), float(args[2]))
		if args.size() > 4:
			cam.zoom = Vector2.ONE * float(args[4])
		_hud(rooms[current])
	if args.size() > 3:
		shot = args[3]

func _load(i: int) -> void:
	if i < 0 or i >= rooms.size():
		return
	current = i
	if level != null:
		level.queue_free()
	var info: Dictionary = rooms[i]
	level = load(info["scene"]).instantiate()
	add_child(level)
	cam = level.get_node("Camera2D")
	cam.limit_smoothed = false
	cam.make_current()
	if hud == null:
		var layer := CanvasLayer.new()
		add_child(layer)
		hud = Label.new()
		hud.position = Vector2(8, 4)
		layer.add_child(hud)
	_hud(info)

func _hud(info: Dictionary) -> void:
	var p = "none"
	if cam != null:
		p = str(cam.position.round())
	hud.text = "%d/%d  %s  (%dx%d)\ncamera %s\nWASD/arrows pan, Q/E room, R reload" % [
		current + 1, rooms.size(), info["name"], info["width"], info["height"], p]

func _process(d: float) -> void:
	if shot != "":
		frames += 1
		if frames == 4:
			get_viewport().get_texture().get_image().save_png(shot)
			get_tree().quit()
		return
	var v := Vector2.ZERO
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		v.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		v.x += 1.0
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		v.y -= 1.0
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		v.y += 1.0
	if v != Vector2.ZERO and cam != null:
		cam.position += v.normalized() * speed * d
		_hud(rooms[current])

func _unhandled_input(e: InputEvent) -> void:
	if e is InputEventKey and e.pressed and not e.echo:
		match e.keycode:
			KEY_PAGEUP, KEY_E:
				_load(current + 1)
			KEY_PAGEDOWN, KEY_Q:
				_load(current - 1)
			KEY_R:
				_load(current)


# Running the viewer on its own (F6) now boots the real game; the viewer stays
# available when CLI args are passed.
func _launch_full_game() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	var game: Node = load("res://scenes/game.tscn").instantiate()
	get_tree().root.add_child.call_deferred(game)
	get_tree().set_deferred("current_scene", game)
	queue_free()
