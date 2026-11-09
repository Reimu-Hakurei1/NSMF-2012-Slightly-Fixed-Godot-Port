extends Node2D

# Playable slice. Physics constants and the per-pixel move loops come from
# script_player_vanilla.gml, the enemy walk from script_enemy_goomba.gml, the stomp test
# from script_player_wrogowanie.gml, and the body is GameMaker's part rig
# (global.gfx_mario_head/chest/arm/leg, posed by script_anim_bieg / script_anim_stanie).

const GRAVITY := 1.0
const TERMINAL := 14.0
const JUMP := -8.0
const ACCEL := 0.15
const SKID := 0.10
const FRICTION := 1.07
const WALK_MAX := 3.0
const RUN_MAX := 7.0
const BOX := Vector2(32, 64)   # sprite 211's collision mask
const CELL := 40
const RIG_Y := 27.0            # obj_mario_anim.y = obj_mario.y + 32 - size*40 + 35, size=1

const RIG := {
	"chest": {"tex": "res://images/gfx/mario_chest.png", "ox": 30, "oy": 30},
	"head": {"tex": "res://images/gfx/mario_head.png", "ox": 32, "oy": 41},
	"arm_b": {"tex": "res://images/gfx/mario_arm.png", "ox": 20, "oy": 24},
	"arm_f": {"tex": "res://images/gfx/mario_arm.png", "ox": 20, "oy": 24},
	"leg_b": {"tex": "res://images/gfx/mario_leg.png", "ox": 22, "oy": 21},
	"leg_f": {"tex": "res://images/gfx/mario_leg.png", "ox": 22, "oy": 21},
}
const GOOMBA_BODY := "res://images/gfx/enemy_goomba.png"
const GOOMBA_LEG := "res://images/gfx/enemy_goomba_leg.png"
const COIN_GFX := "res://images/gfx/mario_coin.png"

# script_obsluga_muzyki.33 turns global.level_music into a file under the mod's data/m.
# The MP3 tracks are streamed straight from the original install, so the port stores no
# audio copies; the .ogg entries would need an import step and are skipped for now.
const MUSIC := {
	0: "level_prime.mp3", 2: "level_grzyby.mp3", 4: "level_boomboom.mp3", 5: "level_duchownia.mp3",
	6: "level_duel.mp3", 7: "level_palace.mp3", 8: "level_ship.mp3", 9: "level_boss_1.mp3",
	12: "level_water_ship.mp3", 14: "level_secret.mp3", 15: "level_chasing.mp3",
	17: "level_zameczek_3.mp3", 18: "level_chase.mp3", 22: "level_tanks.mp3",
	32: "level_cloudy_2.mp3",
}
const MUSIC_DIR := "C:/Users/Alex/Downloads/NSMF2012SlightlyFixed-master/NSMF2012SlightlyFixed-master/data/m"

# Sound slots are the real SXMS indices from init_sound_base.gml: jump is 10-13 (the engine
# picks 10+round(random(3))), coin 20, stomp 56, kick 51, death 128/129, checkpoint 118, end 28.
const SFX := {
	"jump": ["res://audio/sfx/mario_jump_1.wav", "res://audio/sfx/mario_jump_2.wav",
			 "res://audio/sfx/mario_jump_3.wav", "res://audio/sfx/mario_jump_4.wav"],
	"coin": ["res://audio/sfx/coin.mp3"],
	"stomp": ["res://audio/sfx/stomp.wav"],
	"kick": ["res://audio/sfx/kick.wav"],
	"die": ["res://audio/sfx/mario_dies_1.mp3", "res://audio/sfx/mario_dies_2.mp3"],
	"clear": ["res://audio/sfx/end.mp3"],
	"checkpoint": ["res://audio/sfx/check_point.mp3"],
}

var rooms: Array = []
var room_no := 0
var data: Dictionary = {}
var level: Node2D
var cam: Camera2D
var hud: Label
var rig: Node2D
var parts := {}
var grid := {}
var coins: Array = []
var checkpoints: Array = []
var enemies: Array = []
var goal := Rect2()
var pos := Vector2.ZERO
var vel := Vector2.ZERO
var spawn := Vector2.ZERO
var grounded := false
var facing := 1
var jump_prev := false
var run_kat := 0.0
var coin_count := 0
var points := 0
var red_count := 0
var kills := 0
var deaths := 0
var lives := 4
var cleared := false
var clear_wait := 0
var dying := 0
var room_size := Vector2(800, 600)
var death_y := 1400.0
var time_left := 600.0
var no_time := false
var auto := false
var auto_hold := 0
var windup := 0
var wall_jump := 0
var wall_dir := 0
var wall_jump_key := false
var wall_rearm := 0
var climb_dir := 0
var sim_path: Array = []
var floor_cache := {}
var arc_cache := {}
var stuck_clock := 0
var stuck_anchor := Vector2.ZERO
var kuku := 0
var max_steps := 1500
var shot := ""
var steps := 0
var log_lines: Array[String] = []
var sfx_streams := {}
var sfx_players: Array = []
var sfx_on := true
var music_player: AudioStreamPlayer
var music_index := -1

