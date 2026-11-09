extends Node2D
## GameMaker object "obj_song_display" (index 926)
## sprite_index=-1 depth=-2147483647 solid=0 visible=1 parent=-100 mask=-1

func gm_Create_0() -> void:
	# // This is also a Slightly Fixed Edition-specfic object
	# 
	# x = 0
	# y = 100;
	# 
	# display_time = 0
	# 
	# last_song = ""
	# current_song = ""
	# display_text = ""
	# 
	# noteblock_timer = 0
	# 
	# songnames = ds_map_create()
	# 
	# // level songs
	# // song names mostly sourced from downloads.khinsider.com and metadata in the game files
	# ds_map_add(songnames, 0, "Petal Meadows - Paper Mario: The Thousand-Year Door")
	# ds_map_add(songnames, 1, "Underground Theme (Super Mario Bros.) - Super Smash Bros. Brawl")
	# ds_map_add(songnames, 2, "Main Theme (Demo) - Paper Mario: The Thousand-Year Door")
	# ds_map_add(songnames, 3, "Castle Theme - Super Mario World (OC Remix)")
	# ds_map_add(songnames, 4, "Face-Off - Mario Party 7")
	# ds_map_add(songnames, 5, "Haunty Halls Galaxy - Super Mario Galaxy 2")
	# ds_map_add(songnames, 6, "Bowser's Invitation - Mario Party 7")
	# ds_map_add(songnames, 7, "Unknown")
	# ds_map_add(songnames, 8, "Airship Theme (Super Mario Bros. 3) - Super Smash Bros. Brawl")
	# ds_map_add(songnames, 9, "Face-Off - Mario Party 7")
	# ds_map_add(songnames, 10, "Dusty Dune Galaxy - Super Mario Galaxy")
	# ds_map_add(songnames, 11, "Castle Theme - Super Mario World (OC Remix)")
	# ds_map_add(songnames, 12, "Shipmeisters' Humoresque - Kingdom Hearts")
	# ds_map_add(songnames, 13, "Underwater (SMB1) - Mario & Sonic, London 2012 Olympic Games")
	# ds_map_add(songnames, 14, "Volcano Peril - Mario Party 7")
	# ds_map_add(songnames, 15, "Fun in the Sun - Mario Party 7")
	# ds_map_add(songnames, 16, "Happy Seafloor - Mario Party 5")
	# ds_map_add(songnames, 17, "Super Metroid 'Energy Tank' (OC Remix)")
	# ds_map_add(songnames, 18, "The Dragon Chef's Belly - Rayman Origins")
	# ds_map_add(songnames, 19, "Forest Funk - Super Meat Boy")
	# ds_map_add(songnames, 20, "The Battle of Lil' Slugger - Super Meat Boy")
	# ds_map_add(songnames, 21, "Can o' Salt - Super Meat Boy")
	# ds_map_add(songnames, 22, "Battlefield (Melee) - Super Smash Bros. Brawl")
	# ds_map_add(songnames, 30, "Leading Unto Prosperity (The Crimson Dragon) - Legend Of Mana")
	# ds_map_add(songnames, 31, "Main Theme - LittleBigPlanet 2")
	# ds_map_add(songnames, 132, "The Star Festival - Super Mario Galaxy")
	# ds_map_add(songnames, 100, "Innocent Face - Chocobo Stallion")
	# ds_map_add(songnames, 101, "Chocobo's Theme - Chocobo Racing")
	# ds_map_add(songnames, 102, "Gearing Up - Kingdom Hearts 2")
	# ds_map_add(songnames, 32, "Jibberish Jungle: The Darktoon Chase - Rayman Origins")
	# ds_map_add(songnames, 103, "Secret Mission - Devil May Cry 4")
	# ds_map_add(songnames, 104, "Main Theme - Paper Mario: The Thousand-Year Door")
	# 
	# // map songs
	# ds_map_add(songnames, "map1", "Pianta Parlor Minigame - Paper Mario: The Thousand-Year Door")
	# ds_map_add(songnames, "map2", "Slipsand Galaxy - Super Mario Galaxy 2")
	# ds_map_add(songnames, "map3", "In Calm Water - Mario Party 5")
	# ds_map_add(songnames, "map4", "Dusty Dune Galaxy - Super Mario Galaxy")
	# ds_map_add(songnames, "map5", "Ark's Birth - Klonoa 2: Lunatea's Veil")
	# ds_map_add(songnames, "map6", "Freezy Flake Galaxy - Super Mario Galaxy 2")
	# ds_map_add(songnames, "map7", "Enchanted Realm - Nox Arcana")
	# ds_map_add(songnames, "map8", "The Gloaming - Legend of Mana")
	# ds_map_add(songnames, "map100", "Victory! (Super Mario Bros.) - Super Smash Bros. Brawl")
	pass

func gm_Destroy_0() -> void:
	# ds_map_destroy(songnames)
	pass

