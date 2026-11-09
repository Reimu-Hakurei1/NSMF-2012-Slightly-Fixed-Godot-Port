extends SceneTree

## Measures boot cost and per-room load cost across the whole game.
##   godot --headless --path . --script res://tools/timing.gd

var frames: int = 0
var started: bool = false
var order: Array = []
var idx: int = 0
var settle: int = 5
var wait: int = 0
var t_boot: int = 0
var total_load: int = 0
var slow: Array = []
var loaded_sprites: int = 0
var loaded_frames: int = 0


func _initialize() -> void:
	var t0 := Time.get_ticks_usec()
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)
	t_boot = Time.get_ticks_usec() - t0
	R.debug_load = true
	var tb := Time.get_ticks_usec()
	for i in 1000:
		R.object_script(303)
	var ti := Time.get_ticks_usec() - tb
	tb = Time.get_ticks_usec()
	for i in 1000:
		R.object_script(303.0)
	print("TIMING object_script_1000 int_ms=%.1f float_ms=%.1f cached=%d" % [
		ti / 1000.0, (Time.get_ticks_usec() - tb) / 1000.0, R.obj_scripts.size()])


func _process(_delta: float) -> bool:
	frames += 1
	if not started:
		if frames < settle:
			return false
		started = true
		order = R.room_order
		print("TIMING boot_ms=%.1f rooms=%d sprites_cached=%d" % [
			t_boot / 1000.0, order.size(), R.sprites.size()])
		return false
	wait += 1
	if wait < 3:
		return false
	wait = 0
	if idx >= order.size():
		_report()
		quit(0)
		return true
	var rid := int(order[idx])
	idx += 1
	var t0 := Time.get_ticks_usec()
	R.room_goto(null, rid)
	R.step()
	var dt := Time.get_ticks_usec() - t0
	total_load += dt
	if dt > 50000:
		slow.append([rid, R.room_caption, dt / 1000.0, R.instances.size()])
		print("TIMING slow room=%d name=%s load_ms=%.1f inst=%d" % [
			rid, R.room_caption, dt / 1000.0, R.instances.size()])
	return false


func _report() -> void:
	for s in R.sprites.values():
		if s["loaded"]:
			loaded_sprites += 1
			loaded_frames += s["frames"].size()
	print("TIMING total_rooms=%d total_load_ms=%.1f avg_ms=%.1f slow=%d sprites_loaded=%d frames_loaded=%d" % [
		order.size(), total_load / 1000.0, total_load / 1000.0 / maxi(1, order.size()),
		slow.size(), loaded_sprites, loaded_frames])
