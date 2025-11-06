event_inherited();

function Interacted(){
    obj_stats.lastRoom = room;
    obj_stats.lastX = obj_player.x;
    obj_stats.lastY = obj_player.y;
    
	// Go to next level
	if (global.current_level+1 == array_length(global.levels)) {
		print("ERROR: Invalid level. You are already on the final level.");
	}
	else room_goto(global.levels[++global.current_level]);
}//end if