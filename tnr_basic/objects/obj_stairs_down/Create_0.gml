event_inherited();

function Interacted(){
    obj_camera.FadeOut(20, c_black);
    
    obj_stats.lastRoom = room;
    obj_stats.lastX = obj_player.x;
    obj_stats.lastY = obj_player.y;
    
    room_goto(room_level_1);
	
	print("going to level 1");
}//end if