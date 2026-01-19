ismoving = 0;
isjumping=0;
isrolling=0;
isslurp=0;
issleep=0
isteleporting=0 
isDayEnd=0

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
prev_grid_number = noone //added to have slower trail movement


gloop_score_obj = instance_create_layer(1, 1, "Instances", obj_gloop_score);
gloop_score_obj.player = player_number
gloop_score_obj.parent_sprite = Slm_All_Base_Faceless
gloop_score_obj.gloop=id

has_targeting_cursor = 0

selected_grid=noone

//Power Up Code
powerUp1=0
powerUp2=0
powerUp3=0

puBonk=0
rainbow_power=0
rainbow_delay=0.0
gloop_color_index_old=0
has_crown=0
draw_hat=0
has_accessory=0

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
hat_index=sh_idol

sa_idol = Spr_Acc_Cat_Idol
sa_sleep = Spr_Acc_Cat_Sleep
sa_death = Spr_Acc_Cat_Death
sa_jump = Spr_Acc_Cat_Move_Jump
sa_roll = Spr_Acc_Cat_Move_Roll
sa_roll_R = Spr_Acc_Cat_Move_Spin
sa_teleport = Spr_Acc_Cat_Tele
sa_slurp = Spr_Acc_Cat_Move_Slurp
accessory_index=sa_idol




test_trail_index=0




sprite_prefetch(spr_palette_index);


