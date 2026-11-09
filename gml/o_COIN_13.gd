extends Node2D
## GameMaker object "o_COIN" (index 13)
## sprite_index=27 depth=0 solid=0 visible=1 parent=-100 mask=27

func gm_Create_0() -> void:
	# stream=0
	# killuj=0
	pass

func gm_Outside_0() -> void:
	# if point_distance(x,y,global.ekran_srodek_x,global.ekran_srodek_y)<=global.odleglosc_ekranu*1.1
	#     {
	#     if random(100)>98 {part_particles_create(global.particle_sys_1,x+random(40),y+random(40),global.part_fast_coin_sparcle,1)}
	#     draw_sprite_ext(s_mario_coin,0,x+20,y+20,1+sin(stream)/50,1-sin(stream)/50,sin(stream)*5,c_white,1)
	#     stream+=0.1
	#     draw_set_blend_mode(bm_add)
	#     draw_sprite_ext(s_mario_coin,0,x+20,y+20,1+sin(stream)/50,1-sin(stream)/50,sin(stream)*5,c_white,sin(stream))
	#     draw_set_blend_mode(bm_normal)
	#     
	#     }
	# if killuj=1 {instance_destroy()}
	pass
