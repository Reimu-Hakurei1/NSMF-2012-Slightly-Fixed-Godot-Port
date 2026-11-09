extends SceneTree

## Headless playtest: boots the game, drops into 1-1, holds right and jumps,
## and reports whether Mario actually moves through the level.

var frames: int = 0
var phase: int = 0
var wait: int = 0
var settle: int = 470
var mario: GMInstance = null
var start_x: float = 0.0
var max_x: float = 0.0
var jump_hold: int = 0


func _initialize() -> void:
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)


func _find_mario() -> GMInstance:
	for inst in R.instances:
		if inst.alive and int(inst.g_object_index) == 303:
			return inst
	return null


func _process(_delta: float) -> bool:
	frames += 1
	if phase == 0:
		if frames < settle:
			return false
		print("PLAY boot room=%d keys right=%s jump=%s" % [
			R.room, str(G.ster_right), str(G.ster_jump)])
		R.room_goto(null, 3)
		phase = 1
		wait = 0
		return false
	if phase == 1:
		wait += 1
		if wait < 4:
			return false
		mario = _find_mario()
		if mario == null:
			print("PLAY FAIL no mario in room=%d inst=%d" % [R.room, R.instances.size()])
			quit(1)
			return true
		start_x = mario.position.x
		max_x = start_x
		G.blokuj_ruch_na_title_screenie = 0
		G.mario_wszedl_do_etapu = 0
		print("PLAY room=%d mario id=%d start=%s inst=%d" % [
			R.room, mario.inst_id, str(mario.position), R.instances.size()])
		phase = 2
		wait = 0
		return false
	if phase == 2:
		wait += 1
		R.keyboard_key_press(null, int(G.ster_right))
		jump_hold += 1
		if jump_hold <= 8 or (jump_hold > 40 and jump_hold <= 48):
			R.keyboard_key_press(null, int(G.ster_jump))
		else:
			R.keyboard_key_release(null, int(G.ster_jump))
		if jump_hold > 80:
			jump_hold = 0
		if mario == null or not mario.alive:
			print("PLAY mario lost at frame=%d room=%d lives=%s" % [
				wait, R.room, str(G.zycia)])
			mario = _find_mario()
			if mario != null:
				max_x = maxf(max_x, mario.position.x)
		else:
			max_x = maxf(max_x, mario.position.x)
		if wait % 150 == 0:
			print("PLAY tick=%d room=%d x=%s y=%s maxx=%s lives=%s coins=%s inst=%d" % [
				wait, R.room,
				str(mario.position.x) if mario != null and mario.alive else "n/a",
				str(mario.position.y) if mario != null and mario.alive else "n/a",
				str(max_x), str(G.zycia), str(G.coins), R.instances.size()])
		if wait >= 900:
			R.keyboard_key_release(null, int(G.ster_right))
			R.keyboard_key_release(null, int(G.ster_jump))
			print("PLAY DONE room=%d start=%s maxx=%s gained=%s lives=%s inst=%d" % [
				R.room, str(start_x), str(max_x), str(max_x - start_x),
				str(G.zycia), R.instances.size()])
			quit(0 if max_x - start_x > 50.0 else 2)
			return true
	return false
