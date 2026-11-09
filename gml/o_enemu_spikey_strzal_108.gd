extends Node2D
## GameMaker object "o_enemu_spikey_strzal" (index 108)
## sprite_index=48 depth=-9999 solid=0 visible=1 parent=-100 mask=11

func gm_Create_0() -> void:
	# grawitacja=0
	# szybkosc=0
	# strzelony=0
	pass

func gm_Outside_0() -> void:
	# if global.pauza=0
	#     {
	#     if strzelony=0
	#         {
	#         y+=grawitacja
	#         grawitacja+=0.05
	#         x+=szybkosc
	#         image_angle=point_direction(x,y,x+szybkosc*10,y+grawitacja*10)
	#         }
	#     
	#     if place_meeting(x,y,obj_wall) {strzelony=1}
	#     if strzelony=1 && image_alpha>0 {image_alpha-=0.05}
	#     if image_alpha<=0 {instance_destroy()}
	#     
	#     if place_meeting(x,y,obj_mario) && image_alpha=1
	#         {
	#         player=instance_place(x,y,obj_mario)
	#         player.oberwal=1
	#         }
	#     }
	#     
	#     
	#     
	#     draw_sprite_ext(s_spikey_10,0,x,y,1,0.5,image_angle,c_white,image_alpha)
	#     draw_sprite_ext(sprite_index,0,x,y,1,1,image_angle,c_white,image_alpha)
	pass
