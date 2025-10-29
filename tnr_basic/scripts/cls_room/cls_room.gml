function Room() constructor {
	rect  = new Rect()	
	exits = [];
	
	function CarveExit(dir) {
		rect.CalculateEndpoints();
		var exitPoint = new Door();
		
		if dir == Direction.North then {
			exitPoint.position.x = irandom_range(rect.x1 + 1,rect.x2 - 1);
			exitPoint.position.y = rect.y1 - 1;
			exitPoint.yOffset = -1;
		}//end if
		
		if dir == Direction.South then {
			exitPoint.position.x = irandom_range(rect.x1 + 1,rect.x2 - 1);
			exitPoint.position.y = rect.y2 + 1;
			exitPoint.yOffset = 1;
		}//end if
		
		if dir == Direction.East then {
			exitPoint.position.x = rect.x2 + 1;
			exitPoint.position.y = irandom_range(rect.y1 + 1,rect.y2 - 1);
			exitPoint.xOffset = 1;
		}//end if
		
		if dir == Direction.West then {
			exitPoint.position.x = rect.x1 - 1;
			exitPoint.position.y = irandom_range(rect.y1 + 1,rect.y2 - 1);
			exitPoint.xOffset = -1;
		}//end if
		
		exitPoint.facing = dir;
		
		array_push(exits,exitPoint);
	}//end function

	function GetRandomExit() {
		return exits[irandom(array_length(exits) - 1)];
	}//end function
	
	function PopExit() {
		return array_pop(exits);
	}//end function	
	
}//end class


function Door() constructor {
	position = new Point();
	facing   = undefined;
	xOffset  = 0;
	yOffset  = 0;
}//end class


function CorridorFloor() constructor {
	rect  = new Rect()	
	exits = [];
	
	function CarveExit(dir) {
		rect.CalculateEndpoints();
		var exitPoint = new Door();
		
		if dir == Direction.North then {
			exitPoint.position.x = irandom_range(rect.x1 + 1,rect.x2 - 1);
			exitPoint.position.y = rect.y1;
			exitPoint.yOffset = -2;
		}//end if
		
		if dir == Direction.South then {
			exitPoint.position.x = irandom_range(rect.x1 + 1,rect.x2 - 1);
			exitPoint.position.y = rect.y2;
			exitPoint.yOffset = 2;
		}//end if
		
		if dir == Direction.East then {
			exitPoint.position.x = rect.x2;
			exitPoint.position.y = irandom_range(rect.y1 + 1,rect.y2 - 1);
			exitPoint.xOffset = 2;
		}//end if
		
		if dir == Direction.West then {
			exitPoint.position.x = rect.x1;
			exitPoint.position.y = irandom_range(rect.y1 + 1,rect.y2 - 1);
			exitPoint.xOffset = -2;
		}//end if
		
		exitPoint.facing = dir;
		
		array_push(exits,exitPoint);
	}//end function
}//end class