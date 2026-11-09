extends Node2D
## GameMaker object "o_title_screen_logo_MARIO_FOREVER" (index 908)
## sprite_index=-1 depth=-1215752192 solid=0 visible=1 parent=-100 mask=-1

func gm_Create_0() -> void:
	# sampleroza=0
	# used_1=0
	# 
	# credit_alpha = 0
	# 
	# k1=0
	# k2=0
	# 
	# 
	# merdacz_kat=0
	# merdacz=0
	# merdacz_delay=0
	# 
	# 
	# zaczyna_sie=0
	# 
	# 
	# sekwencja=0
	# timer=0
	# 
	# stream=0
	# 
	# adder1=1000
	# adder2=1000
	# 
	# 
	# stream1=0
	# pompon1=0
	# 
	# 
	# 
	# stream2=0
	# pompon2=0
	# 
	# 
	# wielkosc=1
	# 
	# przesowanko=0
	# przesowanko2=0
	pass

func gm_Outside_0() -> void:
	# draw_sprite_ext(global.big_glow_sloneczny,0,x,y+przesowanko*global.ekran_size_act,2,2,zaczyna_sie,c_white,1)
	# draw_sprite_ext(global.big_glow_sloneczny,0,x,y+przesowanko*global.ekran_size_act,1,1,-zaczyna_sie,c_white,1)
	# 
	# title_offset = -30;
	# 
	# zaczyna_sie+=1
	# if zaczyna_sie=400 && used_1=0
	#     {
	#     used_1=1
	#     przesowanko2=-15
	#     }
	# if przesowanko2<>0 {przesowanko+=przesowanko2;przesowanko2=przesowanko2/1.1}
	# 
	# 
	# x=view_xview[0]+view_wview[0]/2
	# y=view_yview[0]+view_hview[0]/2
	# 
	# 
	# merdacz_delay+=1
	# if merdacz_delay=100 {merdacz_kat=40;SXMS_SFX_PlayExt(31,((x-view_xview[0])/800)*255,global.glosnosc_dzwieku,-1,0,0)}
	# if merdacz_delay=130 {merdacz_kat=40;SXMS_SFX_PlayExt(31,((x-view_xview[0])/800)*255,global.glosnosc_dzwieku,-1,0,0)}
	# if merdacz_kat>0 {merdacz_kat=merdacz_kat/1.03}
	# merdacz+=1+merdacz_kat
	# 
	# 
	# 
	# k2+=1
	# if k2>300 && k1<0.3 {k1+=0.001}
	# 
	# 
	# draw_sprite_ext(s_mega_sparcle_1,0,x+adder1-220*global.ekran_size_act,y+przesowanko*global.ekran_size_act,wielkosc*global.ekran_size_act*3,wielkosc*global.ekran_size_act*3,sin(stream)*1+stream*22,c_white,k1)
	# draw_sprite_ext(s_mega_sparcle_1,0,x+adder1-220*global.ekran_size_act+44*global.ekran_size_act,y+przesowanko*global.ekran_size_act+44*global.ekran_size_act,wielkosc*global.ekran_size_act*2,wielkosc*global.ekran_size_act*2,sin(stream)*1+stream*5,c_white,k1/3)
	# draw_sprite_ext(s_mega_sparcle_1,0,x+adder1-220*global.ekran_size_act+104*global.ekran_size_act,y+przesowanko*global.ekran_size_act+24*global.ekran_size_act,wielkosc*global.ekran_size_act*2,wielkosc*global.ekran_size_act*2,sin(stream)*1+stream*10+41,c_white,k1/2)
	# 
	# 
	# draw_sprite_ext(global.title_tail,0,x+adder1+240*global.ekran_size_act,title_offset+y+przesowanko*global.ekran_size_act,wielkosc*global.ekran_size_act+sin(stream)/100+sin(degtorad(stream1))/20*(pompon1+1),wielkosc*global.ekran_size_act-sin(stream*2)/500-sin(degtorad(stream1))/20*(pompon1+1),sin(stream)*1+sin(degtorad(merdacz))*merdacz_kat,c_white,1)
	# draw_sprite_ext(global.title_screen_main1,0,
	# x+adder1,title_offset+y+przesowanko*global.ekran_size_act,wielkosc*global.ekran_size_act+sin(stream)/100+sin(degtorad(stream1))/20*(pompon1+1),wielkosc*global.ekran_size_act-sin(stream*2)/500-sin(degtorad(stream1))/20*(pompon1+1),sin(stream)*1,c_white,1)
	# draw_sprite_ext(global.title_screen_main2,0,x+170*global.ekran_size_act+adder2,title_offset+y+50*global.ekran_size_act+przesowanko*global.ekran_size_act,wielkosc*global.ekran_size_act+sin(stream+2)/100+sin(degtorad(stream2))/20*(pompon2+1),wielkosc*global.ekran_size_act-sin(stream*2+2)/500-sin(degtorad(stream2))/20*(pompon2+1),sin(stream+2)*1,c_white,1)
	# stream+=0.01
	# 
	# draw_set_font(global.map_fonts_1)
	# draw_set_color(c_white)
	# draw_set_halign(fa_center)
	# draw_set_valign(fa_right)
	# draw_text_transformed(
	#     x+150*global.ekran_size_act+adder2,
	#     title_offset+y+100*global.ekran_size_act+przesowanko*global.ekran_size_act,
	#     "SLIGHTLY-FIXED EDITION",
	#     wielkosc*global.ekran_size_act+sin(stream)/100+sin(degtorad(stream1))/20*(pompon1+1),
	#     wielkosc*global.ekran_size_act-sin(stream*2)/500-sin(degtorad(stream1))/20*(pompon1+1),
	#     sin(stream)*1
	# );
	# 
	# 
	# stream1+=2+pompon1*5
	# if pompon1>0 {pompon1=pompon1/1.05}
	# 
	# stream2+=2+pompon2*5
	# if pompon2>0 {pompon2=pompon2/1.05}
	# 
	# 
	# if sampleroza=0 && adder1<200 {SXMS_SFX_PlayExt(411,((x-view_xview[0])/800)*255,global.glosnosc_dzwieku,-1,0,0);sampleroza=1}
	# if sampleroza=1 && adder2<10 {SXMS_SFX_PlayExt(412,((x-view_xview[0])/800)*255,global.glosnosc_dzwieku/1.2,-1,0,0);sampleroza=2}
	# 
	# 
	# 
	# timer+=1
	# if timer>20 {adder1=adder1/1.3}
	# if timer=50 {pompon1=10}
	# if timer>40 {adder2=adder2/1.3}
	# if timer=60 {pompon2=10}
	# 
	# if credit_alpha<1 {credit_alpha+=0.01}
	# draw_set_font(global.map_fonts_1)
	# draw_set_color(c_white)
	# draw_set_halign(fa_left)
	# draw_set_valign(fa_bottom)
	# draw_set_alpha(credit_alpha)
	# draw_text_transformed(
	#     view_xview[0] + 10,
	#     view_yview[0] + view_hview[0] - 10,
	#     "ORIGINAL BY SOFTENDO
	# MODDED BY CST1229 (" + obj_global_manager.sfe_version + ")",
	#     global.ekran_size_act * 0.75,
	#     global.ekran_size_act * 0.75,
	#     0
	# );
	# draw_set_alpha(1)
	pass
