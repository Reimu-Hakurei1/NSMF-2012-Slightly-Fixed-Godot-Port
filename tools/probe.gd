extends SceneTree

func _initialize() -> void:
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)
	R.boot(game)
	var n := 0
	while R.room != 324 and n < 3000:
		R.step()
		n += 1
	print("probe room=", R.room, " steps=", n)
	var arm = G.gfx_mario_arm
	print("arm type=", typeof(arm), " size=", (arm.size() if arm is Array else -1))
	if arm is Array:
		for i in mini(arm.size(), 12):
			print(" arm[", i, "]=", arm[i], " type=", typeof(arm[i]))
	var mario = R._as_inst(306)
	if mario != null:
		print("mario anim=", mario.g_anim, " type=", typeof(mario.g_anim),
			" sprite=", mario.g_sprite_index)
	print("view_wport=", R.view_wport, " view_wview=", R.view_wview)
	quit(0)
