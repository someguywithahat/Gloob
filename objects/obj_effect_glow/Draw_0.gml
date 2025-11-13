
//draw_set_blend_mode(bm_add); 
var size = 0.8 + random_range(-0.01,0.01)
gpu_set_blendmode(bm_add); 
draw_sprite_ext(spr_effect_glow, 0, x,y,size,size,0,make_colour_rgb(240,204,100),0.2)
gpu_set_blendmode(bm_normal); 