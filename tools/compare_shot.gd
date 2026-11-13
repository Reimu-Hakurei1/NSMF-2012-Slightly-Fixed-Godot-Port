extends SceneTree

## Boots to the title screen, jumps to a room, waits for the entry fade to finish
## and saves one settled frame plus the view rect for preview comparisons.
##   godot --path . --script res://tools/compare_shot.gd -- <room> <out>

var target: int = 264
var out: String = "C:/Users/Alex/gm8tools/shots/compare.png"
var at: int = 150
var frames: int = 0
var jumped: bool = false
var since: int = 0


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		target = int(args[0])
	if args.size() > 1:
		out = args[1]
	if args.size() > 2:
		at = int(args[2])
	root.add_child(load("res://scenes/game.tscn").instantiate())


func _process(_delta: float) -> bool:
	frames += 1
	if not jumped:
		if R.room == 324:
			jumped = true
			R.room_goto(null, target)
		return false
	since += 1
	if since == at:
		root.get_viewport().get_texture().get_image().save_png(out)
		print("COMPARE room=%d view=%.0f,%.0f,%.0f,%.0f cam=%.0f,%.0f" % [
			R.room, R.view_xview[0], R.view_yview[0], R.view_wview[0], R.view_hview[0],
			R.camera.position.x, R.camera.position.y])
		quit(0)
		return true
	return false