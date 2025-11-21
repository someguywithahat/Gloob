ismoving = 0;
isjumping=0;
isrolling=0;
issleep=0
isteleporting=0 //24-31
//debug_int = 0

player_number=1
grid_x=1
grid_y=1
alive=1

next_target_x = 1;
next_target_y = 1;
target_x = 1;
target_y = 1;

derX = 0;
derY = 0;
prev_derX = 0; 
prev_derY = 0;
move_speed =1;
diagonal_speed=move_speed;

gridNumberX=x
gridNumberY=y
gridNumberPrevX=0
gridNumberPrevY=0

gloop_score=0

idletime=1
sleeptime=20

pickup_counter = 0;
pickup_target = 0;
image_speed = 1
depth=-2000

gloop_color = "green"
gloop_color_index = 0

trail = Trl_Grn_Mid

current_grid_number = noone


gloop_score_obj = instance_create_layer(1, 1, "Instances", obj_gloop_score);
gloop_score_obj.player = player_number
gloop_score_obj.parent_sprite = Slm_All_Base_Faceless
gloop_score_obj.gloop=id

has_targeting_cursor = 0

//Power Up Code
powerUp1=0
powerUp2=0
powerUp3=0

puBonk=0
rainbow_power=0
rainbow_delay=0.0
gloop_color_index_old=0

is_glowing=0

s_idol = Spr_Slm_Hat_Idol
s_sleep = Spr_Slm_Hat_Sleep
s_death = Spr_Slm_Hat_Death
s_jump = Spr_Slm_Hat_Move_Jump
s_roll = Spr_Slm_Hat_Move_Roll
s_roll_R = Spr_Slm_Hat_Move_Spin
s_teleport = Spr_Slm_Hat_Tele
s_slurp = Spr_Slm_Move_Slurp

sh_idol = Spr_Slm_Hat_Idol
sh_sleep = Spr_Slm_Hat_Sleep
sh_death = Spr_Slm_Hat_Death
sh_jump = Spr_Slm_Hat_Move_Jump
sh_roll = Spr_Slm_Hat_Move_Roll
sh_roll_R = Spr_Slm_Hat_Move_Spin
sh_teleport = Spr_Slm_Hat_Tele
sh_slurp = Spr_Slm_Move_Slurp
hat_index=Spr_Slm_Hat_Idol

//s_idol = Spr_Slm_Idol
//s_sleep = Spr_Slm_Sleep
//s_death = Spr_Slm_Death
//s_jump = Spr_Slm_Move_Jump
//s_roll = Spr_Slm_Move_Roll
//s_roll_R = Spr_Slm_Move_Spin
//s_slurp = Spr_Slm_Move_Slurp


sprite_prefetch(spr_palette_index);
//sprite_prefetch(spr_palette_index_red);

///// Create Event - obj_slime
//ps = part_system_create();
//part_system_depth(ps, depth + 1); // draw just above slime’s depth

//// create particle type for the trail
//trail_particle = part_type_create();

//// appearance
////part_type_shape(trail_particle, pt_shape_disk);
//part_type_shape(trail_particle, pt_shape_smoke);
////part_type_shape(trail_particle, pt_shape_ring);
//part_type_size(trail_particle, 0.3, 0.4, 0, 0); // random size range
////part_type_color2(trail_particle, make_color_rgb(90,255,90), make_color_rgb(50,180,50));
//part_type_color2(trail_particle, color, color);
//part_type_alpha2(trail_particle, 0.8, 0); // fades out
//part_type_orientation(trail_particle, 0, 360, 0, 0,0); // random rotation

//// movement / lifetime
////part_type_speed(trail_particle, 0.1, 0.3, 0, 0);
//part_type_speed(trail_particle, 0, 0.001, 0, 0);
////part_type_direction(trail_particle, 0, 359, 0, 0);
//part_type_direction(trail_particle, 0, 1, 0, 0);
//part_type_gravity(trail_particle, 0, 270); // no gravity
//part_type_life(trail_particle, 3200, 6400);    // frames before fade/destruction


