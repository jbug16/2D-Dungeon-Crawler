function Rect() constructor {
	x      = 0;
	y      = 0;
	width  = 0;
	height = 0;	
	
	x1      = 0;
	y1      = 0;
	x2      = 0;
	y2      = 0;
	
	function CalculateEndpoints(){
		x1 = x;
		y1 = y;
		x2 = x1 + width - 1;
		y2 = y1 + height - 1;
	}//end function
	
}//end class ?