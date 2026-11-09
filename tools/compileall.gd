extends SceneTree

## Loads every generated script and reports failures plus per-directory timings.

func _initialize() -> void:
	load("res://runtime/r.gd")
	for d in ["res://gen/scripts", "res://gen/room_code", "res://gen/objects"]:
		var t := Time.get_ticks_usec()
		var fails := 0
		var count := 0
		var da := DirAccess.open(d)
		for f in da.get_files():
			if not f.ends_with(".gd"):
				continue
			count += 1
			if load(d + "/" + f) == null:
				fails += 1
				print("COMPILEALL FAIL %s/%s" % [d, f])
		print("COMPILEALL %s files=%d fails=%d ms=%.0f" % [
			d, count, fails, (Time.get_ticks_usec() - t) / 1000.0])
	quit(0)
