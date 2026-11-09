extends RefCounted
## GameMaker script "script_update_window" kept verbatim as comments.
## GML calls this by name with positional arguments.

func run(_a = null, _b = null, _c = null, _d = null) -> void:
	# if (global.widescreen == 1) {
	#     obj_global_manager.sw = 1066;
	#     obj_global_manager.sh = 600;
	# } else if (global.widescreen == 2) {
	#     obj_global_manager.sw = window_get_width() * (600 / window_get_height());
	#     obj_global_manager.sh = 600;
	# } else {
	#     obj_global_manager.sw = 800;
	#     obj_global_manager.sh = 600;
	# }
	# script_update_view();
	# // if we don't resize and reposition the window on every single room start,
	# // gm8 seems to just resize it by itself (and that's bad)
	# if true || (global.old_windowed != global.windowed) || (global.old_widescreen != global.widescreen) {
	#     if global.windowed=0 {
	#         window_set_fullscreen(0);
	#         window_set_size(obj_global_manager.sw,obj_global_manager.sh)
	#         window_set_position(display_get_width()/2-window_get_width()/2,display_get_height()/2-window_get_height()/2);
	#     } else if global.windowed=1 {
	#         window_set_fullscreen(1);
	#         window_set_position(0,0);window_set_size(display_get_width(),display_get_height());
	#     } else if global.windowed=2 {
	#         window_set_fullscreen(0);
	#         window_set_size(ceil(obj_global_manager.sw * 1.5), ceil(obj_global_manager.sh * 1.5))
	#         window_set_position(display_get_width()/2-window_get_width()/2,display_get_height()/2-window_get_height()/2);
	#     }
	# }
	# global.old_windowed = global.windowed
	# global.old_widescreen = global.widescreen
	# window_set_region_size(obj_global_manager.sw, obj_global_manager.sh, false)
	pass
