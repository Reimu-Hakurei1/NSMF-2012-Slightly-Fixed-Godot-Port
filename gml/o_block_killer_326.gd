extends Node2D
## GameMaker object "o_block_killer" (index 326)
## sprite_index=2 depth=0 solid=0 visible=0 parent=-100 mask=-1

func gm_Create_0() -> void:
	# kill=0
	pass

func gm_Step_Step() -> void:
	# if global.pauza=0
	#     {
	#     kill+=1
	#     if kill>=3 {instance_destroy()}
	#     if place_meeting(x,y,o_COIN) {coin=instance_place(x,y,o_COIN);with(coin){instance_destroy()};SXMS_SFX_PlayExt(20,((x-view_xview[0])/800)*255,global.glosnosc_dzwieku,-1,0,0);global.coins+=1;instance_create(x+16,y+16,o_point_coin);}
	#     if place_meeting(x,y,o_enemy_goomba) {repeat(10) {part_particles_create(global.particle_sys_2,x+random(50),y,global.part_effect_star5_gravity,1)};kokoz=instance_place(x,y,o_enemy_goomba); kokoz.energy-=1}
	#     instance_destroy()
	#     }
	pass
