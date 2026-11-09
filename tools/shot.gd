extends SceneTree

var frames: int = 0
var target_room: int = -1


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		print("ARG ", a)
		target_room = int(a)
	root.add_child(load("res://scenes/game.tscn").instantiate())


func _process(_d: float) -> bool:
	frames += 1
	if frames == 60 and target_room >= 0 and R.room != target_room:
		R.room_goto(null, target_room)
	if frames == 240:
		var img: Image = root.get_texture().get_image()
		img.save_png("res://shot_view.png")
		print("SHOT room=%d view=%.1f,%.1f w=%.1f h=%.1f cam=%.1f,%.1f zoom=%.3f,%.3f vp=%s flags=%s,%s" % [
			R.room, R.view_xview[0], R.view_yview[0], R.view_wview[0], R.view_hview[0],
			R.camera.position.x, R.camera.position.y, R.camera.zoom.x, R.camera.zoom.y,
			str(root.size), str(G.flaga_english), str(G.flaga_polish)])
		for inst in R.instances:
			if inst.alive and int(inst.g_object_index) == 916:
				print("CHOOSER pos=%.1f,%.1f wielkosc=%s offset=%s" % [
					inst.position.x, inst.position.y,
					str(R.member_get(inst, "g_wielkosc")), str(R.member_get(inst, "g_pos_offset"))])
		quit()
		return true
	return false
