extends SceneTree

## Scripted world tour: enters every level node on all 8 world maps, completes
## each via its flagpole, returns to the map, then fights and defeats Bowser.
##   godot --headless --path . --script res://tools/progress.gd

var frames: int = 0
var settle: int = 470
var maps: Array = [273, 266, 272, 271, 270, 269, 268, 267]
var mi: int = 0
var stage: int = 0
var wait: int = 0
var nodes: Array = []
var ni: int = 0
var cur_map: int = 0
var level_room: int = -1
var entry_frames: int = 0
var entry_tick: int = 0
var ret_tick: int = 0
var stats: Dictionary = {"entries": 0, "returns": 0, "stuck": 0, "no_flag": 0, "deaths": 0}
var map_stats: Array = []
var only_map: int = -1
var boss_only: bool = false
var total_nodes: int = 0
var total_returns: int = 0
var total_stuck: int = 0
var total_noflag: int = 0
var savedir: String = ""


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--map="):
			only_map = int(a.substr(6))
		elif a == "--boss":
			boss_only = true
		elif a.begins_with("--savedir="):
			savedir = a.substr(10).replace("\\", "/")
			DirAccess.make_dir_recursive_absolute(savedir)
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)


func _find(oid: int) -> Array:
	var out: Array = []
	for inst in R.instances:
		if inst.alive and int(inst.g_object_index) == oid:
			out.append(inst)
	return out


func _level_rank(name: String) -> Array:
	var parts := name.split("-")
	if parts.size() != 2 or not parts[0].is_valid_int() or not parts[1].is_valid_int():
		return [99, 99]
	return [int(parts[0]), int(parts[1])]


func _collect_nodes() -> Array:
	var out: Array = []
	for inst in _find(828):
		var gl := int(R.member_get(inst, "g_goto_level"))
		var nm := str(R.member_get(inst, "g_level_name"))
		if gl > 0 and nm != "":
			out.append([nm, gl, inst.position])
	out.sort_custom(func(a, b): return _level_rank(a[0]) < _level_rank(b[0]))
	return out


func _map_player() -> GMInstance:
	var ps := _find(831)
	return ps[0] if not ps.is_empty() else null


func _enter_map(idx: int) -> void:
	cur_map = maps[idx]
	G.pauza = 0
	R.room_goto(null, cur_map)
	stage = 1
	wait = 0


