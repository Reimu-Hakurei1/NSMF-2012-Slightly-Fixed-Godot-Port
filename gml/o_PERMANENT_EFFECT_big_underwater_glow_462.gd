extends Node2D
## GameMaker object "o_PERMANENT_EFFECT_big_underwater_glow" (index 462)
## sprite_index=2 depth=-121575219 solid=0 visible=1 parent=-100 mask=-1

func gm_Create_0() -> void:
	# glower=0
	# wet=0
	# splasher=0
	pass

func gm_Outside_0() -> void:
	# 
	# draw_set_blend_mode(bm_add)
	# draw_sprite_ext(global.underwater_utter_glow,0,view_xview[0],view_yview[0],1*global.ekran_size_act,1*global.ekran_size_act,0,c_white,glower/2)
	# draw_set_blend_mode(bm_normal)
	# 
	# if obj_mario.y<o_water_define.y && glower>0 {glower=glower/1.03}
	# if obj_mario.y>o_water_define.y+100 && obj_mario.y<o_water_define.y+300 && glower<0.5 {glower+=0.01}
	# if obj_mario.y>o_water_define.y+300 && glower<0.65 {glower+=0.01}
	# 
	# 
	# if obj_mario.watered<>1 && wet=0 {wet=1}
	# if obj_mario.watered=1 && wet=1
	#     {
	#     wet=2
	#     repeat(10){instance_create(-1000,-1000,o_kropla_wody_na_ekranie)}
	# }
	# if wet=2 && splasher<1 {splasher+=0.1}
	# if wet=2 && splasher>=1 {wet=3}
	# if wet=3 {splasher=splasher/1.005}
	# if wet=3 && splasher<=0.01 {splasher=0;wet=0}
	# 
	# draw_set_blend_mode(bm_add)
	# draw_sprite_ext(global.water_wet_ekranos,0,view_xview[0],view_yview[0],1*global.ekran_size_act,1*global.ekran_size_act,0,c_white,splasher)
	# draw_set_blend_mode(bm_normal)
	pass
