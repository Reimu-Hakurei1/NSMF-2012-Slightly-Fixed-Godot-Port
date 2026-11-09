extends SceneTree

## Soak-tests specific rooms by id: loads each, ticks it, reports instance counts.
##   godot --headless --path . --script res://tools/roomsoak.gd -- 205 14 264

var frames: int = 0
var started: bool = false
var settle: int = 470
var ids: Array = []
var per_room: int = 600
var idx: int = 0
var wait: int = 0
var results: Array = []


func _initialize() -> void:
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)


func _process(_delta: float) -> bool:
	frames += 1
	if not started:
		if frames < settle:
			return false
		for a in OS.get_cmdline_user_args():
			ids.append(int(a))
		if ids.is_empty():
			ids = [205, 14, 17, 40, 47, 56, 61, 75, 83, 99, 109, 124, 131, 134, 135, 261, 264]
		started = true
		print("SOAK start rooms=%s frames=%d" % [str(ids), per_room])
		R.room_goto(null, int(ids[0]))
		return false
	wait += 1
	if wait >= per_room:
		print("SOAK room=%d inst=%d ticks=%d" % [R.room, R.instances.size(), wait])
		results.append(R.room)
		idx += 1
		if idx >= ids.size():
			print("SOAK done %d rooms" % results.size())
			quit(0)
			return true
		R.room_goto(null, int(ids[idx]))
		wait = 0
	return false
