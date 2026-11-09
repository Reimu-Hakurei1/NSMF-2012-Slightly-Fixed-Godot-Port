extends Node2D
## GameMaker object "o_ghost_ring" (index 232)
## sprite_index=73 depth=0 solid=0 visible=0 parent=-100 mask=-1

func gm_Create_0() -> void:
	# stworz=0
	# /*
	# ilosc_duchow=10
	# kat=0
	# szybkosc_obracania=1
	# odleglosc=200
	pass

func gm_Step_Step() -> void:
	# if global.pauza=0{
	# if stworz=0
	#     {
	#     stworz=1;
	#     
	#     for(i=0;i<ilosc_duchow;i+=1)
	#         {
	#         lolo[i]=instance_create(x,y,o_ghost_ring_child)
	#         if szybkosc_obracania>0 {lolo[i].kierunek=1}
	#         if szybkosc_obracania<0 {lolo[i].kierunek=-1}
	#         }
	#     }
	#     
	# 
	# if point_distance(x,y,global.ekran_srodek_x,global.ekran_srodek_y)<=global.odleglosc_ekranu*2
	#     {
	#     kat+=szybkosc_obracania   
	#     
	#     for(i=0;i<ilosc_duchow;i+=1)
	#         {
	#         lolo[i].x=x+sin(degtorad(360/ilosc_duchow*i+kat))*odleglosc
	#         lolo[i].y=y+cos(degtorad(360/ilosc_duchow*i+kat))*odleglosc
	#         lolo[i].direction=360/ilosc_duchow*i+kat
	# 
	#         }
	#     }}
	pass
