// Inherit the parent event
event_inherited();

function Interacted(){
    obj_stats.lastRoom = room;
    obj_stats.lastX = obj_player.x;
    obj_stats.lastY = obj_player.y;
    
	// Go to next level
	if (global.current_level <= 0) {
		print("ERROR: Invalid level. You are already on the first level.");
	}
	else room_goto(global.levels[--global.current_level]);
}//end if