
var textAscii = " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRS";
var textAscii2 = "TUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
var textAscii3 = "Press T to return to the main menu!" 


draw_set_font(global.fnt_Gloop);
scr_draw_menu_item(20,20,textAscii,1)
scr_draw_menu_item(20,20+32+12,textAscii2,1)
scr_draw_menu_item(20,20+(32+12)*3,textAscii3,1)
select_reset_score=scr_draw_menu_item(20,20+(32+12)*4,"Reset high scores????",select_reset_score)

draw_rectangle(xx-32,yy,xx+(32*8),yy+1, false)
draw_rectangle(xx,yy-32,xx+1,yy+(32*8), false)

draw_rectangle(xx1-32,yy1,xx1+(32*8),yy1+1, false)
draw_rectangle(xx1,yy1-32,xx1+1,yy1+(32*8), false)

draw_rectangle(xx2-32,yy2,xx2+(32*8),yy2+1, false)
draw_rectangle(xx2,yy2-32,xx2+1,yy2+(32*8), false)