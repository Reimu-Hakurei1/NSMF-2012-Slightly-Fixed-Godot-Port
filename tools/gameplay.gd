extends SceneTree

## Behavioural checks: mushroom pickup, goomba stomp, power star.
##   godot --headless --path . --script res://tools/gameplay.gd

var frames: int = 0
var stage: int = 0
var wait: int = 0
var settle: int = 470
var mario: GMInstance = null
var before_kind: Variant = 0


func _initialize() -> void:
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)


func _find_mario() -> GMInstance:
	for inst in R.instances:
		if inst.alive and int(inst.g_object_index) == 303:
			return inst
	return null


func _count_obj(oid: int) -> int:
	var n := 0
	for inst in R.instances:
		if inst.alive and int(inst.g_object_index) == oid:
			n += 1
	return n


func _process(_delta: float) -> bool:
	frames += 1
	if stage == 0:
		if frames < settle:
			return false
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
			print("PLAY FAIL no mario")
			quit(1)
			return true
		G.blokuj_ruch_na_title_screenie = 0
		G.mario_wszedl_do_etapu = 0
		mario.g_sekwencja = 1
		before_kind = G.rodzaj_mario
		print("PLAY room=%d mario id=%d pos=%s kind=%s points=%s" % [
			R.room, mario.inst_id, str(mario.position), str(G.rodzaj_mario), str(G.punkty)])
		R.instance_create(mario, mario.position.x + 16, mario.position.y + 32, 23)
		stage = 2
		wait = 0
		return false
	if stage == 2:
		wait += 1
		if wait < 10:
			return false
		print("PLAY mushroom kind=%s (was %s) points=%s mushrooms=%d" % [
			str(G.rodzaj_mario), str(before_kind), str(G.punkty), _count_obj(23)])
		var grown := int(G.rodzaj_mario) != int(before_kind)
		R.instance_create(mario, mario.position.x + 60, mario.position.y + 8, 124)
		stage = 3
		wait = 0
		return false
	if stage == 3:
		wait += 1
		if wait < 90:
			return false
		print("PLAY goomba after=%d mario_alive=%s kind=%s lives=%s" % [
			_count_obj(124), str(mario != null and mario.alive),
			str(G.rodzaj_mario), str(G.zycia)])
		if mario == null or not mario.alive:
			mario = _find_mario()
			if mario != null:
				mario.g_sekwencja = 1
		if mario != null:
			R.instance_create(mario, mario.position.x + 16, mario.position.y + 32, 26)
		stage = 4
		wait = 0
		return false
	if stage == 4:
		wait += 1
		if wait < 10:
			return false
		print("PLAY star star_time=%s stars=%d inst=%d" % [
			str(R.member_get(mario, "g_power_star_time")) if mario != null else "n/a",
			_count_obj(26), R.instances.size()])
		print("PLAY DONE kind=%s points=%s lives=%s" % [
			str(G.rodzaj_mario), str(G.punkty), str(G.zycia)])
		quit(0)
		return true
	return false
