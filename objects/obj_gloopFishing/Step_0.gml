
if (keyboard_check(ord("D")))
{
	xx+=acceleration
	if xx>maxX
		xx=maxX
}
if (keyboard_check(ord("A")))
{
	xx-=acceleration
	if xx<maxX*-1
		xx=maxX*-1
}
if (keyboard_check(ord("W")))
{
	yy-=acceleration
	if yy<maxY*-1
		yy=maxY*-1
}
if (keyboard_check(ord("S")))
{
	yy+=acceleration
	if yy>maxY
		yy=maxY
}

if x<0
	xx=abs(xx)
if y<0
	yy=abs(yy)
if x+sprite_width>room_width
	xx=abs(xx)*-1
if y+sprite_height>room_height
	yy=abs(yy)*-1

x+=xx
y+=yy



with obj_gloopFish
{
	var cx1 = bbox_left + (bbox_right - bbox_left) * 0.5;
	var cy1 = bbox_top  + (bbox_bottom - bbox_top) * 0.5;

	var cx2 = other.bbox_left + (other.bbox_right - other.bbox_left) * 0.5;
	var cy2 = other.bbox_top  + (other.bbox_bottom - other.bbox_top) * 0.5;

	gloop_distance = point_distance(cx1, cy1, cx2, cy2);
	
	if gloop_distance<100
	{
		if cx1<cx2
			derx-=0.01
		if cy1<cy2
			dery-=0.01
		if cx1>cx2
			derx+=0.01
		if cy1>cy2
			dery+=0.01
	}

}

