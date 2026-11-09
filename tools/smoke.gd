extends SceneTree

## Headless smoke test: boots the real Game scene, ticks it, and reports room state.

var frames: int = 0
var last_room: int = -999


func _initialize() -> void:
	var game: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(game)
	print("SMOKE start game_running=", R.game_running)


func _process(_delta: float) -> bool:
	frames += 1
	if R.room != last_room:
		last_room = R.room
		print("SMOKE room=%d name=%s inst=%d tiles=%d size=%dx%d view=(%d,%d)" % [
			R.room, R.room_caption, R.instances.size(), R.tiles.size(),
			int(R.room_width), int(R.room_height),
			int(R.aget(R.view_xview, 0)), int(R.aget(R.view_yview, 0))])
	if frames % 120 == 0:
		print("SMOKE tick=%d frames=%d inst=%d particles=%d pending=%s seq=%s/%s start=%s" % [
			R.tick_count, frames, R.instances.size(), R.particles.size(), str(R.pending_room),
			str(R.get_obj_var(301, "g_wolna_sekwencja_wgrywania")),
			str(G.codingfx_number), str(R.get_obj_var(301, "g_start"))])
	if frames == 1:
		print("SMOKE boot room chain beginning")
	if frames >= 600:
		print("SMOKE done ticks=%d room=%d inst=%d pending=%s" % [
			R.tick_count, R.room, R.instances.size(), str(R.pending_room)])
		quit(0)
		return true
	return false
