extends SceneTree

var frames: int = 0
var jumped: bool = false
var saved: bool = false


func _initialize() -> void:
	root.add_child(load("res://scenes/game.tscn").instantiate())


func _process(_d: float) -> bool:
	frames += 1
	if R.room == 324 and not jumped:
		jumped = true
		R.room_goto(null, 264)
	elif R.room == 264 and frames > 0:
		if not saved and _level_frames >= 400:
			saved = true
			var img: Image = root.get_texture().get_image()
			img.save_png("res://shot_level.png")
			for inst in R.instances:
				if int(inst.g_object_index) == 306:
					print("LEVEL mario pos=%.1f,%.1f" % [inst.position.x, inst.position.y])
					break
			print("LEVEL room=%d view=%.1f,%.1f w=%.0fx%.0f cam=%.1f,%.1f zoom=%.2f inst=%d" % [
				R.room, R.view_xview[0], R.view_yview[0], R.view_wview[0], R.view_hview[0],
				R.camera.position.x, R.camera.position.y, R.camera.zoom.x, R.instances.size()])
			quit()
			return true
		_level_frames += 1
	if frames > 4000:
		print("LEVEL timeout room=%d" % R.room)
		quit()
		return true
	return false


var _level_frames: int = 0
