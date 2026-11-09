extends Node2D
## GameMaker object "o_CHEST_TO_STAWIAJ" (index 393)
## sprite_index=269 depth=0 solid=0 visible=1 parent=-100 mask=-1

func gm_Create_0() -> void:
	# 
	# 
	# 
	# stream=0
	# image_alpha=0
	# sekwencja=0
	# grawitacja=0
	# timer=0
	# znikaj=1
	# 
	# 
	#             
	#             
	#             
	# /*
	# 
	# rodzaj=0
	pass

func gm_Outside_0() -> void:
	# if global.pauza=0
	#     {
	#     if sekwencja=0 && instance_number(o_enemy_goomba)=0 && instance_number(o_enemy_goomba_lezy)=0
	#         {
	#         sekwencja=1
	#         fofo=instance_create(x,y,o_magic_chest_duel_spawn)
	#         fofo.rodzaj=rodzaj
	#         instance_destroy()
	#                 
	#                 
	#         for (i=0;i<instance_count;i+=1)
	#             {
	#             iii=instance_id[i]
	#             with(iii)
	#                 {
	#                 if variable_local_exists("kapciuj_maliny") {kapciuj_maliny=1} 
	#                 
	#                 
	#                 }
	# 
	#             }
	#             
	#             
	#         }
	#     if sekwencja=0 && instance_number(o_duel_ball)=0
	#         {
	#         fofo=instance_create(x,y,o_magic_chest_duel_spawn)
	#         fofo.rodzaj=rodzaj
	#         sekwencja=1
	#         
	#         for (i=0;i<instance_count;i+=1)
	#             {
	#             iii=instance_id[i]
	#             with(iii)
	#                 {
	# 
	#                 if object_index=o_enemy_goomba_lezy {instance_destroy();part_emitter_burst(global.explosion,global.emit1,global.prt3,8);}
	#                 if object_index=o_enemy_goomba_leci {instance_destroy();part_emitter_burst(global.explosion,global.emit1,global.prt3,8);}
	#                 if object_index=o_enemy_troopa_lezy {instance_destroy();part_emitter_burst(global.explosion,global.emit1,global.prt3,8);}
	#                 if object_index=o_enemy_troopa_leci {instance_destroy();part_emitter_burst(global.explosion,global.emit1,global.prt3,8);}
	#                 
	#                 if object_index=o_enemy_boomerang {instance_destroy();part_emitter_burst(global.explosion,global.emit1,global.prt3,1);}
	#                 if object_index=o_enemy_hammers {instance_destroy();part_emitter_burst(global.explosion,global.emit1,global.prt3,1);}
	#                 if object_index=o_enemy_big_hammers {instance_destroy();part_emitter_burst(global.explosion,global.emit1,global.prt3,1);}
	#                 if object_index=o_lakitu_throw {instance_destroy();part_emitter_burst(global.explosion,global.emit1,global.prt3,1);}
	#                 if object_index=o_enemy_cannon_balls {instance_destroy();part_emitter_burst(global.explosion,global.emit1,global.prt3,1);}
	#                 if object_index=o_enemy_fireballs {instance_destroy();part_emitter_burst(global.explosion,global.emit1,global.prt3,1);}
	#                 if object_index=o_enemy_jelectro {instance_destroy();part_emitter_burst(global.explosion,global.emit1,global.prt3,1);}
	#                 if object_index=o_pirania_fireball {instance_destroy();part_emitter_burst(global.explosion,global.emit1,global.prt3,1);}
	#                 
	#                 
	#                 
	#                 if variable_local_exists("energy") {energy-=10000} 
	#                 if variable_local_exists("kicked") {kicked=1} 
	#                 
	#                 
	# 
	# 
	# 
	# 
	# 
	#                 }
	# 
	#             }
	#             
	#         }      
	#     }
	pass
