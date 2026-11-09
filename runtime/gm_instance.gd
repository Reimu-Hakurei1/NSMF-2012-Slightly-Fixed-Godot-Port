class_name GMInstance extends GMVars

## One GameMaker instance. Position is Node2D.position (GML x/y); every other GML variable
## lives in the generated GMVars base. The runtime drives step events centrally so event
## order matches GameMaker, and _draw runs the object's Draw event in room coordinates.

var inst_id: int = 0
var obj_script: GDScript = null
var has_draw: bool = false
var has_begin: bool = false
var has_step: bool = false
var has_end: bool = false
var key_events: Array = []
var has_anim_end: bool = false
var frames: Array = []
var spr_origin: Vector2 = Vector2.ZERO
var spr_size: Vector2 = Vector2.ZERO
var mask: Rect2 = Rect2()
var alive: bool = true
var created: bool = false
var last_sprite: int = -999
var last_mask: int = -999
var last_depth: float = 1e30
var add_layer: Node2D = null
var add_cmds: Array = []
var last_img: float = -1e30
var last_xs: float = -1e30
var last_ys: float = -1e30
var last_ang: float = -1e30
var last_alpha: float = -1e30
var last_blend: int = -999999
var last_spr: int = -999999

var x: float:
	get:
		return position.x
	set(v):
		position.x = v

var y: float:
	get:
		return position.y
	set(v):
		position.y = v


func init_instance(meta: Dictionary, id: int) -> void:
	inst_id = id
	g_id = id
	g_object_index = meta["i"]
	g_depth = meta["depth"]
	g_visible = meta["visible"] != 0
	g_persistent = meta["persistent"] != 0
	g_solid = meta["solid"] != 0
	g_mask_index = meta["mask"]
	var _i0 := Time.get_ticks_usec()
	obj_script = R.object_script(meta["i"])
	var _i1 := Time.get_ticks_usec()
	key_events = R.object_key_events(meta["i"])
	has_draw = R.handler(meta["i"], 8000) != null
	has_begin = R.handler(meta["i"], 3001) != null
	has_step = R.handler(meta["i"], 3000) != null
	has_end = R.handler(meta["i"], 3002) != null
	var _i2 := Time.get_ticks_usec()
	has_anim_end = R.handler(meta["i"], 7007) != null
	var _i3 := Time.get_ticks_usec()
	g_xstart = position.x
	g_ystart = position.y
	g_xprevious = position.x
	g_yprevious = position.y
	set_sprite(meta["sprite"])
	if R.debug_load:
		var _i4 := Time.get_ticks_usec()
		for pair in [["i_script", _i0, _i1], ["i_events", _i1, _i2],
				["i_handler", _i2, _i3], ["i_sprite", _i3, _i4]]:
			R.debug_spawn_usec[pair[0]] = int(R.debug_spawn_usec.get(pair[0], 0)) + int(pair[2]) - int(pair[1])


func set_sprite(idx: int) -> void:
	g_sprite_index = idx
	last_sprite = idx
	var info: Dictionary = R.sprite_info(idx)
	frames = info["frames"]
	spr_origin = info["origin"]
	spr_size = info["size"]
	g_image_number = frames.size()
	if g_image_index >= frames.size():
		g_image_index = 0.0
	refresh_mask()


func sync_visuals() -> bool:
	if int(g_sprite_index) != last_sprite:
		set_sprite(int(g_sprite_index))
	if int(g_mask_index) != last_mask:
		refresh_mask()
	if float(g_depth) != last_depth:
		R._assign_depth(self)
	var vis := bool(g_visible)
	var vis_changed := visible != vis
	visible = vis
	if not vis:
		return false
	if has_draw:
		return true
	var ii := float(g_image_index)
	var xs := float(g_image_xscale)
	var ys := float(g_image_yscale)
	var an := float(g_image_angle)
	var al := float(g_image_alpha)
	var bl := int(g_image_blend)
	var sp := int(g_sprite_index)
	# Sprite-drawn instances only need a re-record when one of their visual
	# inputs changes; pure movement is a transform update for the canvas item.
	if not vis_changed and ii == last_img and xs == last_xs and ys == last_ys and an == last_ang \
			and al == last_alpha and bl == last_blend and sp == last_spr:
		return false
	last_img = ii
	last_xs = xs
	last_ys = ys
	last_ang = an
	last_alpha = al
	last_blend = bl
	last_spr = sp
	return true


func refresh_mask() -> void:
	last_mask = int(g_mask_index)
	var idx: int = g_mask_index if g_mask_index >= 0 else g_sprite_index
	mask = R.sprite_info(idx)["bbox"]


func mask_at(px: float, py: float) -> Rect2:
	var xs := float(g_image_xscale)
	var ys := float(g_image_yscale)
	var ang := float(g_image_angle)
	if ang == 0.0:
		var xa := px + mask.position.x * xs
		var xb := px + mask.end.x * xs
		var ya := py + mask.position.y * ys
		var yb := py + mask.end.y * ys
		return Rect2(Vector2(minf(xa, xb), minf(ya, yb)),
			Vector2(absf(xb - xa), absf(yb - ya)))
	# GM8 rotates the four bbox corners (not the sprite rect) to get the world AABB.
	var a := deg_to_rad(ang)
	var ca := cos(a)
	var sa := sin(a)
	var mn := Vector2(1e30, 1e30)
	var mx := Vector2(-1e30, -1e30)
	for lx in [mask.position.x, mask.end.x]:
		for ly in [mask.position.y, mask.end.y]:
			var q := Vector2(lx * xs, ly * ys)
			var w := Vector2(px + q.x * ca + q.y * sa, py - q.x * sa + q.y * ca)
			mn = mn.min(w)
			mx = mx.max(w)
	return Rect2(mn, mx - mn)


func _draw() -> void:
	if not alive:
		return
	R.draw_ci = self
	R.draw_blend = 0
	add_cmds.clear()
	draw_set_transform(-position, 0.0, Vector2.ONE)
	if has_draw:
		R.run_event(self, 8, 0)
	elif g_visible and frames.size() > 0:
		var tex: Texture2D = frames[int(g_image_index) % frames.size()]
		if tex != null:
			var c: Color = R._gm_color(g_image_blend)
			c.a = clampf(float(g_image_alpha), 0.0, 1.0)
			draw_set_transform(Vector2.ZERO, -deg_to_rad(float(g_image_angle)),
				Vector2(float(g_image_xscale), float(g_image_yscale)))
			draw_texture(tex, -spr_origin, c)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	R.draw_blend = 0
	R.draw_ci = null
	if not add_cmds.is_empty():
		if add_layer == null:
			_make_add_layer.call_deferred()
		else:
			add_layer.queue_redraw()
	elif add_layer != null:
		add_layer.queue_redraw()


func _make_add_layer() -> void:
	if add_layer != null or not is_inside_tree():
		return
	add_layer = Node2D.new()
	add_layer.material = R.additive_material()
	add_layer.draw.connect(_replay_additive)
	add_child(add_layer)
	add_layer.queue_redraw()


func _replay_additive() -> void:
	if add_cmds.is_empty():
		return
	R.draw_ci = add_layer
	R.draw_offset_override = -position
	R.draw_blend = 0
	for cmd in add_cmds:
		R.replay_additive(self, cmd)
	R.draw_offset_override = null
	R.draw_ci = null