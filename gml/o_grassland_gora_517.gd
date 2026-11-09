extends Node2D
## GameMaker object "o_grassland_gora" (index 517)
## sprite_index=27 depth=0 solid=0 visible=1 parent=421 mask=-1

func gm_Create_0() -> void:
	# bujalnik=1
	# image_xscale=4
	# image_yscale=3
	# 
	# 
	# /*
	# 
	# kat=0
	# step_x=0
	# kat2=0
	# step_y=0
	# rodzaj=0
	pass

func gm_Outside_0() -> void:
	# if point_distance(x,y,global.ekran_srodek_x,global.ekran_srodek_y)<=global.odleglosc_ekranu*1.4
	#     {
	#     draw_sprite_ext(global.ruchoma_platforma_2,0,x,y,1,1,0,c_white,1)
	#     
	#     
	#     }
	pass

func gm_Step_End_Step() -> void:
	# if global.pauza=0 {
	# 
	# // platforma ustawiana, ustalanie odgownie ruszania platformy
	# if rodzaj=1
	#     {
	#     rodzaj=2
	#     }
	# if rodzaj=2
	#     {
	#     kat2+=bujalnik
	#     x+=sin(degtorad(kat))*step_x
	#     y+=cos(degtorad(kat2))*step_y
	#     
	#     
	#     if place_meeting(x,y-5,obj_mario)
	#         {
	#             obj_mario.y+=cos(degtorad(kat2))*step_y
	#             with(obj_mario)
	#                 {
	#                 for (i=0;i<20;i+=1)
	#                     {
	#                     if place_meeting(x,y,o_desert_moving_rock_parental) {y-=1}
	#                     }
	#                 
	#                 }
	#             
	#             
	#             }
	#         }
	#     }
	pass
