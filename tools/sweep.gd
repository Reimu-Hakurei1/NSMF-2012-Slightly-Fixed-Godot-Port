extends SceneTree

## Loads rooms one at a time and ticks each briefly, so engine errors can be attributed
## to the room that produced them.  Usage:
##   godot --headless --path . --script res://tools/sweep.gd -- [first] [count] [frames]

var frames: int = 0
var order: Array = []
var idx: int = 0
var stop: int = 0
var per_room: int = 10
var room_frames: int = 0
var started: bool = false
var settle: int = 470


func _initialize() -> void:
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)


func _process(_delta: float) -> bool:
	frames += 1
	if not started:
		if frames < settle:
			return false
		order = R.room_order
		var args := OS.get_cmdline_user_args()
		if args.size() > 0:
			idx = int(args[0])
		if args.size() > 1:
			per_room = int(args[2]) if args.size() > 2 else per_room
			stop = mini(order.size(), idx + int(args[1]))
		else:
			stop = order.size()
		if stop <= idx:
			print("SWEEP nothing to do (%d rooms)" % order.size())
			quit(0)
			return true
		started = true
		print("SWEEP start %d..%d of %d, %d frames each" % [idx, stop, order.size(), per_room])
		R.room_goto(null, int(order[idx]))
		return false
	if room_frames == 0:
		print("SWEEP room=%d name=%s inst=%d" % [
			R.room, R.room_caption, R.instances.size()])
	room_frames += 1
	if room_frames >= per_room:
		room_frames = 0
		idx += 1
		if idx >= stop:
			print("SWEEP done %d rooms" % stop)
			quit(0)
			return true
		R.room_goto(null, int(order[idx]))
	return false
