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


var xspace = 135
var yspace = 160
slime1 = instance_create_layer(472, 185,"Instances", obj_gloopCharacterSelect);
slime2 = instance_create_layer(472 +(xspace*1), 185,"Instances", obj_gloopCharacterSelect);
slime3 = instance_create_layer(472 +(xspace*2), 185,"Instances", obj_gloopCharacterSelect);
slime4 = instance_create_layer(472 +(xspace*3), 185,"Instances", obj_gloopCharacterSelect);
//slime3 = instance_create_layer(xx+(spacer*3), yy,"Instances", obj_gloopCharacterSelect);
//slime4 = instance_create_layer(xx+(spacer*4), yy,"Instances", obj_gloopCharacterSelect);

slime5 = instance_create_layer(472, 185+(yspace*1),"Instances", obj_gloopCharacterSelect);
slime6 = instance_create_layer(472 +(xspace*1), 185+(yspace*1),"Instances", obj_gloopCharacterSelect);
slime7 = instance_create_layer(472 +(xspace*2), 185+(yspace*1),"Instances", obj_gloopCharacterSelect);
slime8 = instance_create_layer(472 +(xspace*3), 185+(yspace*1),"Instances", obj_gloopCharacterSelect);


slime1.gloop_color=global.GREEN
slime1.gloop_name=global.strGloopGreen
slime1.image_index = 20;

slime2.gloop_color=global.BLUE
slime2.gloop_name=global.strGloopBlue
slime2.image_index = 20;

slime3.gloop_color=global.PURPLE
slime3.gloop_name=global.strGloopPurple
slime3.image_index = 20;

slime4.gloop_color=global.BLACK
slime4.gloop_name=global.strGloopBlack
slime4.image_index = 20;

slime5.gloop_color=global.RED
slime5.gloop_name=global.strGloopRed
slime5.image_index = 20;

slime6.gloop_color=global.ORANGE
slime6.gloop_name=global.strGloopOrange
slime6.image_index = 20;

slime7.gloop_color=global.YELLOW
slime7.gloop_name=global.strGloopYellow
slime7.image_index = 20;

slime8.gloop_color=global.WHITE
slime8.gloop_name=global.strGloopWhite
slime8.image_index = 20;
