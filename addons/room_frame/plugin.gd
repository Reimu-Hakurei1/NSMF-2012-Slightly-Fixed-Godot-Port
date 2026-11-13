@tool
extends EditorPlugin

## Room layouts live far from the origin (GM rooms start their content hundreds of
## pixels down), so a freshly opened scene would show empty sky. Frame the editor
## viewport on the scene's Camera2D, which sits at the game's entry view centre.

var _last: Node = null
var _acc: float = 0.0
var _shot: String = ""
var _shot_left: float = 0.0
var _frame_left: float = 0.0
var _cam_pos: Vector2 = Vector2.ZERO


func _enter_tree() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--editor-shot="):
			_shot = a.substr(14)
	set_process(true)


func _process(delta: float) -> void:
	if _shot_left > 0.0:
		_shot_left -= delta
		if _shot_left <= 0.0:
			var vp: SubViewport = EditorInterface.get_editor_viewport_2d()
			vp.get_texture().get_image().save_png(_shot)
			print("ROOM_FRAME shot saved ", _shot)
			get_tree().quit()
		return
	_acc += delta
	if _acc < 0.25:
		return
	_acc = 0.0
	var sc: Node = EditorInterface.get_edited_scene_root()
	if sc == null or not sc.has_meta("gm_room"):
		return
	if sc != _last:
		_last = sc
		var cam: Node2D = sc.get_node_or_null("Camera2D")
		if cam == null:
			return
		_cam_pos = cam.position
		# The editor resets the canvas transform while a scene finishes loading,
		# so keep re-applying the framing for a moment after each scene change.
		_frame_left = 2.0
		print("ROOM_FRAME centered %s at %s" % [sc.name, str(_cam_pos)])
		if _shot != "":
			_shot_left = 2.5
	if _frame_left > 0.0:
		_frame_left -= 0.25
		var vp: SubViewport = EditorInterface.get_editor_viewport_2d()
		vp.canvas_transform = Transform2D(0.0, vp.size / 2.0 - _cam_pos)