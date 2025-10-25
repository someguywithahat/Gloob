
var textAscii = " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRS";
var textAscii2 = "TUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
var textAscii3 = "Press T to return to the main menu!" 


draw_set_font(global.fnt_Gloop);
scr_draw_menu_item(20,20,textAscii,1)
scr_draw_menu_item(20,20+32+12,textAscii2,1)
scr_draw_menu_item(20,20+(32+12)*3,textAscii3,1)
