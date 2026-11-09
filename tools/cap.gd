extends SceneTree

var frames: int = 0
var target: int = 262
var phase: int = 0
var wait: int = 0


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if not a.begins_with("--") and int(a) > 0:
			target = int(a)
	root.add_child(load("res://scenes/game.tscn").instantiate())


func _process(_d: float) -> bool:
	frames += 1
	if phase == 0:
		if R.room == 324 or frames > 900:
			phase = 1
			wait = 0
		return false
	if phase == 1:
		wait += 1
		if wait == 10:
			R.room_goto(null, target)
			phase = 2
			wait = 0
		return false
	wait += 1
	if wait == 120:
		var img: Image = root.get_texture().get_image()
		img.save_png("res://cap_%d.png" % target)
		print("CAP room=%d target=%d" % [R.room, target])
		quit()
		return true
	return false