func _ready() -> void:
	if get_parent() == get_tree().root and OS.get_cmdline_user_args().is_empty():
		_launch_full_game()
		return
	var args := OS.get_cmdline_user_args()
	var warp := Vector2.INF
	for a in args:
		if a == "auto":
			auto = true
		if String(a).begins_with("max="):
			max_steps = int(String(a).substr(4))
		if String(a).begins_with("warp="):
			var xy := String(a).substr(5).split(",")
			warp = Vector2(float(xy[0]), float(xy[1]))
		if String(a).ends_with(".png"):
			shot = a
	# index.json is in GM room_order, and position 30 is room_level_1_1, the first real level.
	var idx := 30
	if args.size() > 0:
		idx = int(args[0])
	var f := FileAccess.open("res://data/levels/index.json", FileAccess.READ)
	if f == null:
		return
	rooms = JSON.parse_string(f.get_as_text())
	for kind in SFX:
		var list: Array = []
		for path in SFX[kind]:
			if ResourceLoader.exists(path):
				list.append(load(path))
		if not list.is_empty():
			sfx_streams[kind] = list
	for i in 8:
		var p := AudioStreamPlayer.new()
		add_child(p)
		sfx_players.append(p)
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	_load(idx)
	if warp.x != INF:
		pos = warp
		grounded = false

func _sfx(kind: String) -> void:
	if not sfx_on or sfx_players.is_empty():
		return
	var pool: Array = sfx_streams.get(kind, [])
	if pool.is_empty():
		return
	var p: AudioStreamPlayer = sfx_players[randi() % sfx_players.size()]
	p.stream = pool[randi() % pool.size()]
	p.play()

func _unhandled_input(ev: InputEvent) -> void:
	if ev is InputEventKey and ev.pressed and ev.keycode == KEY_M:
		sfx_on = not sfx_on
		if music_player != null:
			music_player.stream_paused = not sfx_on

func _play_music(i: int) -> void:
	if music_player == null or i == music_index:
		return
	music_index = i
	var st: AudioStreamMP3 = null if not MUSIC.has(i) \
		else AudioStreamMP3.load_from_file(MUSIC_DIR + "/" + MUSIC[i])
	if st == null:
		music_player.stop()
		return
	st.loop = true
	music_player.stream = st
	music_player.volume_db = -10.0
	music_player.play()

func _load(i: int) -> void:
	if i >= rooms.size():
		i = 0
	room_no = i
	for old in [level, rig]:
		if old != null:
			remove_child(old)
			old.free()
	level = null
	rig = null
	parts.clear()
	enemies.clear()
	var info: Dictionary = rooms[i]
	var df := FileAccess.open(info["data"], FileAccess.READ)
	data = JSON.parse_string(df.get_as_text())
	room_size = Vector2(data["width"], data["height"])
	death_y = _death_pit(data.get("creation_code", ""))
	time_left = _number(data.get("creation_code", ""), "global.time")
	if time_left <= 0.0:
		time_left = 600.0
	no_time = _number(data.get("creation_code", ""), "global.notime") > 0.0
	_play_music(int(_number(data.get("creation_code", ""), "global.level_music")))
	level = load(info["scene"]).instantiate()
	add_child(level)
	cam = level.get_node("Camera2D")
	cam.limit_smoothed = false
	cam.make_current()
	var nodes := _node_index(level)
	grid.clear()
	coins.clear()
	checkpoints.clear()
	goal = Rect2()
	for inst in data["instances"]:
		var oname: String = inst["object"]
		var r := Rect2(inst["x"] - inst.get("ox", 0), inst["y"] - inst.get("oy", 0),
					   inst.get("w", 0), inst.get("h", 0))
		if oname.begins_with("o_check_point"):
			# o_check_point_1 doubles as a wall, and its touch box is 100x200 above it.
			checkpoints.append({"pos": Vector2(inst["x"], inst["y"]), "hit": false})
		if inst.get("collider", false) and inst.get("w", 0) > 0:
			_add_solid(Rect2(inst["x"], inst["y"], inst["w"], inst["h"]))
		elif oname == "obj_mario":
			spawn = Vector2(inst["x"], inst["y"])
		elif oname == "o_COIN" or oname == "o_RED_COIN":
			var node = nodes.get("%s %d %d" % [oname, inst["x"], inst["y"]])
			_coinswap(node, r)
			coins.append({"rect": r, "node": node, "red": oname == "o_RED_COIN", "taken": false})
		elif oname == "o_koniec_etapu":
			goal = r
		elif oname.find("goomba") >= 0 and oname.find("map") < 0:
			enemies.append({"pos": Vector2(inst["x"], inst["y"]), "w": inst.get("w", 32),
							"h": inst.get("h", 32), "dir": -1, "vy": 0.0,
							"alive": true, "node": _make_goomba()})
	_reset()
	_make_hud()
	_draw_rig()

func _node_index(l: Node) -> Dictionary:
	var out := {}
	for g in l.get_children():
		for c in g.get_children():
			out["%s %d %d" % [c.get_meta("gm_object", ""), int(c.position.x), int(c.position.y)]] = c
	return out

