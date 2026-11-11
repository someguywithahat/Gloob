//Leaving the room: clear away any splashes still playing
for (var i = 0; i < array_length(splashes); i++)
	layer_sprite_destroy(splashes[i].el)
splashes = []
