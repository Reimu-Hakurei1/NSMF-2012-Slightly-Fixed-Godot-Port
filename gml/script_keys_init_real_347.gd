extends RefCounted
## GameMaker script "script_keys_init_real" kept verbatim as comments.
## GML calls this by name with positional arguments.

func run(_a = null, _b = null, _c = null, _d = null) -> void:
	# // every room calls script_keys_init, and i don't want hard disk access on every room
	# // so i removed the code from there and put it here instead
	# zapis888=hex_open(global.config_filename)
	# global.windowed=hex_read(zapis888,0, 0);
	# global.aktual_music_volume=hex_read(zapis888,1, 255);
	# global.glosnosc_dzwieku=hex_read(zapis888,2, 255);
	# 
	# global.ster_up=hex_read(zapis888,3, vk_up);
	# global.ster_down=hex_read(zapis888,4, vk_down);
	# global.ster_left=hex_read(zapis888,5, vk_left);
	# global.ster_right=hex_read(zapis888,6, vk_right);
	# global.ster_jump=hex_read(zapis888,7, ord("Z"));
	# global.ster_fire=hex_read(zapis888,8, ord("X"));
	# global.widescreen=hex_read(zapis888,9, false);
	# 
	# global.songdisplay=hex_read(zapis888,10, true);
	# hex_close(zapis888)
	pass
