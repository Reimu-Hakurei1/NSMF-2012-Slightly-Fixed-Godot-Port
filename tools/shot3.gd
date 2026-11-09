extends SceneTree

var in_room: int = 0
var cleared: bool = false
var saved: bool = false


func _initialize() -> void:
	root.add_child(load("res://scenes/game.tscn").instantiate())


func _process(_d: float) -> bool:
	if R.room == 324:
		in_room += 1
	if in_room == 40 and not cleared:
		cleared = true
		for inst in R.instances.duplicate():
			if inst.alive and int(inst.g_object_index) != 916:
				R.instance_destroy(inst, inst.inst_id)
	if in_room == 120 and not saved:
		saved = true
		var img: Image = root.get_texture().get_image()
		img.save_png("res://shot_lang_clean.png")
		print("CLEAN room=%d view=%.1f,%.1f cam=%.1f,%.1f zoom=%.3f inst=%d" % [
			R.room, R.view_xview[0], R.view_yview[0],
			R.camera.position.x, R.camera.position.y, R.camera.zoom.x, R.instances.size()])
		quit()
		return true
	if in_room > 400:
		print("CLEAN timeout")
		quit()
		return true
	return false