func _coinswap(node, r: Rect2) -> void:
	if node == null or not node is Sprite2D:
		return
	var tex := _tex(COIN_GFX)
	if tex == null:
		return
	node.texture = tex
	node.centered = false
	node.offset = Vector2.ZERO
	node.scale = Vector2(r.size.x / tex.get_width(), r.size.y / tex.get_height())
	node.position = r.position

func _number(code: String, key: String) -> float:
	var rx := RegEx.create_from_string(key.replace(".", "\\.") + "\\s*=\\s*(-?[0-9.]+)")
	var mm = rx.search(code)
	return float(mm.get_string(1)) if mm != null else 0.0

func _death_pit(code: String) -> float:
	var rx := RegEx.create_from_string("level_death_pit\\s*[>=]\\s*(-?[0-9.]+)")
	var mm = rx.search(code)
	return float(mm.get_string(1)) if mm != null else room_size.y + 200.0

func _add_solid(r: Rect2) -> void:
	for cy in range(int(floor(r.position.y / CELL)), int(floor((r.end.y - 0.0001) / CELL)) + 1):
		for cx in range(int(floor(r.position.x / CELL)), int(floor((r.end.x - 0.0001) / CELL)) + 1):
			var k := "%d,%d" % [cx, cy]
			if not grid.has(k):
				grid[k] = []
			grid[k].append(r)

func _reset() -> void:
	pos = _free_near(spawn)
	vel = Vector2.ZERO
	grounded = false
	dying = 0
	cleared = false
	clear_wait = 0
	windup = 0
	stuck_clock = 0
	climb_dir = 0
	for e in enemies:
		e["alive"] = true
		e["vy"] = 0.0
		e["node"].visible = true

func _free_near(at: Vector2) -> Vector2:
	# Some levels place obj_mario inside an obj_wall subclass marker; the original engine
	# tolerates that because its own recovery loop nudges the body out of geometry.
	if not _blocked(at):
		return at
	for step in [8.0, 16.0, 24.0, 32.0, 40.0, 64.0, 96.0, 128.0]:
		for dx in [step, -step, 0.0]:
			for dy in [-step, -step * 0.5, 0.0]:
				var p := at + Vector2(dx, dy)
				if not _blocked(p):
					return p
	return at

func _make_hud() -> void:
	if hud != null:
		return
	var layer := CanvasLayer.new()
	add_child(layer)
	hud = Label.new()
	hud.position = Vector2(8, 4)
	layer.add_child(hud)

func _tex(path: String) -> Texture2D:
	if not ResourceLoader.exists(path):
		return null
	return load(path)

func _draw_rig() -> void:
	rig = Node2D.new()
	add_child(rig)
	rig.z_index = 30
	for key in RIG:
		var s := Sprite2D.new()
		s.centered = false
		s.texture = _tex(RIG[key]["tex"])
		s.offset = Vector2(-RIG[key]["ox"], -RIG[key]["oy"])
		rig.add_child(s)
		parts[key] = s

func _make_goomba() -> Node2D:
	var n := Node2D.new()
	n.z_index = 20
	var legs: Array = []
	for i in 2:
		var leg := Sprite2D.new()
		leg.texture = _tex(GOOMBA_LEG)
		n.add_child(leg)
		legs.append(leg)
	var body := Sprite2D.new()
	body.texture = _tex(GOOMBA_BODY)
	n.add_child(body)
	n.set_meta("body", body)
	n.set_meta("legs", legs)
	add_child(n)
	return n

func _hit(at: Vector2, size: Vector2) -> bool:
	var r := Rect2(at, size)
	# Fractional positions must still cover the cell their edge reaches into, otherwise the
	# body sits 1px inside geometry and every vertical test then fails.
	var x0 := int(floor(r.position.x / CELL))
	var y0 := int(floor(r.position.y / CELL))
	var x1 := int(floor((r.end.x - 0.0001) / CELL))
	var y1 := int(floor((r.end.y - 0.0001) / CELL))
	for cy in range(y0, y1 + 1):
		for cx in range(x0, x1 + 1):
			for w in grid.get("%d,%d" % [cx, cy], []):
				if w.intersects(r):
					return true
	return false

func _blocked(at: Vector2) -> bool:
	return _hit(at, BOX)

func _axis() -> float:
	if auto:
		return _auto_axis()
	var a := 0.0
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		a -= 1.0
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		a += 1.0
	return a

func _jump_pressed() -> bool:
	if auto:
		return auto_hold > 0
	return Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_Z) or Input.is_key_pressed(KEY_SPACE)

func _jump_edge() -> bool:
	var now := auto_jump_due() if auto else _jump_pressed()
	var edge := now and not jump_prev
	jump_prev = now
	return edge

