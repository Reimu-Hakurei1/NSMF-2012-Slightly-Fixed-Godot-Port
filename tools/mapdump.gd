extends SceneTree

## Dumps world-map nodes and the level graph they point at.
##   godot --headless --path . --script res://tools/mapdump.gd

var frames: int = 0
var stage: int = 0
var wait: int = 0
var settle: int = 470
var map_rooms: Array = []
var mi: int = 0


func _initialize() -> void:
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)
	for a in OS.get_cmdline_user_args():
		map_rooms.append(int(a))
	if map_rooms.is_empty():
		map_rooms = [273]


func _process(_delta: float) -> bool:
	frames += 1
	if stage == 0:
		if frames < settle:
			return false
		R.room_goto(null, int(map_rooms[0]))
		stage = 1
		wait = 0
		return false
	if stage == 1:
		wait += 1
		if wait < 10:
			return false
		var rows: Array = []
		for inst in R.instances:
			if not inst.alive or int(inst.g_object_index) != 828:
				continue
			var gl := int(R.member_get(inst, "g_goto_level"))
			if gl <= 0:
				continue
			rows.append([
				str(R.member_get(inst, "g_level_name")), gl,
				int(R.member_get(inst, "g_completed")),
				int(R.member_get(inst, "g_bonus_level")),
				int(R.member_get(inst, "g_generuj_statek")),
				int(R.member_get(inst, "g_posiada_brame")),
				int(R.member_get(inst, "g_id")),
				int(inst.position.x), int(inst.position.y)])
		rows.sort_custom(func(a, b): return a[0] < b[0])
		for r in rows:
			print("NODE map=%d name=%s goto=%d comp=%d bonus=%d statek=%d gate=%d id=%d pos=%d,%d" % [
				R.room, r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8]])
		print("NODE map=%d total=%d" % [R.room, rows.size()])
		mi += 1
		if mi >= map_rooms.size():
			quit(0)
			return true
		R.room_goto(null, int(map_rooms[mi]))
		wait = 0
		return false
	return false
