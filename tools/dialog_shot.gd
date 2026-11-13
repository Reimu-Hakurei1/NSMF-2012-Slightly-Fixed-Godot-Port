extends SceneTree

## Boots the game, enters 1-1, spawns the speech-bubble dialog (obj 331) with the
## walljump text anchored to Mario, lets it render, and saves a screenshot.
##   godot --path . --script res://tools/dialog_shot.gd -- <out.png>

var out: String = "C:/Users/Alex/gm8tools/shots/dialog.png"
var frames: int = 0
var spawned: bool = false


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		out = args[0]
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)


func _process(_delta: float) -> bool:
	frames += 1
	if frames == 480 and not spawned:
		spawned = true
		R.room_goto(null, 264)
	if spawned and frames == 700:
		var mario = null
		for m in R.with_ids(null, 303):
			mario = m
			break
		var d = R.instance_create(null, 400, 300, 331)
		if d != null and mario != null:
			R.inst_set(d, "tekst", "Welcome Mario to New Mario Forever 2012! Mario time to lear something about walljumping! Do you know what is walljump? I can tell you.. First off jump into wall, next press opposite direction button and jump button! Try it on this wall behind us! ")
			R.inst_set(d, "nalezy_do", mario)
			R.inst_set(d, "show_pic", 1)
	if spawned and frames >= 840:
		var img := root.get_viewport().get_texture().get_image()
		img.save_png(out)
		print("DIALOG_SHOT saved=%s" % out)
		quit(0)
		return true
	return false