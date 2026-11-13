extends SceneTree

## Boots the real game, jumps to a room, lets it settle, and saves a live render.
##   godot --path . --script res://tools/audit_shot.gd -- <room> <out.png> [frames]

var target: int = 264
var out: String = "C:/Users/Alex/gm8tools/shots/shot.png"
var settle: int = 200
var frames: int = 0
var jumped: bool = false


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		target = int(args[0])
	if args.size() > 1:
		out = args[1]
	if args.size() > 2:
		settle = int(args[2])
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)


func _process(_delta: float) -> bool:
	frames += 1
	if frames == 480 and not jumped:
		jumped = true
		R.room_goto(null, target)
	if frames >= 480 + settle:
		var img := root.get_viewport().get_texture().get_image()
		img.save_png(out)
		print("SHOT room=%d name=%s saved=%s" % [R.room, R.room_caption, out])
		quit(0)
		return true
	return false