func gm_Outside_0() -> void:
	# var actual_start_padding, start_padding, end_padding, text_length,
	#     height, actual_width,
	#     actual_x, actual_y,
	#     offx, offy, zoom, scale,
	#     noteblock_scale, noteblock_x, noteblock_y;
	# 
	# if (display_text == "" || x <= 0) exit;
	# 
	# zoom = global.ekran_size_act;
	# scale = zoom * 0.66;
	# offx = view_xview[0];
	# offy = view_yview[0];
	# 
	# actual_start_padding = 0 * scale;
	# start_padding = 70 * scale + actual_start_padding;
	# end_padding = 8 * scale;
	# 
	# draw_set_font(global.map_fonts_1)
	# draw_set_color(c_white)
	# draw_set_alpha(1)
	# draw_set_halign(fa_right)
	# draw_set_valign(fa_top)
	# height = string_height("A -") * scale;
	# text_length = string_width(display_text) * scale;
	# 
	# y = 200
	# 
	# actual_width = (start_padding + end_padding + text_length);
	# actual_x = x * actual_width;
	# actual_y = y * zoom * 0.75;
	# 
	# draw_set_alpha(0.5)
	# draw_set_color(c_black)
	# draw_rectangle(offx, offy+actual_y, offx+actual_x, offy+actual_y + height, false);
	# draw_set_alpha(1)
	# 
	# draw_set_color(c_white)
	# draw_text_transformed(
	#     offx+actual_x - end_padding, offy+actual_y,
	#     display_text,
	#     scale, scale, 0
	# );
	# 
	# // note block
	# 
	# noteblock_scale = scale * 1.1;
	# 
	# noteblock_y = offy+actual_y - 2 * noteblock_scale;
	# noteblock_x = offx+actual_x - actual_width + 13 * noteblock_scale + actual_start_padding;
	# 
	# if sprite_exists(global.gfx_point_music_box)
	#     draw_sprite_ext(
	#         global.gfx_point_music_box, 0,
	#         noteblock_x + 20*noteblock_scale - sin(noteblock_timer/5)*4*noteblock_scale,
	#         noteblock_y + 20*noteblock_scale + sin(noteblock_timer/7)*4*noteblock_scale,
	#         noteblock_scale - sin(noteblock_timer/20)/10*noteblock_scale,
	#         noteblock_scale + sin(noteblock_timer/10)/10*noteblock_scale,
	#         sin(noteblock_timer/10)*5,
	#         c_white, 1
	#     );
	# 
	# if sprite_exists(global.gfx_point_music_box_nuta) {
	#     draw_sprite_ext(
	#         global.gfx_point_music_box_nuta, 0,
	#         noteblock_x + 20*noteblock_scale + sin(noteblock_timer/10)*3*noteblock_scale,
	#         noteblock_y + 20*noteblock_scale + sin(noteblock_timer/4)*6*noteblock_scale,
	#         noteblock_scale, noteblock_scale,
	#         sin(noteblock_timer/14)*20,
	#         c_white, 1
	#     )
	#     draw_set_blend_mode(bm_add)
	#     draw_sprite_ext(
	#         global.gfx_point_music_box_nuta, 0,
	#         noteblock_x + 20*noteblock_scale + sin(noteblock_timer/10)*3*noteblock_scale,
	#         noteblock_y + 10*noteblock_scale + sin(noteblock_timer/4)*6*noteblock_scale,
	#         noteblock_scale, noteblock_scale,
	#         sin(noteblock_timer/14)*20,
	#         c_white, 1
	#     )
	#     draw_set_blend_mode(bm_normal)
	# }
	# noteblock_timer += 0.5
	# 
	# draw_set_halign(fa_left);
	# draw_set_valign(fa_top);
	pass

func gm_Step_Step() -> void:
	# /*
	# // a makeshift gmlive
	# if keyboard_check_pressed(vk_f3) {
	#     current_song = string(10000000 + irandom(1000));
	#     
	#     object_event_clear(obj_song_display, ev_draw, 0);
	#     object_event_add(obj_song_display, ev_draw, 0, read_text_file("./code.gml"));
	# }
	# */
	# 
	# // used as "no song" in some places, like the title screen
	# if (string(current_song) == "1040000") current_song = "";
	# if (string(current_song) == "104000") current_song = "";
	# if (string(current_song) == "10400") current_song = "";
	# 
	# if (keyboard_check_pressed(vk_f5)) {
	#     global.songdisplay = !global.songdisplay;
	# }
	# if (!global.songdisplay) {
	#     visible = false;
	#     x = 0;
	#     last_song = "";
	#     display_time = 60 * 3.5;
	#     exit;
	# }
	# 
	# if (string(last_song) != string(current_song)) {
	#     last_song = current_song;
	#     if (string(current_song) != "") {
	#         display_time = 60 * 3.5;
	#         x = 0;
	#         if ds_map_exists(songnames, current_song)
	#             display_text = ds_map_find_value(songnames, current_song);
	#         else
	#             display_text = "Unknown song (" + string(current_song) + ")";
	#     }
	# }
	# 
	# if (display_time > 0) {
	#     x += (1 - x) / 9;
	#     display_time -= 1;
	# } else if (x > 0) {
	#     x -= (1.01 - x) / 6;
	#     if (x < 0) x = 0;
	# }
	# 
	# visible = !(display_text == "" || x <= 0);
	pass
