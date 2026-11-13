extends SceneTree

## Boots the game, opens the in-game level editor, and screenshots the canvas so
## the preview can be compared against the running game scene.
##   godot --path . --script res://tools/editor_shot.gd -- <out.png> [template_id]

var out: String = "C:/Users/Alex/gm8tools/shots/editor.png"
var template: int = -1
var frames: int = 0
var game: Node = null
var opened: bool = false


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		out = args[0]
	if args.size() > 1:
		template = int(args[1])
	game = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)


func _process(_delta: float) -> bool:
	frames += 1
	if frames == 600 and not opened:
		opened = true
		game.open_level_editor()
	if opened and frames == 640 and template >= 0:
		var ed = game._editor
		for i in range(ed._templates.item_count):
			if ed._templates.get_item_id(i) == template:
				ed._templates.select(i)
				break
		ed._from_template()
		ed._fit()
	if opened and frames >= 760:
		var img := root.get_viewport().get_texture().get_image()
		img.save_png(out)
		print("EDITOR_SHOT saved=%s" % out)
		quit(0)
		return true
	return false