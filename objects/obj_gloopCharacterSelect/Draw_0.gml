	if has_accessory=0
	{
		sa = spr_effect_heart
		sa_idol = Spr_Acc_Cat_Idol
		sa_sleep = Spr_Acc_Cat_Sleep
		sa_death = Spr_Acc_Cat_Stun
		sa_jump = Spr_Acc_Cat_Move_Jump
		sa_roll = Spr_Acc_Cat_Move_Roll
		sa_roll_R = Spr_Acc_Cat_Move_Spin
		sa_teleport = Spr_Acc_Cat_Tele
		sa_slurp = Spr_Acc_Cat_Move_Slurp
	}
	if has_accessory=1
	{
		sa = Spr_Acc_Cat
		sa_idol = Spr_Acc_Cat_Idol
		sa_sleep = Spr_Acc_Cat_Sleep
		sa_death = Spr_Acc_Cat_Stun
		sa_jump = Spr_Acc_Cat_Move_Jump
		sa_roll = Spr_Acc_Cat_Move_Roll
		sa_roll_R = Spr_Acc_Cat_Move_Spin
		sa_teleport = Spr_Acc_Cat_Tele
		sa_slurp = Spr_Acc_Cat_Move_Slurp
	}
	else if has_accessory=2
	{
		sa = Spr_Acc_Glasses
		sa_idol = Spr_Acc_Glasses_Idol
		sa_sleep = Spr_Acc_Glasses_Sleep
		sa_death = Spr_Acc_Glasses_Stun
		sa_jump = Spr_Acc_Glasses_Move_Jump
		sa_roll = Spr_Acc_Glasses_Move_Roll
		sa_roll_R = Spr_Acc_Glasses_Move_Spin
		sa_teleport = Spr_Acc_Glasses_Tele
		sa_slurp = Spr_Acc_Glasses_Move_Slurp
	}


draw_sprite_ext(Spr_PU_N, 0, x-16, y-16, 3, 3, 0, c_white, 1);
//draw_sprite_ext(Arrow, 5, x-14, y+80, 1, 1, 0, c_white, 1);
//draw_sprite_ext(Arrow, 7, x+42, y+80, 1, 1, 0, c_white, 1);
clicked_left = scr_draw_menu_item(x-4, y+80,"<",clicked_left)	
clicked_right = scr_draw_menu_item(x+54, y+80,">",clicked_right)	


if sprite_index=s_idol 
	accessory_index=sa_idol
else if sprite_index=s_sleep 
	accessory_index=sa_sleep
else if sprite_index=s_roll_R
	accessory_index=sa_roll_R


// Start shader
shader_set(shd_palette_swap);

// Set uniforms
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig");
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap");
var u_color_count  = shader_get_uniform(shd_palette_swap, "color_count");

// Bind your palette sprites as textures
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0));
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, gloop_color));
//texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index_red, 0));
//texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_index, 0));



// Send color count
shader_set_uniform_f(u_color_count, 6.0);
draw_sprite_ext(sa, 0, x+16, y+80, 1, 1, 0, c_white, 1);

// Draw the sprite
draw_self();
if has_accessory>0	
	draw_sprite_ext(accessory_index, image_index, x, y, 2, 2, 0, c_white, 1);
	//draw_sprite(accessory_index, image_index,x,y)

// End shader
shader_reset();
