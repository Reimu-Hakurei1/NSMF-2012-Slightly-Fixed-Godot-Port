extends RefCounted
## GameMaker script "hex_read" kept verbatim as comments.
## GML calls this by name with positional arguments.

func run(_a = null, _b = null, _c = null, _d = null) -> void:
	# /* Czyta wybranï¿½ wartosc
	# byte_read(stream,position)
	# stream - ID otwartego do edycji pliku
	# position - pozycja
	# 
	# Zwraca wartosc danej wartosci
	# */
	# 
	# if (argument[1]*4 >= file_bin_size(argument[0]) && argument_count > 2) {
	#     return argument[2];
	# }
	# 
	# file_bin_seek(argument[0],argument[1]*4)
	# var num1,num2,num3,num4;
	# num1=file_bin_read_byte(argument[0])
	# num2=file_bin_read_byte(argument[0])*256
	# num3=file_bin_read_byte(argument[0])*65536
	# num4=file_bin_read_byte(argument[0])*16777216
	# return num1+num2+num3+num4
	pass
