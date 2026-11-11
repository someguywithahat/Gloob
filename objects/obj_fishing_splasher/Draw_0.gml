//x, y is the middle of the slime at the water line.  The slime sprites are 32x32, top left origin, body bottom at row 31

//---- Mallow's trophy clam (secret), while it's showing: drawn first, so she and her bowl sit in it ----
if shell_alpha>0
	draw_sprite_ext(Spr_Shell, floor(shell_frame), shell_x, shell_y, 1, 1, 0, c_white, shell_alpha)

//Ripples on the water where it is (only while it's in the water up top)
if state="dive" or state="peek" or state="chase" or state="happy"
{
	var ring = (current_time/600 + real(id)) mod 1 //Grows outward and fades, over and over
	draw_set_color(c_white)
	draw_set_alpha(0.35*(1-ring))
	draw_ellipse(x-8-ring*10, y-2-ring*3, x+8+ring*10, y+2+ring*3, true)
	draw_set_alpha(1)
}

shader_set(shd_palette_swap)
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig")
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap")
var u_color_count = shader_get_uniform(shd_palette_swap, "color_count")
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0))
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, color_index))
shader_set_uniform_f(u_color_count, 6.0)

switch (state)
{
	case "peek":
	case "chase":
	case "happy":
		//Just its head out of the water, bobbing a little: the top of the sprite down to just below its eyes.
		//Happy after a marshmallow, and keen while it's going after one
		var bob = round(sin(current_time/250 + real(id))*1)
		var show = 22 + bob
		if state="peek"
			draw_sprite_part(Spr_Slm_Idol, floor(anim) mod sprite_get_number(Spr_Slm_Idol), 0, 0, 32, show, x-16, y-show)
		else
			draw_sprite_part(Slm_All_Base_Expressions, UG_FACE.HAPPY, 0, 0, 32, show-2, x-16, y-(show-2)) //The faces sit 2 pixels higher
		break

	case "jump":
		//Leaping, flipped to face where it's going
		var k = min(1, state_time/jump_frames)
		var lift = jump_height*4*k*(1-k)
		var img = k*sprite_get_number(Spr_Slm_Move_Jump)*0.999
		var draw_x = (facing<0) ? x+16 : x-16
		draw_sprite_ext(Spr_Slm_Move_Jump, img, draw_x, y-28-lift, facing, 1, 0, c_white, 1)
		break

	case "fall":
		//Tumbling down the waterfall, dizzy, turned around her middle (16, 16)
		var c = dcos(fall_angle)
		var s = dsin(fall_angle)
		var mid_y = y-14
		//The top left corner (-16, -16 from her middle), turned by the angle
		draw_sprite_ext(Slm_All_Base_Expressions, UG_FACE.DIZZY, x + (-16*c - 16*s), mid_y + (16*s - 16*c), 1, 1, fall_angle, c_white, 1)
		break

	case "sunk":
		//Under the water, angry, bobbing slowly
		var sunk_bob = round(sin(current_time/600)*1.5)
		draw_sprite(Slm_All_Base_Expressions, UG_FACE.ANGRY, x-16, y-28+sunk_bob)
		break

	case "trophy":
		//In the bowl, angry, growing in with the bowl as the clam opens
		var grown = trophy_bowl_size()
		if grown>0
		{
			var base_y = trophy_bowl_base()
			draw_sprite_ext(Slm_All_Base_Expressions, UG_FACE.ANGRY, shell_x-16*grown, base_y-3-27*grown, grown, grown, 0, c_white, 1)
		}
		break

	case "trophy_jump":
		//Out of the bowl in an arc, still angry
		var tk = min(1, state_time/trophy_jump_frames)
		var tlift = trophy_jump_height*4*tk*(1-tk)
		var tdraw_x = (facing<0) ? x+16 : x-16
		draw_sprite_ext(Slm_All_Base_Expressions, UG_FACE.ANGRY, tdraw_x, y-27-tlift, facing, 1, 0, c_white, 1)
		break
}
shader_reset()

//The bowl goes over her, so she's inside the glass (Spr_Empty_Bowl's base is 42 pixels down)
if state="trophy" or (state="trophy_jump" and shell_alpha>0)
{
	var bowl_grown = trophy_bowl_size()
	if bowl_grown>0
		draw_sprite_ext(Spr_Empty_Bowl, 0, shell_x-36, trophy_bowl_base()-42*bowl_grown, 1, bowl_grown, 0, c_white, shell_alpha)
}

//Sunk: the catch net under her when the mouse is over her, like the fish.  Faded out when the boat is too far away
if state="sunk" and hovered
{
	var net_scale = 0.5
	var net_x = x - sprite_get_width(Spr_Catch_net)/2*net_scale
	var net_y = y-14 - sprite_get_height(Spr_Catch_net)/2*net_scale
	draw_sprite_ext(Spr_Catch_net, 0, net_x, net_y, net_scale, net_scale, 0, in_range ? c_white : c_gray, in_range ? 1 : 0.35)
}
