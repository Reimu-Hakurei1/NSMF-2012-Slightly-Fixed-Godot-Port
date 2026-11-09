extends Node2D
## GameMaker object "obj_global_manager" (index 925)
## sprite_index=-1 depth=-2147483648 solid=0 visible=1 parent=-100 mask=-1

func gm_Create_0() -> void:
	# // This is a Slightly Fixed Edition-specfic object
	# // I guess this is also my place to say that Softendo's code is absolute spaghetti.
	# // Seriously it's nearly unreadable.
	# // I was originally planning on porting this to GMS but it was near impossible
	# // due to the huge amount of unused variables and sloppy coding
	# 
	# sw = 800
	# sh = 600
	# sfe_version = "v1.2"
	# 
	# global.widescreen = false
	# global_old_widescreen = -1
	# global.old_windowed = -1
	# global.config_filename = "./config.dat";
	# global.savegame_filename = "./savegame.dat";
	# global.map_savegame_filename = "./map_savegame.dat";
	# global.maplevel_savegame_filename = "./maplevel_savegame.dat";
	# 
	# //global.mfce_img1 = sprite_add("./data/slightlyfixed/mfce.png",0,0,0,430/2,330/2)
	# //global.mfce_img2 = sprite_add("./data/slightlyfixed/mfce2.png",0,0,0,430/2,330/2)
	# 
	# last_code = ""
	# last_command = ""
	# 
	# global.debug = debug_mode;
	# global.show_fps = false;
	# 
	# instance_create(0, 0, obj_song_display);
	# 
	# last_room = room_DOME_ONLY_TANOOKI;
	# i = 0;
	# while (i <= last_room) {
	#     room_set_view(
	#         i, 0, true,
	#         0, 0, 800, 600,
	#         0, 0, 800, 600,
	#         0, 0, 0, 0,
	#         noone
	#     )
	#     i += 1;
	# }
	# 
	# window_set_fixed(true)
	# 
	# script_keys_init_real();
	# script_update_window();
	pass

func gm_Draw_30() -> void:
	# /* DnD lib=1 id=332 kind=0 fn='action_end_game' args=() */
	pass

func gm_Draw_4() -> void:
	# script_update_window()
	# room_caption = "New Super Mario Forever 2012: Slightly-Fixed Edition";
	pass

func gm_Intersect_112() -> void:
	# if (!debug_mode) exit;
	# var gml_text;
	# if keyboard_check(vk_shift) {
	#     if !file_exists("./code.gml") {
	#         show_message("code.gml file does not exist in game folder!");
	#         exit;
	#     }
	#     
	#     gml_text = read_text_file("./code.gml");
	# } else {
	#     if keyboard_check(vk_control) {
	#         gml_text = last_code;
	#     } else {
	#         gml_text = get_string("Enter code: (Ctrl to quick-run last, Shift to run code.gml)", "");
	#         if (gml_text != "") last_code = gml_text;
	#     }
	# }
	# 
	# if (gml_text == "") exit;
	# execute_string(gml_text);
	pass

func gm_Intersect_113() -> void:
	# if (!debug_mode) exit;
	# var cmd, last_last_command;
	# 
	# last_last_command = last_command;
	# if keyboard_check(vk_control) {
	#     cmd = last_command;
	# } else {
	#     cmd = get_string("Run command: ('help' for help, Ctrl to quick-run last)", "");
	# }
	# if (cmd == "") exit;
	# last_command = cmd;
	# 
	# if cmd == "help"
	#     show_message("Commands:
	# help - show this help text
	# fps - toggle FPS display
	# text - render text in the game's UI font to a file");
	# else if cmd == "fps"
	#     global.show_fps = !global.show_fps;
	# else if cmd == "text" {
	#     render_string = get_string("Text to render:", "");
	#     
	#     draw_set_font(global.map_fonts_1);
	#     draw_set_color(c_white);
	#     draw_set_alpha(1);
	#     draw_set_halign(fa_left);
	#     draw_set_valign(fa_top);
	#     draw_clear_alpha(c_black, 0);
	#     
	#     render_surface = surface_create(string_width(render_string) + 4, string_height(render_string) + 4);
	#     surface_set_target(render_surface);
	#     draw_text(0, 0, render_string);
	#     surface_save(render_surface, "text.png");
	#     surface_reset_target();
	#     surface_free(render_surface);
	#     
	#     show_message("Saved to text.png.");
	# } else {
	#     show_message("The command '" + cmd + "' does not exist!");
	#     last_command = last_last_command;
	# }
	pass

func gm_Intersect_115() -> void:
	# if !keyboard_check(vk_alt) {
	#     if (global.windowed == 1) global.windowed = 0;
	#     else global.windowed = 1;
	#     script_update_window();
	#     script_keys_write();
	# } else {
	#     game_end();
	# }
	pass

func gm_Intersect_118() -> void:
	# global.widescreen = !global.widescreen;
	# script_keys_write();
	# script_update_window();
	pass

func gm_Intersect_68() -> void:
	# if !(room == room_initialize_and_loading || room == room_wybierz_jezyk) exit;
	# if keyboard_check(vk_control) {
	#     global.debug = !global.debug;
	# }
	pass

func gm_Intersect_81() -> void:
	#  if room_speed == 60
	#   {
	#   room_speed = 120
	#   SXMS_SFX_PlayExt(504,127,global.glosnosc_dzwieku,-1,0,0);
	#   }
	#   else
	#   {
	#   room_speed = 60
	#   SXMS_SFX_PlayExt(505,127,global.glosnosc_dzwieku,-1,0,0);
	#   }
	pass

func gm_Outside_0() -> void:
	# var scale, offx, offy;
	# if !global.debug exit;
	# 
	# scale = global.ekran_size_act;
	# if (scale == 0) scale = 1; // failsafe
	# if !font_exists(global.map_fonts_1) exit;
	# 
	# draw_set_font(global.map_fonts_1)
	# draw_set_color(c_white)
	# draw_set_alpha(1)
	# draw_set_halign(fa_left)
	# draw_set_valign(fa_top)
	# 
	# offx = view_xview[0];
	# offy = view_yview[0];
	# 
	# 
	# if global.show_fps
	#     draw_text_transformed(offx + 3*scale, offy + 3*scale, "fps: " + string(fps), 0.4 * scale, 0.4 * scale, 0);
	pass
