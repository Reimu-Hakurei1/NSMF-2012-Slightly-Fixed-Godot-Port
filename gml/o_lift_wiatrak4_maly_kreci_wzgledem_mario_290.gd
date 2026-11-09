extends Node2D
## GameMaker object "o_lift_wiatrak4_maly_kreci_wzgledem_mario" (index 290)
## sprite_index=27 depth=0 solid=0 visible=1 parent=-100 mask=-1

func gm_Create_0() -> void:
	# kreciuj=0
	# krec=0
	# sampel=0
	# 
	# kat=0
	# odleglosc=100
	# for (i=0;i<4;i+=1)
	#     {
	#     dodo[i]=instance_create(x,y,obj_lift)
	#     dodo[i].rodzaj=101
	#     dodo[i].nalezydo=id
	#     }
	pass

func gm_Outside_0() -> void:
	# if point_distance(x,y,global.ekran_srodek_x,global.ekran_srodek_y)<=global.odleglosc_ekranu*1.5 {
	# 
	# 
	# 
	#         draw_sprite_ext(s_krazek_1,0,x,y,1,1,0,c_white,1)
	# 
	#     for(i=0;i<4;i+=1)
	#         {
	#         draw_sprite_ext(s_krazek_1,0,
	#         x+sin(degtorad(kat+i*90))*odleglosc/2,
	#         y+cos(degtorad(kat+i*90))*odleglosc/2
	#         ,1,1,0,c_white,1)
	#         }
	#         
	#     for(i=0;i<4;i+=1)
	#         {
	#         draw_sprite_ext(s_krazek_1,0,
	#         x+sin(degtorad(kat+i*90))*odleglosc,
	#         y+cos(degtorad(kat+i*90))*odleglosc
	#         ,1,1,0,c_white,1)
	#         }
	#         
	#         
	# }
	pass

func gm_Step_Step() -> void:
	# if global.pauza=0
	#     {
	#     sampel+=abs(kreciuj)
	#     if sampel>20{
	#     sampel=0
	#     SXMS_SFX_PlayExt(115,((x-view_xview[0])/800)*255,global.glosnosc_dzwieku,-1,0,0)}
	#     
	#     kreciuj=kreciuj/1.01
	#     if krec=1{
	#     
	#     if obj_mario.x>x {kreciuj+=(x-obj_mario.x)/1000}
	#     if obj_mario.x<x {kreciuj+=(x-obj_mario.x)/1000};krec=0}
	#     
	#     kat+=kreciuj
	#     for(i=0;i<4;i+=1)
	#         {
	#         dodo[i].doceluj_x=x+sin(degtorad(kat+i*90))*odleglosc
	#         dodo[i].doceluj_y=y+cos(degtorad(kat+i*90))*odleglosc
	#         
	#         
	#         }
	#     
	#     
	#     
	#     
	#     
	#     }
	#     
	#     
	#     
	# 
	# 
	# 
	# 
	# 
	# 
	# /*kat=0
	# odleglosc=0
	# for (i=0;i<4;i+=1)
	#     {
	#     dodo[i]=instance_create(x,y,obj_lift)
	#     dodo[i].rodzaj=100
	#     }
	pass
