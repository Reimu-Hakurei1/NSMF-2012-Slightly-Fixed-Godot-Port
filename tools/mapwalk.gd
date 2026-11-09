extends SceneTree

## Headless world-map check: boots the game, jumps to room_map_1, teleports the
## map player onto a real level node, presses jump, and verifies the level boots.

var frames: int = 0
var stage: int = 0
var wait: int = 0
var settle: int = 470
var player: GMInstance = null
var node: GMInstance = null
var target_level: int = -1
var flag_rooms: Dictionary = {}


func _initialize() -> void:
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)


func _find_obj(oid: int) -> Array:
	var out: Array = []
	for inst in R.instances:
		if inst.alive and int(inst.g_object_index) == oid:
			out.append(inst)
	return out


func _process(_delta: float) -> bool:
	frames += 1
	if stage == 0:
		if frames < settle:
			return false
		print("MAPWALK boot room=%d" % R.room)
		print("KEYS cfg=%s exists=%s up=%s down=%s left=%s right=%s jump=%s fire=%s" % [
			str(G.config_filename), str(R.file_exists(R.room_ci, G.config_filename)),
			str(G.ster_up), str(G.ster_down), str(G.ster_left), str(G.ster_right),
			str(G.ster_jump), str(G.ster_fire)])
		var f: Variant = P3.hex_open(R.room_ci, [G.config_filename])
		print("KEYS hex_open=%s size=%s read7=%s" % [
			str(f), str(R.file_bin_size(R.room_ci, int(f))),
			str(P3.hex_read(R.room_ci, [f, 7, 90]))])
		P3.hex_close(R.room_ci, [f])
		P7.script_keys_init_real(R.room_ci, [])
		print("KEYS after reinit jump=%s left=%s right=%s up=%s down=%s" % [
			str(G.ster_jump), str(G.ster_left), str(G.ster_right), str(G.ster_up), str(G.ster_down)])
		R.room_goto(null, 273)
		stage = 1
		wait = 0
		return false
	if stage == 1:
		wait += 1
		if wait < 5:
			return false
		var players := _find_obj(831)
		print("MAPWALK map room=%d players=%d inst=%d" % [R.room, players.size(), R.instances.size()])
		if players.is_empty():
			print("MAPWALK FAIL no map player")
			quit(1)
			return true
		player = players[0]
		for rid in R.room_data.get("rooms", {}):
			for im in R.room_data["rooms"][rid].get("instances", []):
				if int(im[2]) == 288:
					flag_rooms[int(rid)] = true
					break
		for inst in _find_obj(828):
			var gl := int(R.member_get(inst, "g_goto_level"))
			if gl > 0 and flag_rooms.has(gl) \
					and int(R.member_get(inst, "g_bonus_level")) != 1 \
					and int(R.member_get(inst, "g_generuj_statek")) != 2:
				node = inst
				target_level = gl
				break
		if node == null:
			for inst in _find_obj(828):
				var gl2 := int(R.member_get(inst, "g_goto_level"))
				if gl2 > 0 and int(R.member_get(inst, "g_bonus_level")) != 1 \
						and int(R.member_get(inst, "g_generuj_statek")) != 2:
					node = inst
					target_level = gl2
					break
		if node == null:
			print("MAPWALK FAIL no usable level node")
			quit(1)
			return true
		print("MAPWALK node id=%d pos=%s goto=%d completed=%s" % [
			node.inst_id, str(node.position), target_level,
			str(R.member_get(node, "g_completed"))])
		player.position = node.position
		stage = 2
		wait = 0
		return false
	if stage == 2:
		wait += 1
		R.keyboard_key_press(null, 90)
		if wait == 2:
			print("MAPWALK press jump delayer=%s timer=%s wszedl=%s idzie=%s ster_jump=%s placed=%s" % [
				str(G.delayer), str(R.member_get(player, "g_wlacz_etap_timer")),
				str(G.mario_wszedl_do_etapu), str(R.member_get(player, "g_idzie")),
				str(G.ster_jump), str(R.place_meeting(player, player.position.x, player.position.y, 828))])
			print("MAPWALK state clickersus=%s item_sel=%s mapa_ster=%s zycia=%s podskocz=%s stopper=%s skusil=%s seq=%s" % [
				str(R.get_obj_var(827, "g_klickersus")), str(R.get_obj_var(827, "g_item_selecting")),
				str(G.mapa_sterownosc), str(G.zycia),
				str(R.member_get(player, "g_podskocz_po_gameover")),
				str(G.chwilowy_stopper), str(G.mario_skusil), str(G.map_completed_sequence)])
			print("MAPWALK node fields bonus=%s statek=%s gate=%s dirs=%s/%s/%s/%s" % [
				str(R.member_get(node, "g_bonus_level")), str(R.member_get(node, "g_generuj_statek")),
				str(R.member_get(node, "g_posiada_brame")),
				str(R.member_get(node, "g_lewo")), str(R.member_get(node, "g_prawo")),
				str(R.member_get(node, "g_gora")), str(R.member_get(node, "g_dol"))])
		if R.room != 273:
			print("MAPWALK ENTERED room=%d name=%s target=%d after=%d frames inst=%d" % [
				R.room, R.room_caption, target_level, wait, R.instances.size()])
			R.keyboard_key_release(null, 90)
			stage = 3
			wait = 0
			return false
		if wait > 400:
			print("MAPWALK FAIL no transition game_over=%s wszedl=%s idzie=%s delayer=%s timer=%s room=%d" % [
				str(G.game_over), str(G.mario_wszedl_do_etapu),
				str(R.member_get(player, "g_idzie")), str(G.delayer),
				str(R.member_get(player, "g_wlacz_etap_timer")), R.room])
			quit(1)
			return true
		return false
	if stage == 3:
		wait += 1
		if wait == 1:
			var flags := _find_obj(288)
			print("MAPWALK level room=%d flag_objs=%d inst=%d" % [
				R.room, flags.size(), R.instances.size()])
			if flags.is_empty():
				print("MAPWALK SKIP no flagpole object in target room")
				quit(0)
				return true
			R.member_set(flags[0], "g_local_global", 4)
			R.member_set(flags[0], "g_przejdz_na_mape", 121)
			print("MAPWALK forced flagpole on obj id=%d" % flags[0].inst_id)
		if R.room != target_level:
			print("MAPWALK RETURNED room=%d after=%d frames inst=%d" % [
				R.room, wait, R.instances.size()])
			var sp := R.working_directory.path_join(str(G.savegame_filename))
			print("MAPWALK savegame exists=%s size=%d" % [
				str(FileAccess.file_exists(sp)), FileAccess.get_file_as_bytes(sp).size()])
			stage = 4
			wait = 0
			return false
		if wait > 400:
			var fl := _find_obj(288)
			print("MAPWALK FAIL no return local_global=%s przejdz=%s" % [
				str(R.member_get(fl[0], "g_local_global")) if not fl.is_empty() else "n/a",
				str(R.member_get(fl[0], "g_przejdz_na_mape")) if not fl.is_empty() else "n/a"])
			quit(1)
			return true
		return false
	if stage == 4:
		wait += 1
		if wait >= 60:
			print("MAPWALK DONE returned room=%d mapplayers=%d inst=%d" % [
				R.room, _find_obj(831).size(), R.instances.size()])
			quit(0)
			return true
	return false