func _auto_axis() -> float:
	# A wall bounce throws the body sideways, so keep pressing that way: the run-up to the
	# opposite face is what turns two bounces into a climb out of a pipe shaft.
	if climb_dir != 0:
		return float(climb_dir)
	# Retreat from a step the current run-up cannot clear, and stop retreating the moment
	# a jump from this spot would clear it, so the run-in is exactly as long as the wall needs.
	if windup > 0:
		if _can_clear_ahead():
			windup = 0
			vel.x = 0.0
		else:
			return -1.0
	return 1.0

func _can_clear_ahead() -> bool:
	if _pit_ahead(1):
		return _clears_pit(1)
	var t := _nearest_enemy(1)
	if not t.is_empty():
		return _hop_outcome(t, 1) >= 0
	var w := _wall_ahead(1)
	if w.is_empty():
		return true
	if w["dist"] > 320.0:
		return false
	return _jump_clears(w, 1)

func auto_jump_due() -> bool:
	# Scripted test run. Instead of guessing a take-off distance, replay the real jump
	# equations forward and only commit when that hop actually lands past the obstacle.
	if wall_jump > 0:
		# cling for a few frames so the jump key counts as released, then press again to bounce
		if wall_rearm < 4:
			wall_rearm += 1
			return false
		return true
	if windup > 0:
		return false
	if not grounded:
		return false
	if _pit_ahead(facing):
		# Jump at the last board whether or not the hop looks long enough, because walking off
		# the edge is a guaranteed death and the arc still gives the run-speed boost a chance.
		return _clears_pit(facing) or _pit_ahead(facing, 8.0)
	var target := _nearest_enemy()
	if not target.is_empty():
		# Replay the arc against the goomba's own walk and only commit to a hop that either
		# lands the stomp or sails past it; a hop that would meet it low is a guaranteed hit.
		var outcome := _hop_outcome(target, facing)
		if outcome >= 0:
			return true
		if absf(float(target["pos"].x) - pos.x) < 72.0:
			windup = 90        # back off, then re-approach so the meeting point is in mid-air
		return false
	var w := _wall_ahead(facing)
	if not w.is_empty():
		if w["dist"] <= 320.0:
			# Flush against a step the hop cannot top means the way up is the wall cling, so jump
			# into the face anyway; the arc drops along it, latches, and the bounce climbs.
			return _jump_clears(w, facing) or w["dist"] < 24.0
		return false
	return steps % 90 == 0

func _arc(dir: int) -> Array:
	# Every planner test wants the same replay, and a 140-frame pixel-by-pixel hop is far too
	# expensive to redo three times per step, so the frames of one direction are built once.
	if not arc_cache.has(dir):
		_simulate_jump(dir, pos, RUN_MAX * float(dir))
		arc_cache[dir] = sim_path.duplicate()
	return arc_cache[dir]

func _arc_land(dir: int) -> Vector2:
	var path := _arc(dir)
	return path[-1] if not path.is_empty() else pos

func _jump_clears(w: Dictionary, dir: int) -> bool:
	# Passing the blocking edge means the hop cleared the step; the body is 32 wide, so
	# facing right the right-hand edge of the mask has to get past the wall's left side.
	var land := _arc_land(dir)
	if land.y > death_y:
		return false
	if dir > 0:
		return land.x + BOX.x > float(w["edge"]) + 8.0
	return land.x < float(w["edge"]) - BOX.x - 8.0

func _simulate_jump(dir: int, from := Vector2.INF, speed0 := INF) -> Vector2:
	var p := pos if from.x >= INF else from
	var vx := vel.x if speed0 >= INF else speed0
	var vy := JUMP
	var hold := 40
	var ku := 2            # kuku has been counting while grounded, so frame one is already boosted
	p.y -= absf(vx)       # the take-off lift the engine adds with y -= abs(szybkosc)
	sim_path.clear()
	for f in range(140):
		vx += (SKID if vx * dir < 0.0 else ACCEL) * float(dir)
		vx = clampf(vx, -RUN_MAX, RUN_MAX)
		var dx := vx
		while dx != 0.0:
			var s := clampf(dx, -1.0, 1.0)
			if _blocked(Vector2(p.x + s, p.y)):
				if vy > 0.0 and not _blocked(Vector2(p.x, p.y + 5.0)):
					# airborne and falling against this face with no floor 5px below the feet,
					# so the real body would cling here and slide rather than stop on it
					return Vector2(p.x, p.y + 10000.0)
				vx = 0.0
				break
			p.x += s
			dx -= s
		ku += 1
		if hold > 0 and vy < 0.0 and ku > 1:
			vy -= 1.5 + absf(vx) / 50.0
			ku = 0
		if hold > 0:
			hold -= 1
		var up := vy < 0.0
		var d := absf(vy)
		var landed := false
		while d > 0.0:
			var s := minf(d, 1.0)
			var step := -s if up else s
			if _blocked(Vector2(p.x, p.y + step)):
				vy = 0.0
				landed = not up
				break
			p.y += step
			d -= s
		vy = minf(vy + GRAVITY, TERMINAL)
		sim_path.append(p)
		if landed and f > 2:
			return p
	return p

