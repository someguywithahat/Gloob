//Splashes still playing when the fish goes away (caught, or leaving the room)
for (var i = 0; i < array_length(splashes); i++)
	layer_sprite_destroy(splashes[i].el)
splashes = []
