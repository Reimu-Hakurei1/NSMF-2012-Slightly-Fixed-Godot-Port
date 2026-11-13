extends SceneTree

## Whole-game audit: loads and ticks every room, aggregating R.warnings and
## attributing new warning keys to the room that produced them. Engine SCRIPT
## ERRORs are printed between "AUDIT room=" markers so the run log can be parsed.
##   godot --headless --path . --script res://tools/audit_sweep.gd -- [frames] [out.json]

var frames: int = 0
var started: bool = false
var settle: int = 470
var order: Array = []
var idx: int = 0
var stop: int = 0
var per_room: int = 45
var room_frames: int = 0
var before: Dictionary = {}
var room_warnings: Dictionary = {}
var out_path: String = "C:/Users/Alex/gm8tools/shots/audit_warnings.json"


func _initialize() -> void:
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)


func _snapshot() -> Dictionary:
	var d: Dictionary = {}
	for k in R.warnings:
		d[k] = R.warnings[k]
	return d


func _diff(a: Dictionary, b: Dictionary) -> Dictionary:
	var d: Dictionary = {}
	for k in b:
		var delta: int = int(b[k]) - int(a.get(k, 0))
		if delta > 0:
			d[k] = delta
	return d


func _process(_delta: float) -> bool:
	frames += 1
	if not started:
		if frames < settle:
			return false
		order = R.room_order
		var args := OS.get_cmdline_user_args()
		if args.size() > 0:
			per_room = int(args[0])
		if args.size() > 1:
			out_path = args[1]
		stop = order.size()
		started = true
		print("AUDIT start %d rooms, %d frames each" % [stop, per_room])
		before = _snapshot()
		print("AUDIT room=%d name=%s" % [int(order[0]), "boot"])
		R.room_goto(null, int(order[0]))
		return false
	room_frames += 1
	if room_frames >= per_room:
		var rid: int = int(order[idx])
		var delta := _diff(before, _snapshot())
		if not delta.is_empty():
			room_warnings[str(rid)] = delta
		print("AUDIT room=%d inst=%d newwarn=%d" % [rid, R.instances.size(), delta.size()])
		before = _snapshot()
		room_frames = 0
		idx += 1
		if idx >= stop:
			_finish()
			return true
		print("AUDIT room=%d name=%s" % [int(order[idx]), "next"])
		R.room_goto(null, int(order[idx]))
	return false


func _finish() -> void:
	var agg: Dictionary = {}
	for k in R.warnings:
		agg[k] = R.warnings[k]
	var report := {
		"rooms": stop,
		"per_room_frames": per_room,
		"aggregate_warnings": agg,
		"room_warnings": room_warnings,
	}
	var f := FileAccess.open(out_path, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(report, "\t"))
		f.close()
	print("AUDIT done rooms=%d warning_keys=%d" % [stop, agg.size()])
	print("AUDIT_AGG " + JSON.stringify(agg))
	quit(0)