/*
Add shop items here.  Shop item definitions:

sprite
	This can be any sprite
shader_palette
	spr_palette_all = apply gloop shader to object
	spr_palette_seasons_all = apply seasons shader to object
	noone = no shaders
frames_sold_seperately
	true = each frame of the sprite is a different shop item
	false = only sell the first sprite image
shader_sold_seperately
	true = every possible shader of the sprite is a different shop item
	false = no shader, or shader is handled by weather controller
cost
	How many points the object costs
animation_speed
	Set to 0 unless you want the sprite animated
type
	0 = object
	1 = gloop
	2 = weather
	3 = music

*/

function scr_shop_items(){
global.SHOPITEMS = [
    { sprite: Spr_Obs_1x1, shader_palette: spr_palette_seasons_all, frames_sold_seperately: true, shader_sold_seperately: false, cost: 10, animation_speed: 0, type: 0},
    { sprite: Spr_Obs_1x2, shader_palette: spr_palette_seasons_all, frames_sold_seperately: true, shader_sold_seperately: false, cost: 20, animation_speed: 0, type: 0},
    { sprite: Spr_Obs_2x1, shader_palette: spr_palette_seasons_all, frames_sold_seperately: true, shader_sold_seperately: false, cost: 20, animation_speed: 0, type: 0},
    { sprite: Spr_Obs_2x2, shader_palette: spr_palette_seasons_all, frames_sold_seperately: true, shader_sold_seperately: false, cost: 30, animation_speed: 0, type: 0},
    { sprite: Spr_Obs_3x3, shader_palette: spr_palette_seasons_all, frames_sold_seperately: true, shader_sold_seperately: false, cost: 50, animation_speed: 0, type: 0},
	
	{ sprite: Spr_Garden_1x1, shader_palette: spr_palette_seasons_all, frames_sold_seperately: true, shader_sold_seperately: true, cost: 10, animation_speed: 0, type: 0},
	{ sprite: Spr_Garden_1x2, shader_palette: spr_palette_seasons_all, frames_sold_seperately: true, shader_sold_seperately: false, cost: 50, animation_speed: 0, type: 0},
	
    { sprite: Spr_Fence, shader_palette: spr_palette_seasons_all, frames_sold_seperately: true, shader_sold_seperately: false, cost: 25, animation_speed: 0, type: 0},
    { sprite: Spr_House_Mushroom, shader_palette: spr_palette_all, frames_sold_seperately: false, shader_sold_seperately: true, cost: 100, animation_speed: 0, type: 0},
	
    { sprite: Spr_Fire, shader_palette: noone, frames_sold_seperately: false, shader_sold_seperately: false, cost: 100, animation_speed: 1, type: 0},
	
	//debugging effect
    //{ sprite: spr_effect_glow, shader_palette: noone, frames_sold_seperately: false, shader_sold_seperately: false, cost: 100, animation_speed: 0, type: 0},	
	
    { sprite: Sm_Shrm_Grn, shader_palette: spr_palette_all, frames_sold_seperately: false, shader_sold_seperately: true, cost: 5, animation_speed: 0, type: 0},
    { sprite: Spr_Slm_Idol, shader_palette: spr_palette_all, frames_sold_seperately: false, shader_sold_seperately: true, cost: 1000, animation_speed: 0.25, type: 1}
];
}