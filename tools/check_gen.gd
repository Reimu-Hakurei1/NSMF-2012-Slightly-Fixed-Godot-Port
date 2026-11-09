extends SceneTree

## Loads every generated script once so parse errors surface in a single run.


func collect(dir: String, out: Array) -> void:
	var d := DirAccess.open(dir)
	if d == null:
		return
	d.list_dir_begin()
	var f := d.get_next()
	while f != "":
		if f.begins_with("."):
			f = d.get_next()
			continue
		var p := dir.path_join(f)
		if d.current_is_dir():
			collect(p, out)
		elif f.ends_with(".gd"):
			out.append(p)
		f = d.get_next()
	d.list_dir_end()


func _init() -> void:
	var files: Array = []
	collect("res://gen", files)
	collect("res://runtime", files)
	files.sort()
	var args := OS.get_cmdline_user_args()
	var start: int = int(args[0]) if args.size() > 0 else 0
	var limit: int = int(args[1]) if args.size() > 1 else files.size()
	var stop: int = mini(files.size(), start + limit)
	var bad: Array = []
	for i in range(start, stop):
		var p: String = files[i]
		if i % 25 == 0:
			print("... %d/%d %s" % [i, files.size(), p])
		var s: Resource = load(p)
		var ok := s != null
		if ok and s is GDScript:
			ok = s.can_run() if s.has_method("can_run") else s.reload() == OK
		if not ok:
			bad.append(p)
	print("CHECKED %d..%d of %d  FAILED %d" % [start, stop, files.size(), bad.size()])
	for p in bad:
		print("FAIL ", p)
	quit(1 if bad.size() > 0 else 0)