extends SceneTree

## Boots the real game, jumps to a room, and saves the first N rendered frames
## after the transition so a one-frame backdrop flash can be inspected.
##   godot --path . --script res://tools/flash_shot.gd -- <room> <outdir> [count]

var target: int = 264
var outdir: String = "C:/Users/Alex/gm8tools/shots/flash"
var count: int = 8
var frames: int = 0
var jumped: bool = false
var since: int = -1


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		target = int(args[0])
	if args.size() > 1:
		outdir = args[1]
	if args.size() > 2:
		count = int(args[2])
	DirAccess.make_dir_recursive_absolute(outdir)
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)


func _process(_delta: float) -> bool:
	frames += 1
	if frames == 480 and not jumped:
		jumped = true
		R.room_goto(null, target)
		since = 0
		return false
	if jumped:
		since += 1
		if since <= count:
			var img := root.get_viewport().get_texture().get_image()
			img.save_png(outdir.path_join("f%02d.png" % since))
			var cam := R.camera
			var br := R.bg_rect
			print("FLASH f=%d room=%d cam=(%.0f,%.0f) zoom=(%.2f,%.2f) bgrect=(%.0f,%.0f,%.0f,%.0f) view=(%.0f,%.0f,%.0f,%.0f) bgcol=%s" % [
				since, R.room, cam.position.x, cam.position.y, cam.zoom.x, cam.zoom.y,
				br.position.x, br.position.y, br.size.x, br.size.y,
				R.view_xview[0], R.view_yview[0], R.view_wview[0], R.view_hview[0], R.room_bg_colour])
		if since > count:
			quit(0)
			return true
	return false