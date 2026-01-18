if locked=1{
	x=mouse_x
	y=mouse_y
}
	
if !mouse_check_button(mb_left)
{
	locked=0
	global.mouseDrag=0
}


if (mouse_check_button_pressed(mb_left)) and global.mouseDrag=0 {
    if (position_meeting(mouse_x, mouse_y, id)) {
        locked=1
		global.mouseDrag=1
    }
}


if (mouse_check_button_pressed(mb_right)) and locked=1 {

    flip=flip*-1

}

if (mouse_check_button_pressed(mb_middle)) and locked=1 {

    depth=depth-1
	if depth<-10
		depth=2

}