func _nearest_enemy(dir: int = 0) -> Dictionary:
	var look := dir if dir != 0 else facing
	var best := {}
	var best_d := 200.0
	for e in enemies:
		if not e["alive"] or (float(e["pos"].x) - pos.x) * float(look) <= 0.0:
			continue
		if absf(float(e["pos"].y) - pos.y) > 96.0:
			continue
		var d := absf(float(e["pos"].x) - pos.x)
		if d < best_d:
			best_d = d
			best = e
	return best

func _hop_outcome(e: Dictionary, dir: int) -> int:
	# 1 = the arc stomps it, 0 = the arc sails clear of it, -1 = the body passes through the
	# goomba's neighbourhood without landing the stomp. Only the first overlapping frame decides,
	# but near misses count as danger: the real goomba turns at ledges, which this replay cannot know.
	var ey := float(e["pos"].y)
	var esz := Vector2(e["w"], e["h"])
	var risky := false
	var path := _arc(dir)
	for f in path.size():
		var sp: Vector2 = path[f]
		# the goomba keeps walking its own pixel a frame, so slide its box along with the clock
		var er := Rect2(Vector2(float(e["pos"].x) + float(e["dir"]) * f, ey), esz)
		if er.grow(10.0).intersects(Rect2(sp, BOX)):
			risky = true
			if er.intersects(Rect2(sp, BOX).grow(-2.0)) and sp.y + BOX.y < ey + 10.0:
				return 1
	return 0 if not risky else -1

func _wall_ahead(dir: int) -> Dictionary:
	var y0 := pos.y
	var y1 := pos.y + BOX.y
	var cy0 := int(floor(y0 / CELL))
	var cy1 := int(floor((y1 - 0.0001) / CELL))
	var start := int(floor((pos.x + dir * 8.0) / CELL))
	var stop := int(floor((pos.x + dir * 320.0) / CELL))
	var cols: Array = range(start, stop + 1) if dir > 0 else range(start, stop - 1, -1)
	var edge := pos.x + (BOX.x if dir > 0 else 0.0)
	for c in cols:
		var near: float = INF if dir > 0 else -INF
		var top := INF
		for cy in range(cy0, cy1 + 1):
			for w in grid.get("%d,%d" % [c, cy], []):
				var r: Rect2 = w
				if r.position.y >= y1 or r.end.y <= y0:
					continue            # nothing level with the body
				if dir > 0:
					if r.end.x <= edge:
						continue
					near = minf(near, r.position.x)
				else:
					if r.position.x >= edge:
						continue
					near = maxf(near, r.end.x)
				top = minf(top, r.position.y)
		if (dir > 0 and near < INF) or (dir < 0 and near > -INF):
			var dist := absf(near - edge)
			return {"dist": dist, "edge": near, "gain": y1 - top}
	return {}

func _drop_to_floor(at: Vector2) -> float:
	# How far the feet fall to the first solid above the death line, or INF if there is none.
	# Several planner tests ask for the same spot in one frame, so the scan is memoised per frame.
	var key := int(at.x * 4.0) * 100000 + int(at.y * 4.0)
	if floor_cache.has(key):
		return floor_cache[key]
	var feet := at.y + BOX.y
	var x0 := at.x
	var x1 := at.x + BOX.x - 0.001
	var best := INF
	for cy in range(int(floor(feet / CELL)), int(floor((death_y + 40.0) / CELL)) + 1):
		for cx in range(int(floor(x0 / CELL)), int(floor(x1 / CELL)) + 1):
			for w in grid.get("%d,%d" % [cx, cy], []):
				var r: Rect2 = w
				if r.end.x <= x0 or r.position.x >= x1:
					continue
				if r.position.y <= feet + 0.001:
					best = 0.0
					break
				best = minf(best, r.position.y - feet)
			if best == 0.0:
				break
		if best == 0.0:
			break
	floor_cache[key] = best
	return best

func _over_death(at: Vector2) -> bool:
	return _drop_to_floor(at) > death_y - (at.y + BOX.y)

func _pit_ahead(dir: int, d := 24.0) -> bool:
	# Only a drop that reaches the death line counts as a pit; an ordinary step down onto
	# lower ground is walked off, and jumping it would only put the bot in the air near enemies.
	return not _over_death(pos) and _over_death(Vector2(pos.x + float(dir) * d, pos.y))

func _clears_pit(dir: int) -> bool:
	# The boots are always at full speed by the time the ledge runs out, because the bot keeps
	# pressing, so judge the hop the run-up actually produces instead of the speed of this frame.
	return _arc_land(dir).y + BOX.y <= death_y

func _physics_process(_d: float) -> void:
	steps += 1
	floor_cache.clear()
	arc_cache.clear()
	if dying > 0:
		_death_step()
	elif not cleared:
		_player_step()
		_enemy_steps()
		_interactions()
		_pickups()
	_animate()
	_flow()

