extends SceneTree

## Death flow check: enter 1-3 with a valid map return set, let a goomba kill
## Mario, and verify the death animation returns to the world map with -1 life.
##   godot --headless --path . --script res://tools/deathtest.gd

var frames: int = 0
var stage: int = 0
var wait: int = 0
var settle: int = 470
var mario: GMInstance = null
var lives_before: Variant = 0


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
	if stage == 0:
		if frames < settle:
			return false
		G.return_name_of_map = 273
		G.zycia = 4
		R.room_goto(null, 13)
		stage = 1
		wait = 0
		return false
	if stage == 1:
		wait += 1
		if wait < 10:
			return false
		mario = _find_mario()
		if mario == null:
			print("DEATH FAIL no mario")
			quit(1)
			return true
		G.blokuj_ruch_na_title_screenie = 0
		G.mario_wszedl_do_etapu = 0
		mario.g_sekwencja = 1
		mario.g_power_star_time = 0
		mario.g_star_music_tick_switch = 0
		lives_before = G.zycia
		R.instance_create(mario, mario.position.x + 16, mario.position.y + 32, 124)
		print("DEATH room=%d lives=%s kind=%s star=%s" % [
			R.room, str(G.zycia), str(G.rodzaj_mario),
			str(R.member_get(mario, "g_power_star_time"))])
		stage = 2
		wait = 0
		return false
	if stage == 2:
		wait += 1
		if R.room == 273:
			print("DEATH returned room=273 after=" + str(wait) + " frames lives=" + str(G.zycia) \
				+ " (was " + str(lives_before) + ") mapplayers=" + str(_count(831)))
			quit(0 if int(G.zycia) == int(lives_before) - 1 else 2)
			return true
		if wait == 60:
			print("DEATH mid room=%d lives=%s dies_obj=%d" % [
				R.room, str(G.zycia), _count(332)])
		if wait > 400:
			print("DEATH FAIL room=%d lives=%s dies_obj=%d alive_mario=%s" % [
				R.room, str(G.zycia), _count(332), str(mario != null and mario.alive)])
			quit(1)
			return true
	return false


func _count(oid: int) -> int:
	var n := 0
	for inst in R.instances:
		if inst.alive and int(inst.g_object_index) == oid:
			n += 1
	return n
