extends Node2D
## GameMaker object "o_map_oczy" (index 780)
## sprite_index=398 depth=0 solid=0 visible=1 parent=-100 mask=-1

func gm_Create_0() -> void:
	# sekwencja=0
	pass

func gm_Outside_0() -> void:
	# if point_distance(x,y,global.ekran_srodek_x,global.ekran_srodek_y)<=global.odleglosc_ekranu*1.2 {
	# if random(1000)>990 && sekwencja=0 {sekwencja=1}
	# 
	# if sekwencja=1 && image_yscale>0 {image_yscale-=0.1}
	# if sekwencja=1 && image_yscale<=0 {sekwencja=2}
	# if sekwencja=2 && image_yscale<1 {image_yscale+=0.2}
	# if sekwencja=2 && image_yscale>=1 {sekwencja=0}
	# 
	# draw_sprite_ext(sprite_index,0,x,y,image_xscale,image_yscale*image_xscale,0,c_white,1)
	# 
	# koko1=(o_map_player_1.x-x)/(10/image_xscale)
	# koko2=(o_map_player_1.y-y)/(10/image_xscale)
	# 
	# if koko1<-20 {koko1=-20}
	# if koko1>20 {koko1=20}
	# if koko2<-20 {koko2=-20}
	# if koko2>20 {koko2=20}
	# 
	# x=xstart+koko1
	# y=ystart+koko2}
	pass