func _player_step() -> void:
	if grounded or dying > 0:
		climb_dir = 0
	var ax := 0.0 if wall_jump > 0 else _axis()
	var max_speed := RUN_MAX if (auto or Input.is_key_pressed(KEY_X) or Input.is_key_pressed(KEY_SHIFT)) else WALK_MAX
	if ax != 0.0:
		facing = int(signf(ax))
		vel.x += (SKID if ax * vel.x < 0.0 else ACCEL) * ax
		vel.x = clampf(vel.x, -max_speed, max_speed)
	else:
		vel.x /= FRICTION
		if absf(vel.x) < 0.02:
			vel.x = 0.0

	# GameMaker moves and tests one pixel at a time, so a wall is never tunnelled.
	var dx := vel.x
	while dx != 0.0:
		var s := clampf(dx, -1.0, 1.0)
		if _blocked(Vector2(pos.x + s, pos.y)):
			vel.x = 0.0
			break
		pos.x += s
		dx -= s

	# Wall slide (script_player_vanilla 950): falling, pressing into a wall, body one pixel
	# from it -> snap flush, kill the horizontal speed and hover at 1px/frame until a jump.
	# The engine leaves the cling five pixels above the floor, so latching that close to the
	# ground would toggle every frame and Mario would never land.
	if wall_jump == 0 and ax != 0.0 and not grounded and vel.y > 0.0 \
			and not _blocked(Vector2(pos.x, pos.y + 5.0)) \
			and _blocked(Vector2(pos.x + signf(ax), pos.y)):
		wall_jump = 1
		wall_dir = int(signf(ax))
		vel.x = 0.0
		vel.y = 0.0
		wall_jump_key = true
		if auto:
			print("step %d wall cling at %s dir %d" % [steps, str(pos.round()), wall_dir])
			auto_hold = 0
			wall_rearm = 0
	if wall_jump > 0:
		var off_wall := not _blocked(Vector2(pos.x + float(wall_dir), pos.y))
		var feet := _blocked(Vector2(pos.x, pos.y + 5.0))
		if off_wall or feet or grounded:
			wall_jump = 0
		else:
			vel.x = 0.0
			vel.y = 0.0        # the engine clamps grawitacja to 1, so he drifts down a pixel a frame
			facing = -wall_dir

	if not _jump_pressed():
		wall_jump_key = false

	# script_player_vanilla: kuku+=1 (899), the hold boost (915), then the move, then grawitacja+=1.
	# kuku is not reset by the jump itself, so a jump taken after standing still is boosted on its
	# very first frame; that single extra -1.64 is worth tens of pixels of height.
	kuku += 1
	var jedge := _jump_edge()
	if jedge and wall_jump > 0 and not wall_jump_key:
		wall_jump = 0
		vel.y = JUMP
		vel.x = 8.0 * float(-wall_dir)
		facing = -wall_dir
		auto_hold = 40
		wall_jump_key = true
		climb_dir = -wall_dir if _over_death(pos) else 0
		_sfx("jump")
		if auto:
			print("step %d wall bounce at %s vy %.1f" % [steps, str(pos.round()), vel.y])
	elif jedge and grounded:
		vel.y = JUMP
		# the engine also lifts the body by the run speed on take-off: y -= abs(szybkosc)
		pos.y -= absf(vel.x)
		auto_hold = 40
		wall_jump_key = true
		_sfx("jump")
	if _jump_pressed() and vel.y < 0.0 and kuku > 1:
		vel.y -= 1.5 + absf(vel.x) / 50.0
		kuku = 0
	if auto_hold > 0:
		auto_hold -= 1

	# Full-length step like the engine, resolved one pixel at a time so nothing is tunnelled.
	var rising := vel.y < 0.0
	var dy := absf(vel.y)
	grounded = false
	if rising:
		while dy > 0.0:
			var s := minf(dy, 1.0)
			if _blocked(Vector2(pos.x, pos.y - s)):
				vel.y = 0.0
				break
			pos.y -= s
			dy -= s
	else:
		while dy > 0.0:
			var s := minf(dy, 1.0)
			if _blocked(Vector2(pos.x, pos.y + s)):
				grounded = true
				vel.y = 0.0
				break
			pos.y += s
			dy -= s
	# grawitacja+=1 runs on every airborne frame in the engine, rising included.
	vel.y = minf(vel.y + GRAVITY, TERMINAL)
	if vel.y >= 0.0:
		grounded = grounded or _blocked(Vector2(pos.x, pos.y + 1.0))

func _enemy_steps() -> void:
	for e in enemies:
		if not e["alive"]:
			continue
		var box := Vector2(e["w"], e["h"])
		# script_enemy_goomba: one pixel a frame, reversing when the next step is wall.
		var step_x: int = e["dir"]
		if _hit(Vector2(e["pos"].x + step_x, e["pos"].y - 1), box):
			step_x = -step_x
			e["dir"] = step_x
		if not _hit(Vector2(e["pos"].x + step_x, e["pos"].y), box):
			e["pos"].x += step_x
		if _hit(Vector2(e["pos"].x, e["pos"].y + 1), box):
			e["vy"] = 0.0
		else:
			e["vy"] = minf(e["vy"] + 0.5, 12.0)
			var drop: float = e["vy"]
			while drop != 0.0:
				var s := clampf(drop, -1.0, 1.0)
				if _hit(Vector2(e["pos"].x, e["pos"].y + s), box):
					break
				e["pos"].y += s
				drop -= s
		if e["pos"].y > room_size.y + 180.0:
			e["alive"] = false
			e["node"].visible = false

