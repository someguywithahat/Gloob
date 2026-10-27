draw_sprite(Spr_Shell, floor(shell_frame), x, y)

//The fish bowl in the clam's mouth.  Starts flat when the lid comes off and grows upward to full size as it opens
var grown = bowl_size()
if grown>0
{
	//Spr_Bowl sprites have a top left origin.  Center it on the clam and stand it on the mouth
	var bowl_w = sprite_get_width(bowl_sprite)
	var bowl_h = sprite_get_height(bowl_sprite)
	var bowl_x = x - bowl_w/2
	var bowl_y = y + mouth_y + bowl_h*bowl_lower - bowl_h*grown
	draw_sprite_ext(bowl_sprite, floor(bowl_frame), bowl_x, bowl_y, 1, grown, 0, c_white, 1)
}
