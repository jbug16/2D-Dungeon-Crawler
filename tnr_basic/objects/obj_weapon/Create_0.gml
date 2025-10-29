parent = undefined;
timer = 0;
image_speed = 0;

function SetPosition() {
	if is_undefined(parent) then exit;
	depth = parent.depth - 1;
	
	if parent.faceDirection == 0 then {
		x = parent.x + 16;
		y = parent.y + 05;
	}//end if
	
	if parent.faceDirection == 90 then {
		depth = parent.depth + 1;
		image_angle = 90;
		x = parent.x + 08;
		y = parent.y + 00;
	}//end if
	
	if parent.faceDirection == 180 then {
		image_xscale = -1;
		x = parent.x + 00;
		y = parent.y + 05;
	}//end if
	
	if parent.faceDirection == 270 then {
		image_angle = 270;
		x = parent.x + 08;
		y = parent.y + 11;
	}//end if
	
	timer += 1;
	if timer > 29 then parent.ChangeState(ST_STANDING);
	
	if parent.HasState(ST_ATTACKING) == false then {
		print(parent.StateString());
		instance_destroy();
	}//end if	
}//end function