func _interactions() -> void:
	var me := Rect2(pos, BOX).grow(-2.0)
	for e in enemies:
		if not e["alive"]:
			continue
		var er := Rect2(e["pos"], Vector2(e["w"], e["h"]))
		if not er.intersects(me):
			continue
		# "y + 64 < lolo.y + 10" is GameMaker's stomp test: the feet have to clear the head.
		# It is purely positional, so a rising Mario with his boots above the enemy still stomps.
		if pos.y + BOX.y < e["pos"].y + 10.0:
			e["alive"] = false
			e["node"].visible = false
			kills += 1
			vel.y = JUMP
			grounded = false
			_sfx("stomp")
			if auto:
				print("step %d stomp at %s" % [steps, str(pos.round())])
		else:
			if auto:
				print("step %d hurt at %s enemy %s" % [steps, str(pos.round()), str(e["pos"].round())])
			_kill_player()
			return

func _kill_player(reason := "pit") -> void:
	if dying > 0:
		return            # the engine stops processing Mario once the death flag is set
	lives -= 1
	deaths += 1
	dying = 90
	vel = Vector2(0.0, -8.0)
	if auto:
		print("step %d died (%s) at %s lives %d" % [steps, reason, str(pos.round()), lives])
	_sfx("die")

func _death_step() -> void:
	dying -= 1
	vel.y = minf(vel.y + GRAVITY, TERMINAL)
	pos += vel
	if dying == 0:
		if lives < 0:
			lives = 4
			coin_count = 0
			red_count = 0
		_reset()

func _pickups() -> void:
	var r := Rect2(pos, BOX)
	for c in coins:
		if c["taken"] or not c["rect"].intersects(r):
			continue
		c["taken"] = true
		if c["node"] != null:
			c["node"].visible = false
		if c["red"]:
			red_count += 1
		else:
			coin_count += 1
		_sfx("coin")
	for cp in checkpoints:
		var at: Vector2 = cp["pos"]
		if cp["hit"] or not Rect2(at.x - 50.0, at.y - 200.0, 100.0, 200.0).intersects(r):
			continue
		cp["hit"] = true
		spawn = Vector2(at.x, at.y - 80.0)   # obj_mario Create: chpoint.x, chpoint.y - 80
		_sfx("checkpoint")

func _orbit(ang: float, radius: float) -> Vector2:
	return Vector2(sin(deg_to_rad(ang)) * radius, cos(deg_to_rad(ang)) * radius)

func _part(key: String, at: Vector2, rot_deg: float, flip: float) -> void:
	var s = parts.get(key)
	if s == null:
		return
	s.position = at
	s.rotation = deg_to_rad(rot_deg)
	s.scale = Vector2(1.0, flip)

func _animate() -> void:
	# script_anim_bieg / script_anim_stanie: the limbs swing by sin(run_kat) * run_promien
	# degrees, run_promien being 50 while running and 0 on the ground, torso leaning back.
	var moving := absf(vel.x) > 0.2 and grounded
	var lean := -minf(absf(vel.x) * 3.0, 10.0) if moving else 0.0
	var kat := -10.0 if moving else 0.0
	var prom := 50.0 if moving else 0.0
	run_kat -= 6.0 + absf(vel.x) * 3.0
	if not moving:
		run_kat = lerp(run_kat, 0.0, 0.2)
	var bob := sin(deg_to_rad(run_kat))
	var swing := bob * prom
	var bounce := bob / 2.0 if moving else 0.0
	_part("chest", Vector2(0, bounce), kat + bob + lean, 1.0)
	_part("head", _orbit(180.0 + kat, 10.0) + Vector2(0, bounce), kat + lean, 1.0)
	_part("leg_f", _orbit(20.0 + kat, 35.0 / 3.0), kat + swing, 1.0)
	_part("leg_b", _orbit(-22.0 + kat, 10.0), kat - swing - (0.0 if grounded else 30.0), 1.0)
	_part("arm_b", _orbit(150.0 + kat, 10.0) + Vector2(-lean / 10.0, 0), kat - swing - 15.0, 1.0)
	_part("arm_f", _orbit(220.0 + kat, 40.0 / 3.0) + Vector2(-lean / 10.0, 0),
		  235.0 + kat + swing, -1.0)
	rig.position = pos + Vector2(16, RIG_Y - (6.0 if not grounded else 0.0))
	rig.scale.x = facing

	for e in enemies:
		if not e["alive"]:
			continue
		var n: Node2D = e["node"]
		n.position = e["pos"]
		var w: float = e["w"]
		var h: float = e["h"]
		var body: Sprite2D = n.get_meta("body")
		body.position = Vector2(16 - w / 2.0, 15 - h / 2.0 + bob)
		body.scale.x = e["dir"]
		body.rotation = deg_to_rad(sin(deg_to_rad(steps * 6.0)) * 5.0)
		var legs: Array = n.get_meta("legs")
		legs[0].position = Vector2(5 - w / 2.0, 35 - h / 2.0 + bob * 2.0)
		legs[0].scale.x = e["dir"]
		legs[1].position = Vector2(24 - w / 2.0, 35 - h / 2.0 - bob * 2.0)
		legs[1].scale.x = -e["dir"]
	cam.position = pos + Vector2(BOX.x / 2.0, BOX.y / 2.0)