func _process(_delta: float) -> bool:
	frames += 1
	# Keep the sweep away from the player's real appdata saves.
	if savedir != "" and R.working_directory != savedir:
		R.working_directory = savedir
	if stage == 0:
		if R.room != 324 or frames < settle:
			return false
		print("PROG boot room=%d" % R.room)
		mi = 0
		ni = 0
		if boss_only:
			stage = 6
			return false
		if only_map >= 0:
			mi = only_map
		_enter_map(mi)
		return false
	if stage == 1:
		wait += 1
		if wait < 6:
			return false
		nodes = _collect_nodes()
		ni = 0
		print("PROG map=%d nodes=%d" % [cur_map, nodes.size()])
		stats["entries"] = 0
		stats["returns"] = 0
		stats["stuck"] = 0
		stats["no_flag"] = 0
		stage = 2
		return false
	if stage == 2:
		if ni >= nodes.size():
			map_stats.append([cur_map, nodes.size(), int(stats["returns"]), int(stats["stuck"]), int(stats["no_flag"])])
			print("PROG map=%d SUMMARY nodes=%d returns=%d stuck=%d noflag=%d" % [
				cur_map, nodes.size(), stats["returns"], stats["stuck"], stats["no_flag"]])
			total_nodes += nodes.size()
			total_returns += int(stats["returns"])
			total_stuck += int(stats["stuck"])
			total_noflag += int(stats["no_flag"])
			if only_map >= 0:
				print("PROG MAPDONE map=%d nodes=%d returns=%d stuck=%d noflag=%d" % [
					cur_map, total_nodes, total_returns, total_stuck, total_noflag])
				quit(0)
				return true
			mi += 1
			if mi >= maps.size():
				stage = 6
				return false
			_enter_map(mi)
			return false
		var row: Array = nodes[ni]
		var p := _map_player()
		if p == null:
			print("PROG FAIL no map player on map=%d" % cur_map)
			quit(1)
			return true
		p.position = row[2]
		R.member_set(p, "g_idzie", 0)
		G.mario_wszedl_do_etapu = 0
		level_room = int(row[1])
		entry_frames = 0
		entry_tick = R.tick_count
		R.keyboard_key_press(null, 90)
		stage = 3
		wait = 0
		return false
	if stage == 3:
		wait += 1
		entry_frames += 1
		if R.room != cur_map:
			R.keyboard_key_release(null, 90)
			print("PROG ENTER map=%d name=%s goto=%d room=%d name=%s" % [
				cur_map, nodes[ni][0], level_room, R.room, R.room_caption])
			stage = 4
			wait = 0
			return false
		# Tap Z in short bursts: holding it keeps script_map_control from clearing
		# g_klickersus, and a single tap lands during the post-level bounce animation.
		if wait % 40 == 1:
			R.keyboard_key_press(null, 90)
		elif wait % 40 == 4:
			R.keyboard_key_release(null, 90)
		if R.tick_count - entry_tick > 900:
			R.keyboard_key_release(null, 90)
			var p := _map_player()
			print("PROG STUCK map=%d name=%s goto=%d room=%d gate=%s zone=%s kilk=%s delay=%s wzszedl=%s seq=%s podsk=%s timer=%s anim=%s idzie=%s" % [
				cur_map, nodes[ni][0], level_room, R.room,
				str(R.place_meeting(p, p.x, p.y, 828)) if p != null else "nop",
				str(p.position) if p != null else "-",
				str(R.get_obj_var(827, "g_klickersus")),
				str(G.delayer), str(G.mario_wszedl_do_etapu), str(G.map_completed_sequence),
				str(R.member_get(p, "g_podskocz_po_gameover")) if p != null else "-",
				str(R.member_get(p, "g_wlacz_etap_timer")) if p != null else "-",
				str(R.member_get(p, "g_animacja_wchodzenia_do_etapu")) if p != null else "-",
				str(R.member_get(p, "g_idzie")) if p != null else "-"])
			stats["stuck"] += 1
			ni += 1
			stage = 2
			wait = 0
		return false
	if stage == 4:
		wait += 1
		if R.tick_count - entry_tick < 30:
			return false
		var flags := _find(288)
		if flags.is_empty():
			print("PROG NOFLAG room=%d name=%s" % [R.room, R.room_caption])
			stats["no_flag"] += 1
			R.room_goto(null, cur_map)
			stage = 5
			wait = 0
			return false
		R.member_set(flags[0], "g_local_global", 4)
		R.member_set(flags[0], "g_przejdz_na_mape", 121)
		ret_tick = R.tick_count
		stage = 5
		wait = 0
		return false
	if stage == 5:
		wait += 1
		if R.room == cur_map:
			print("PROG RETURN map=%d from=%d after=%d lives=%s" % [
				cur_map, level_room, wait, str(G.zycia)])
			stats["returns"] += 1
			stage = 9
			wait = 10
			return false
		if R.tick_count - ret_tick > 900:
			print("PROG NORETURN room=%d name=%s from=%d lives=%s" % [
				R.room, R.room_caption, level_room, str(G.zycia)])
			stats["stuck"] += 1
			R.pending_room = null
			R.room_goto(null, cur_map)
			stage = 5
			wait = 0
		return false
	if stage == 9:
		wait -= 1
		if wait > 0:
			return false
		ni += 1
		stage = 2
		return false
	if stage == 6:
		print("PROG ALLMAPS done nodes=%d returns=%d stuck=%d noflag=%d" % [
			total_nodes, total_returns, total_stuck, total_noflag])
		R.room_goto(null, 205)
		stage = 7
		wait = 0
		return false
	if stage == 7:
		wait += 1
		if wait < 30:
			return false
		var bowsers := _find(376)
		if bowsers.is_empty():
			print("PROG BOSS missing")
			quit(2)
			return true
		print("PROG BOSS room=%d bowser=%d inst=%d" % [R.room, bowsers.size(), R.instances.size()])
		R.member_set(bowsers[0], "g_energy", 0)
		R.member_set(bowsers[0], "g_timeron", 600)
		stage = 8
		wait = 0
		return false
	if stage == 8:
		wait += 1
		if wait % 120 == 0:
			print("PROG BOSS tick=%d room=%d bowser=%d die=%d" % [
				wait, R.room, _find(376).size(), _find(706).size()])
		if R.room == 310:
			print("PROG END reached room=310 %s after=%d frames" % [R.room_caption, wait])
			quit(0)
			return true
		if wait > 2400:
			print("PROG END FAIL room=%d bowser=%d die=%d" % [
				R.room, _find(376).size(), _find(706).size()])
			quit(2)
			return true
		return false
	return false
