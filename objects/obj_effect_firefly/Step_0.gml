despawn_timer++
if despawn_timer>despawn_time
	instance_destroy()
	
x+=xx
y+=yy
yy+=yyy

if yy>2
	yyy=abs(yyy)*-1
if yy<-2
	yyy=abs(yyy)