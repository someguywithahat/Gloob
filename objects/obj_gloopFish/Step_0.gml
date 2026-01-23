
stepCounter++
x+=derx
y+=dery



if stepCounter>50 and random_range(1,200)=1
{
	derx=random_range(1,-1)
	dery=random_range(0.2,-0.2)	
}

if x<-40 or y<-40 or x>room_width+40 or y>room_height+40
{
	if x>room_width+40 x=-40
	if y>room_height+40 y=-40
	if x<-40 x=room_width+40
	if y<-40 x=room_height+40
	
	derx=random_range(1,-1)
	dery=random_range(0.2,-0.2)		
	
}

if derx>maxSpeed
	derx=maxSpeed
if dery>maxSpeed
	dery=maxSpeed
if derx<maxSpeed*-1
	derx=maxSpeed*-1
if dery<maxSpeed*-1
	dery=maxSpeed*-1


