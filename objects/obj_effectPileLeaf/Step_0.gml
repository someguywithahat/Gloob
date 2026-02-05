despawn_time++
if despawn_time>=despawn_timer
	image_alpha-=0.05
if image_alpha<0
	instance_destroy()

x+=xx
y+=yy
	
yy+=yyy
xx+=xxx

if y>=target_y
{
	yy=0
	yyy=0
}
if abs(xx)<=abs(xxx)
{
	xx=0
	xxx=0
}