func _capture(path: String) -> void:
	if path == "" or DisplayServer.get_name() == "headless":
		return
	var tex := get_viewport().get_texture()
	if tex == null:
		print("no viewport texture -> skipped %s" % path)
		return
	var img := tex.get_image()
	if img == null:
		print("blank framebuffer -> skipped %s" % path)
		return
	img.save_png(path)
	print("saved %s" % path)

func _flow() -> void:
	if auto and dying == 0 and not cleared and _blocked(pos):
		# The body is inside a solid: no input can free it, because every step out is blocked too,
		# and the wall scan cannot see a face that is already behind the mask. Nudge out, and if the
		# geometry has no gap at all, treat it the way the engine does and drop back to the spawn.
		var free := _free_near(pos)
		print("step %d wedged at %s -> %s" % [steps, str(pos.round()), str(free.round())])
		if free.distance_to(pos) < 0.5:
			_reset()
		else:
			pos = free
			grounded = false
		stuck_clock = 0
	if auto:
		if windup > 0:
			windup -= 1
			if windup == 0:
				vel.x = 0.0     # otherwise the skid curve eats the whole run-up
		# Progress, not foot contact, decides whether we are wedged: bouncing off a step keeps
		# the body airborne, so a grounded-only test never sees the jam.
		if wall_jump > 0:
			stuck_clock = 0
			stuck_anchor = pos
		elif pos.distance_to(stuck_anchor) > 16.0:
			stuck_anchor = pos
			stuck_clock = 0
		else:
			stuck_clock += 1
			if stuck_clock >= 90:
				stuck_clock = 0
				windup = 120     # retreat until a jump clears, or this many frames, whichever first
				print("step %d windup at %s" % [steps, str(pos.round())])
	if dying == 0 and not no_time and not cleared:
		time_left = maxf(0.0, time_left - 1.0 / 60.0)
		if time_left <= 0.0:
			_kill_player()
	if dying == 0 and pos.y > death_y:
		_kill_player()
	if goal.size.x > 0 and cleared:
		clear_wait += 1
		if clear_wait > 90:
			_load(room_no + 1)
			return
	elif goal.size.x > 0 and not cleared and goal.intersects(Rect2(pos, BOX)):
		cleared = true
		run_kat = 0.0
		# o_koniec_etapu pays by how high on the flagpole Mario grabs it.
		var top := goal.position.y
		if top > pos.y:
			points += 10000
		elif top + 64.0 > pos.y:
			points += 1000
		elif top + 128.0 > pos.y:
			points += 500
		elif top + 256.0 > pos.y:
			points += 250
		elif top + 300.0 > pos.y:
			points += 100
		else:
			points += 1
		_sfx("clear")
		if auto:
			var cline := "step %d CLEARED %s at %s (coins %d stomps %d points %d)" % [
				steps, data["name"], str(pos.round()), coin_count, kills, points]
			log_lines.append(cline)
			print(cline)

	if auto:
		hud.text = "%s\ncoins %d   red %d   stomps %d   lives %d   deaths %d   time %d   %d pt   %s%s" % [
			data["name"], coin_count, red_count, kills, lives, deaths, int(time_left), points,
			"ground" if grounded else "air", "   LEVEL CLEAR" if cleared else ""]
	else:
		hud.text = "%s\ncoins %d   red %d   stomps %d   lives %d   deaths %d   time %d   %d pt\n%s\narrows/WASD move   Z/Space jump   X/Shift run   M sound" % [
			data["name"], coin_count, red_count, kills, lives, deaths, int(time_left), points,
			"LEVEL CLEAR" if cleared else ("   " if grounded else "in the air")]

	if auto and steps % 120 == 0:
		var line := "step %d room %s pos %s vel %s %s (coins %d stomps %d deaths %d clear %s)" % [
			steps, data["name"], str(pos.round()), str(vel.round()),
			"ground" if grounded else "air", coin_count, kills, deaths, cleared]
		log_lines.append(line)
		print(line)
	if auto and steps == 300:
		_capture(shot.replace(".png", "_early.png"))
	if auto and steps >= max_steps:
		print("done: room %s coins %d red %d stomps %d deaths %d lives %d time %d pos %s" % [
			data["name"], coin_count, red_count, kills, deaths, lives, int(time_left), str(pos.round())])
		_capture(shot)
		get_tree().quit()


# Running this dev slice on its own (F6) now boots the real game; the cut-down
# slice stays available when CLI args are passed.
func _launch_full_game() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	var game: Node = load("res://scenes/game.tscn").instantiate()
	get_tree().root.add_child.call_deferred(game)
	get_tree().set_deferred("current_scene", game)
	queue_free()
