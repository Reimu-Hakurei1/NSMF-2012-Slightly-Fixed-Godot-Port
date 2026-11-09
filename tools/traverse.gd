extends SceneTree

## Traversal probe: for each level room given on the command line, load it,
## hold right + jump for a fixed number of frames and report how far Mario got.

var rooms: Array = []
var timing: int = 0
var settle: int = 470
var idx: int = 0
var phase: int = 0
var wait: int = 0
var mario: GMInstance = null
var start_x: float = 0.0
var max_x: float = 0.0
var deaths: int = 0
var per_room: int = 420
var results: Array = []


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	for a in args:
		rooms.append(int(a))
	if rooms.is_empty():
		rooms = [3, 4, 12, 13, 14, 20, 30, 42, 54, 100, 102]
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)


func _find_mario() -> GMInstance:
	for inst in R.instances:
		if inst.alive and int(inst.g_object_index) == 303:
			return inst
	return null


func _start_room() -> void:
	G.pauza = 0
	G.zycia = 4
	G.mario_wszedl_do_etapu = 0
	G.blokuj_ruch_na_title_screenie = 0
	G.game_over = 0
	R.room_goto(null, rooms[idx])
	phase = 1
	wait = 0


func _process(_delta: float) -> bool:
	timing += 1
	if phase == 0:
		if timing < settle:
			return false
		_start_room()
		return false
	if phase == 1:
		wait += 1
		if wait < 10:
			return false
		mario = _find_mario()
		if mario == null:
			results.append({"room": rooms[idx], "ok": false, "why": "no mario"})
			_next_room()
			return false
		G.blokuj_ruch_na_title_screenie = 0
		mario.g_sekwencja = 1
		start_x = mario.position.x
		max_x = start_x
		deaths = 0
		phase = 2
		wait = 0
		return false
	if phase == 2:
		wait += 1
		R.keyboard_key_press(null, int(G.ster_right))
		if wait % 60 == 0:
			R.keyboard_key_press(null, int(G.ster_jump))
		else:
			R.keyboard_key_release(null, int(G.ster_jump))
		var m := _find_mario()
		if m == null or not m.alive:
			deaths += 1
			mario = m
		else:
			mario = m
			max_x = maxf(max_x, m.position.x)
		if wait >= per_room:
			R.keyboard_key_release(null, int(G.ster_right))
			R.keyboard_key_release(null, int(G.ster_jump))
			var gained := max_x - start_x
			results.append({"room": rooms[idx], "ok": gained > 50.0,
				"gained": gained, "deaths": deaths, "x": max_x})
			print("TRAV room=%d start=%.0f maxx=%.0f gained=%.0f deaths=%d" % [
				rooms[idx], start_x, max_x, gained, deaths])
			_next_room()
			return false
	return false


func _next_room() -> void:
	R.keyboard_key_release(null, int(G.ster_right))
	R.keyboard_key_release(null, int(G.ster_jump))
	idx += 1
	if idx >= rooms.size():
		var ok := 0
		for r in results:
			if r.get("ok", false):
				ok += 1
		print("TRAV DONE ok=%d of %d" % [ok, results.size()])
		for r in results:
			print("TRAV RES %s" % str(r))
		quit(0 if ok == results.size() else 2)
		return
	_start_room()
