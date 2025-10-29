function vec2 (_x, _y) constructor {	
	x = _x;
	y = _y;
	
	static Add = function (other_vec2) {
		x += other_vec2.x;
		y += other_vec2.y;
	};
		
	static Add = function (x_amount, y_amount) {
		x += x_amount;
		y += y_amount;
	};		
	
	static toString = function () {
		return "(" + string(x) + ", " +	string(y) + ")\n";
	};
}//end struct