//Not caught yet: the empty bowl (the object's own sprite, sized in the room editor).
//Caught: the fish in its bowl, moved up so it sits on the shelf the same way
if caught and bowl_sprite>=0
	draw_sprite_ext(bowl_sprite, floor(frame), x, y-empty_drop*image_yscale, image_xscale, image_yscale, 0, c_white, 1)
else
	draw_self()
