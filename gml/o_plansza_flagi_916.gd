extends Node2D
## GameMaker object "o_plansza_flagi" (index 916)
## sprite_index=-1 depth=-999999999 solid=0 visible=1 parent=-100 mask=-1

func gm_Create_0() -> void:
	# sounder=0
	# 
	# stream=0
	# wybor=0
	# wielkosc=0
	# dzielnik=1000
	# 
	# 
	# alphar1=0
	# alphar2=0
	# timer=0
	# 
	# 
	# wybral=0
	# 
	# powiekszator1=0
	# powiekszator2=0
	# 
	# wybor2=0
	# 
	# timer=0
	# wybrano=0
	# 
	# wielkor=0
	# 
	# script_update_view()
	pass

func gm_Outside_0() -> void:
	# pos_offset = -400 + view_wview[0] / 2
	# 
	# obj_mario_anim.animacja=6
	# 
	# 
	# if wybrano>=1
	#     {
	#     wybrano+=1
	#     if wybrano>100 {room_goto_next()}
	#     if wybrano=2 {instance_create(x,y,o_BLANKER_MARIO_HEAD_OUT)}
	#     
	#     }
	# if wybrano=0 {
	# timer+=1
	# if timer>40
	#     {
	#     if wybor=1 && (keyboard_check(vk_enter) || mouse_check_button(mb_left)){global.english_or_polish=0;wybrano=1;SXMS_SFX_PlayExt(25,((x-view_xview[0])/view_wview[0])*255,global.glosnosc_dzwieku,-1,0,0)}
	#     if wybor=2 && (keyboard_check(vk_enter) || mouse_check_button(mb_left)) {global.english_or_polish=1;wybrano=1;SXMS_SFX_PlayExt(25,((x-view_xview[0])/view_wview[0])*255,global.glosnosc_dzwieku,-1,0,0)}
	#     
	#     
	#     }
	# 
	# 
	# 
	# // WYBOR
	# wybor=0
	# // fix weirdness related to scrolling and the view size/port size being different
	# real_mouse_x = (mouse_x - view_xview[0]) / (view_wview[0] / view_wport[0]);
	# if abs(real_mouse_x - (view_wview[0]/2 - 100)) <= 100 && mouse_y>y-100 && mouse_y<y+100 {wybor=1}
	# if abs(real_mouse_x - (view_wview[0]/2 + 100)) <= 100 && mouse_y>y-100 && mouse_y<y+100 {wybor=2}
	# 
	# if wybor=0 {wybor2=0}
	# if wybor2<>wybor {wybor2=wybor;
	# 
	# if (window_has_focus()) {
	#     if wybor=1 {SXMS_SFX_PlayExt(108,((x-view_xview[0])/view_wview[0])*255,global.glosnosc_dzwieku,-1,0,0)}
	#     if wybor=2 {SXMS_SFX_PlayExt(20,((x-view_xview[0])/view_wview[0])*255,global.glosnosc_dzwieku,-1,0,0)}
	# }
	# 
	# }
	# 
	# 
	# if wybor=1 {if powiekszator1<0.5 {powiekszator1+=0.05}}
	# if wybor<>1 {if powiekszator1>0 {powiekszator1-=0.05}}
	# 
	# if wybor=2 {if powiekszator2<0.5 {powiekszator2+=0.05}}
	# if wybor<>2 {if powiekszator2>0 {powiekszator2-=0.05}}}
	# 
	# 
	# // GFX
	# 
	# draw_sprite_ext(global.big_glow_sloneczny,0,x+pos_offset-100+view_xview[0],y,2,2,image_angle,c_white,0.5)
	# draw_sprite_ext(global.big_glow_sloneczny,0,x+pos_offset+100+view_xview[0],y,2,2,image_angle+20,c_white,0.5)
	# draw_sprite_ext(global.big_glow_sloneczny,0,x+pos_offset-100+view_xview[0],y,1,1,image_angle*1.4,c_white,0.75)
	# draw_sprite_ext(global.big_glow_sloneczny,0,x+pos_offset+100+view_xview[0],y,1,1,image_angle*1.4+20,c_white,0.75)
	# image_angle+=0.5
	# 
	# 
	# 
	# 
	# draw_set_blend_mode(bm_add)
	# draw_sprite_ext(global.flaga_english,0,x+pos_offset-100+view_xview[0],y,wielkosc*1.3+sin(degtorad(stream))/(dzielnik+15),wielkosc*1.3-sin(degtorad(stream))/(dzielnik+15),0,c_white,0.1)
	# draw_sprite_ext(global.flaga_polish,0,x+pos_offset+100+view_xview[0],y,wielkosc*1.3-sin(degtorad(stream))/(dzielnik+15),wielkosc*1.3+sin(degtorad(stream))/(dzielnik+15),0,c_white,0.1)
	# draw_set_blend_mode(bm_normal)
	# 
	# 
	# draw_sprite_ext(global.flaga_english,0,x+pos_offset-100+view_xview[0],y,powiekszator1+wielkosc+sin(degtorad(stream))/(dzielnik+15),powiekszator1+wielkosc-sin(degtorad(stream))/(dzielnik+15),0,c_white,1)
	# draw_sprite_ext(global.flaga_polish,0,x+pos_offset+100+view_xview[0],y,powiekszator2+wielkosc-sin(degtorad(stream))/(dzielnik+15),powiekszator2+wielkosc+sin(degtorad(stream))/(dzielnik+15),0,c_white,1)
	# 
	# stream+=5
	# if wielkosc<1 {wielkosc+=0.01}
	# dzielnik=dzielnik/1.09
	# 
	# 
	# {
	#     draw_set_font(global.map_fonts_1)
	#     draw_set_color(c_white)
	#     draw_set_alpha(alphar1)
	#     draw_set_halign(fa_center)
	#     draw_set_valign(fa_middle)
	#     draw_text_transformed(view_xview[0]+400+pos_offset,view_yview[0]+350,"Please Choose language",wielkosc+wielkor,wielkosc+wielkor,0)
	#     draw_set_alpha(alphar2)
	#     draw_text_transformed(view_xview[0]+400+pos_offset,view_yview[0]+350,"ProszÄ™ Wybierz JÄ™zyk",wielkosc+wielkor,wielkosc+wielkor,0)
	#     draw_set_alpha(alphar0)
	# 
	# }
	# 
	# timer+=1
	# if timer>0 && timer<200
	#     {
	#     if alphar1<1 {alphar1+=0.05}
	#     if alphar2>0 {alphar2-=0.05}
	#     
	#     }
	# if timer>200 && timer<400
	#     {
	#     if timer=202 {wielkor=1}
	#     if alphar1>0 {alphar1-=0.05}
	#     if alphar2<1 {alphar2+=0.05}
	#     }    
	# if timer>=400
	#     {
	#     wielkor=1
	#     timer=0
	#     }  
	# if wielkor>0 {wielkor=wielkor/1.1}
	# 
	# if (global.debug) {
	#     draw_set_font(global.map_fonts_1)
	#     draw_set_color(c_white)
	#     draw_set_alpha(1)
	#     draw_set_halign(fa_left)
	#     draw_set_valign(fa_top)
	#     draw_text_transformed(view_xview[0] + 10, view_yview[0] + 10, "DEBUG MODE ENABLED.
	# F1 TO EXECUTE GML CODE
	# F2 TO RUN COMMANDS", 0.5, 0.5, 0);
	# }
	pass
