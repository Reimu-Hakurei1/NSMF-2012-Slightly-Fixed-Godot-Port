extends SceneTree

func _initialize() -> void:
	var t0 := Time.get_ticks_usec()
	load("res://tools/big.gd")
	print("big_ms=%.1f" % ((Time.get_ticks_usec() - t0) / 1000.0))
	quit(0)
