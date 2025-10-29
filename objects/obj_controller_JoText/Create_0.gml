xx = 320
yy = 300
spacer = 75

//label_menu1="START COOP GAME";
//xx_menu1=200
//yy_menu1=500

//label_menu2="START VS GAME";
//xx_menu2=860
//yy_menu2=500

clicked_coop = -1
clicked_vs = -1
clicked_save_defaults = -1

player_count = 0



slime1 = instance_create_layer(xx+(spacer*1), yy,"Instances", obj_gloopCharacterSelect);
slime2 = instance_create_layer(xx+(spacer*2), yy,"Instances", obj_gloopCharacterSelect);
slime3 = instance_create_layer(xx+(spacer*3), yy,"Instances", obj_gloopCharacterSelect);
slime4 = instance_create_layer(xx+(spacer*4), yy,"Instances", obj_gloopCharacterSelect);

slime5 = instance_create_layer(xx+(spacer*5), yy,"Instances", obj_gloopCharacterSelect);
slime6 = instance_create_layer(xx+(spacer*6), yy,"Instances", obj_gloopCharacterSelect);
slime7 = instance_create_layer(xx+(spacer*7), yy,"Instances", obj_gloopCharacterSelect);
slime8 = instance_create_layer(xx+(spacer*8), yy,"Instances", obj_gloopCharacterSelect);


slime1.gloop_color=0
slime1.s_idol=Slm_Blk_Idol
slime1.s_sleep=Slm_Blk_Sleep
slime1.s_jump=Slm_Blk_Roll_R
slime1.sprite_index=Slm_Blk_Sleep
slime1.image_index = 20;

slime2.gloop_color=1
slime2.s_idol=Slm_Blu_Idol
slime2.s_sleep=Slm_Blu_Sleep
slime2.s_jump=Slm_Blu_Roll_R
slime2.sprite_index=Slm_Blu_Sleep
slime2.image_index = 20;


slime3.gloop_color=2
slime3.s_idol=Spr_Slm_Idol
slime3.s_sleep=Spr_Slm_Sleep
slime3.s_jump=Spr_Slm_Roll_R
slime3.sprite_index=Spr_Slm_Sleep
slime3.image_index = 20;


slime4.gloop_color=3
slime4.s_idol=Slm_Orn_Idol
slime4.s_sleep=Slm_Orn_Sleep
slime4.s_jump=Slm_Orn_Roll_R
slime4.sprite_index=Slm_Orn_Sleep
slime4.image_index = 20;


slime5.gloop_color=4
slime5.s_idol=Slm_Pur_Idol
slime5.s_sleep=Slm_Pur_Sleep
slime5.s_jump=Slm_Pur_Roll_R
slime5.sprite_index=Slm_Pur_Sleep
slime5.image_index = 20;


slime6.gloop_color=5
slime6.s_idol=Slm_Red_Idol
slime6.s_sleep=Slm_Red_Sleep
slime6.s_jump=Slm_Red_Roll_R
slime6.sprite_index=Slm_Red_Sleep
slime6.image_index = 20;


slime7.gloop_color=6
slime7.s_idol=Slm_Wht_Idol
slime7.s_sleep=Slm_Wht_Sleep
slime7.s_jump=Slm_Wht_Roll_R
slime7.sprite_index=Slm_Wht_Sleep
slime7.image_index = 20;


slime8.gloop_color=7
slime8.s_idol=Slm_Yel_Idol
slime8.s_sleep=Slm_Yel_Sleep
slime8.s_jump=Slm_Yel_Roll_R
slime8.sprite_index=Slm_Yel_Sleep
slime8.image_index = 20;
