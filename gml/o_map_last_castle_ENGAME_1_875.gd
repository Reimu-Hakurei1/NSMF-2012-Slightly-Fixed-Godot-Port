extends Node2D
## GameMaker object "o_map_last_castle_ENGAME_1" (index 875)
## sprite_index=464 depth=0 solid=0 visible=1 parent=-100 mask=-1

func gm_Create_0() -> void:
	# sekwencja=0
	# timer=0
	# 
	# 
	# stream=0
	# wybuch=60
	# wybuch_time=0
	# 
	# mega_wybuch=0
	# mega_wybuch_alpha=1
	# 
	# blanker=0
	# blanker_time=0
	pass

func gm_Outside_0() -> void:
	# 
	# 
	# 
	# if sekwencja=0
	#     {
	#     view_xview[0]=x-(obj_global_manager.sw/2)-sin(degtorad(stream))*40
	#     view_yview[0]=y-(obj_global_manager.sh/2)-sin(degtorad(stream))*30
	#     view_wview[0]=(obj_global_manager.sw)+sin(degtorad(stream))*40
	#     view_hview[0]=(obj_global_manager.sh)+sin(degtorad(stream))*30
	#     background_alpha[0]=0.5
	#     background_alpha[1]=0.5
	#     
	#     background_x[0]+=0.25
	#     background_x[1]+=0.5
	#     
	#     background_y[0]+=0.25/2
	#     background_y[1]+=0.5/2
	#     
	#     if stream<120 {stream+=0.5}
	#     
	#     draw_sprite_ext(s_map_shadow_1,0,x,y,3+sin(koko)/50,1-sin(koko)/50,0,c_white,1)
	# draw_sprite_ext(s_map_shadow_1,0,x,y,3+sin(koko)/50,1-sin(koko)/50,0,c_white,1)
	# draw_sprite_ext(s_map_last_castle_1,0,x,y,1+sin(koko)/50,1-sin(koko)/50,sin(koko/10)*5,c_white,1)
	# koko+=0.1
	# 
	# wybuch_time+=1
	# if wybuch_time>wybuch
	#     {
	#     wybuch_time=0
	#     wybuch-=4
	#     if wybuch<=5 {wybuch=5}
	#     instance_create(x+random(300)-random(300),y-random(300),o_fajny_duzy_wybuch_1_light)
	#     SXMS_SFX_PlayExt(75,((x-view_xview[0])/(obj_global_manager.sw))*255,global.glosnosc_dzwieku/2,-1,0,0)
	#     
	#     
	#     }
	#     
	#     
	#     
	#     if wybuch<=15 {
	#     draw_sprite_ext(global.big_glow_sloneczny,0,x,y,mega_wybuch,mega_wybuch,koko*10,c_white,1)
	#     draw_sprite_ext(global.big_glow_sloneczny,0,x,y,mega_wybuch*2,mega_wybuch*2,koko*20,c_white,1)
	#     if mega_wybuch<4 {mega_wybuch+=0.025}
	#     
	#     }
	#     
	#     if mega_wybuch>=4 {sekwencja=1;timer=0;SXMS_SFX_PlayExt(404,((x-view_xview[0])/obj_global_manager.sw)*255,global.glosnosc_dzwieku,-1,0,0)}
	#     }
	# if sekwencja=1
	#     {
	#     draw_set_color(c_white)
	#     draw_set_alpha(mega_wybuch_alpha)
	#     draw_rectangle(view_xview[0],view_yview[0],view_xview[0]+view_wview[0],view_yview[0]+view_hview[0],0)
	#     draw_set_alpha(1)
	#     mega_wybuch_alpha=mega_wybuch_alpha/1.01
	#     
	#     
	#     if mega_wybuch_alpha>=0.05 {blanker_time+=1}
	#     if blanker_time>=60 {blanker+=0.01}
	#     draw_set_color(c_black)
	#     draw_set_alpha(blanker)
	#     draw_rectangle(view_xview[0],view_yview[0],view_xview[0]+view_wview[0],view_yview[0]+view_hview[0],0)
	#     draw_set_alpha(1)
	#     if blanker>=1 {room_goto(room_END_GAME_ANIM_2)}
	#     
	#     }
	pass
