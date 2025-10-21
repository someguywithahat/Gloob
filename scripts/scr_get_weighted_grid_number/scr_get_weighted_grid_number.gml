function scr_get_weighted_grid_number(){
	//Jo, you can update these 9 number to change the weights of a number on the grid.  
	var w1 = 10
	var w2 = 10
	var w3 = 10
	var w4 = 10
	var w5 = 10
	var w6 = 10
	var w7 = 10
	var w8 = 10
	var w9 = 10
	
	var wArray = array_create(9,1)
	wArray[0] = w1
	wArray[1] = w2
	wArray[2] = w3
	wArray[3] = w4
	wArray[4] = w5
	wArray[5] = w6
	wArray[6] = w7
	wArray[7] = w8
	wArray[8] = w9
	
	var wTotal = w1+w2+w3+w4+w5+w6+w7+w8+w9
	var wRandom = irandom_range(1, wTotal);
	
	
	var wCounter =0	
	for (var j = 0; j < 9; j++){
		wCounter+=wArray[j]
		if wRandom<=wCounter
			return j+1			
	}
	return 1
	
		
		
}