extends Node2D
## GameMaker object "obj_mario_anim" (index 306)
## sprite_index=218 depth=0 solid=0 visible=1 parent=-100 mask=-1

func gm_Create_0() -> void:
	# spadajace=0
	# 
	# 
	# wiatraczkowanie=0 // animacja obracania wiatraczkiem dla bonusu = 10
	# wiatrak_obracator=0 // przyspieszone obracanie wiatraczkiem
	# 
	# 
	# miganie=0;migacz2=0; // zmienne migania gracza jak oberwal
	# 
	# power_star_powiekszator=0
	# power_star_kolorek=c_white
	# animowanie=0
	# 
	# image_alphar=1
	# ruchanko_pod_koniec_etapu=0
	# 
	# swim_nozkowanie=0
	# swim_nozkowanie2=0
	# 
	# ogon_merda=0
	# ogon_uderzak=0
	# tanooki_sizer=0
	# bieg_sampel=0
	# climbing=0
	# 
	# //
	# 
	# 
	# anim=0
	# anim_docelowy=0
	# migacz=0
	# 
	# 
	# nalezy_do=0
	# anim_mario_start=0
	# anim_mario_zmiana=0
	# 
	# 
	# 
	# 
	# kopniak=0
	# 
	# fifel=0
	# 
	# bujanie_nogami=0
	# 
	# linowanie=0
	# 
	# size=1
	# size2=-1
	# szybkosc_biegu=-20
	# berserk=0
	# kat=0
	# lolo=0
	# run_kat=0
	# run_promien=0
	# run_pochylenie=0
	# animacja=0
	# jump=0
	# schylanie=0
	# torpeda=0
	# torpeda2=0
	# 
	# hamowanie=0
	# 
	# berserk=1
	# berserk2=0
	# berserk3=0
	# berserk4=0
	# berserk5=0
	# berserk6=0
	# 
	# stanie=0
	# 
	# strzelanie=1
	# strzelanie2=0
	# 
	# mrugacz[0]=0
	# mrugacz[1]=0
	# mrugacz[2]=0
	# 
	# kierunek=1
	# 
	# schylak=0
	# schylak_sek=0
	# 
	# bieganie_reki=0
	# globalny_kat=0
	# 
	# niesie=0
	# 
	# drazkowanie=0
	# 
	# /* DnD lib=1 id=605 kind=0 fn='' args=(zmienne do collected item) */
	# ducher=0
	# ducher_y=80
	# ducher_obracacz=0
	# duch_alpha=0
	# duch_efekter=100
	# 
	# /* DnD lib=1 id=605 kind=0 fn='' args=(ustaw grafike mario taka jaka w poprzednim etapie) */
	# anim=max(0,global.rodzaj_mario-1)
	pass

func gm_Intersect_38() -> void:
	# //strzelanie2=190
	pass

func gm_Intersect_49() -> void:
	# //berserk2=1
	pass

func gm_Intersect_50() -> void:
	# //size2=-1
	pass

func gm_Intersect_51() -> void:
	# //size2=1
	pass

func gm_Intersect_52() -> void:
	# //size+=0.1
	pass

func gm_Intersect_53() -> void:
	# //size-=0.1
	pass

func gm_Keyboard_37() -> void:
	# //schylanie-=3 run_pochylenie+=3
	pass

func gm_Keyboard_39() -> void:
	# //schylanie+=3 run_pochylenie-=3
	pass

func gm_Keyboard_54() -> void:
	# /*globalny_kat+=5
	pass

func gm_Keyboard_55() -> void:
	# /*globalny_kat-=5
	pass

func gm_Keyboard_56() -> void:
	# /*fifel-=1
	pass

func gm_Keyboard_57() -> void:
	# /*fifel+=1
	pass

func gm_Outside_0() -> void:
	# script_mario_anim()
	# 
	# /* DnD lib=1 id=605 kind=0 fn='' args=(collected item) */
	# if global.pauza=0{
	# if global.rodzaj_mario=5
	#     {
	#     if ducher_y>0 {ducher_y=ducher_y/1.05}
	#     if duch_alpha<1 {duch_alpha+=0.05}
	#     }
	# if global.rodzaj_mario<>5
	#     {
	#     if ducher_y<80 {ducher_y+=1+ducher_y/10}
	#     if duch_alpha>0 {duch_alpha-=0.05}
	#     }
	#     
	#     
	#     
	#     } // koniec pauzy
	#     
	#     ducher_obracacz+=2
	#     
	#     if ducher_y<80{
	#     
	#     
	#     
	#     
	#     if global.ducher_zamieniony=0 {draw_sprite_ext(s_changer,0,x,y,global.ducher_ladowanie/20,global.ducher_ladowanie/20,0,c_white,global.ducher_ladowanie/20)}
	#     }
	pass
