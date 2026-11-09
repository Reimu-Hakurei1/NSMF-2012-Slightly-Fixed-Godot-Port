extends RefCounted
## GameMaker script "hex_write" kept verbatim as comments.
## GML calls this by name with positional arguments.

func run(_a = null, _b = null, _c = null, _d = null) -> void:
	# /* Zapisuje wybranï¿½ wartosc, maxymalnie jako 4.294.967.296 pod odpowiednia pozycja
	# 
	# hex_write(stream,position,variable)
	# stream - ID otwartego pliku
	# position - pozycja w pliku
	# variable - wartosc ktora zapisujesz
	# */
	# 
	# var num1,num2,num3,num4,filesize;
	# 
	# num1=argument2 mod 256
	# num2=floor(argument2/256) mod 256
	# num3=floor(argument2/65536) mod 256
	# num4=floor(argument2/16777216) mod 256
	# 
	# filesize = file_bin_size(argument0);
	# if (argument1*4 >= filesize) {
	#     file_bin_seek(argument0,filesize)
	#     repeat (argument1*4 - filesize) {
	#         file_bin_write_byte(argument0,0)
	#     }
	# }
	# 
	# file_bin_seek(argument0,argument1*4)
	# file_bin_write_byte(argument0,num1)
	# file_bin_write_byte(argument0,num2)
	# file_bin_write_byte(argument0,num3)
	# file_bin_write_byte(argument0,num4)
	pass
