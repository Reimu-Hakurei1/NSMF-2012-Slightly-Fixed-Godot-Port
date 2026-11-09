extends Node2D
## GameMaker object "o_desert_moving_rock_parental" (index 421)
## sprite_index=324 depth=0 solid=0 visible=1 parent=1 mask=-1

func gm_Create_0() -> void:
	# bujalnik=1
	# grafika=round(random(2))
	# if grafika=0 {sprite_index=s_desert_rock_1}
	# if grafika=1 {sprite_index=s_desert_rock_2}
	# if grafika=2 {sprite_index=s_desert_rock_3}
	# 
	# cien=instance_create(x,y,o_desert_rock_cien)
	# /*
	# 
	# kat=0
	# step_x=0
	# kat2=0
	# step_y=0
	# rodzaj=0
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
	#         
	#         
	#         cien.x=x
	#         cien.y=y
	#         cien.depth=depth+10
	#     }
	pass
