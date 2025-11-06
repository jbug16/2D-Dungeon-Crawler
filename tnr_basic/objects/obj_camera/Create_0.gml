fadeQueue = new Queue();
fadeAlpha = 0;
fading = false;
fadeData = undefined

target = obj_player;
locked = false;
xOffset = 0;
yOffset = 0;
stayInBounds = true;
defogRoomArea = undefined;
defogTimer = 0;




#macro CAMERA_WIDTH  192
#macro CAMERA_HEIGHT 128
#macro CAMERA_FADE_MODE_OUT 0
#macro CAMERA_FADE_MODE_IN 1

function UpdateCamera() {
	if instance_exists(target) == false then exit;
	
	if locked == false then {
		x = target.x - CAMERA_WIDTH  div 2 + xOffset;
		y = target.y - CAMERA_HEIGHT div 2 + yOffset;
		
		if stayInBounds then {
			x = clamp(x,0,room_width - CAMERA_WIDTH);
			y = clamp(y,0,room_height - CAMERA_HEIGHT);		
		}
	}//end if
		
	camera_set_view_pos(view_camera[0], x, y);
}//end function



function FadeOut(steps, col){
	steps = 1/steps;
	fadeQueue.Enqueue({mode : CAMERA_FADE_MODE_OUT , spd : steps, color : col});	
}//end function

function FadeIn(steps, col){
	steps = 1/steps;	
	fadeQueue.Enqueue({mode : CAMERA_FADE_MODE_IN , spd : -steps,  color : col});	
}//end function

function RunFadeQueue() {
	
	if fading == false then {
		
		if not fadeQueue.IsEmpty() then {
			fading = true;
			fadeData = fadeQueue.Dequeue();		
			fadeAlpha = fadeData.mode;
			image_blend = fadeData.color;
		}//end if
		
	}else{
		fadeAlpha += fadeData.spd;
		
		if fadeData.mode == CAMERA_FADE_MODE_OUT and fadeAlpha >= 1 then{
			fading = false;
		}//end if
		
		if fadeData.mode == CAMERA_FADE_MODE_IN and fadeAlpha <= 0 then{
			fading = false;
		}//end if
	}//end if
}//end function

FadeIn(20,c_black);


function Defog(xStart, yStart){
	print("processing tile " + string([xStart,yStart]));
	var overFloor = collision_tile_index(xStart,yStart) == TILE_TYPE.FLOOR;
	var visited = tilemap_get_at_pixel(obj_stats.fog_tilemap,xStart,yStart) == 0;
	 
    if not overFloor then {
		print(string([xStart,yStart]) + " not over floor");
		return;
	}
	
    if visited then {
		print(string([xStart,yStart]) + " already visited");
		return;
	}	
	 
	tilemap_set_at_pixel(obj_stats.fog_tilemap, 0, xStart, yStart)// Set the node
	
	Defog(xStart + 00, yStart + 08); //to the south of node.
	Defog(xStart + 00, yStart - 08); //to the north of node
	Defog(xStart - 08, yStart + 00); //to the west of node
	Defog(xStart + 08, yStart + 00); //to the east of node
	 
	return true;  
}



function DefogArea(xStart, yStart, xEnd, yEnd) {
	var done = true;
	
	for (var tx = xStart; tx <= xEnd; tx += 8) {
	    for (var ty = yStart; ty <= yEnd; ty += 8)  {
		    var index = tilemap_get_at_pixel(obj_stats.fog_tilemap,tx,ty);
			if index > 0 then {
				done = false;
				tilemap_set_at_pixel(obj_stats.fog_tilemap, index - 1, tx,ty);
			}//end if
		}//end for
	}//end for
	
	return done;
}//end function

function DefogAreaInstant(xStart, yStart, xEnd, yEnd) {
	for (var tx = xStart; tx <= xEnd; tx += 8) {
	    for (var ty = yStart; ty <= yEnd; ty += 8)  {
		    tilemap_set_at_pixel(obj_stats.fog_tilemap, 0, tx, ty);
		}//end for
	}//end for
}//end function

function FindCollisionTilePositionsByType(tilemap, tileIndex){
	var tilePositions = []
	for (var ty = 0; ty <= room_height; ty += 16) {
		for (var tx = 0; tx <= room_width; tx += 16)  {
			var index = tilemap_get_at_pixel(tilemap, tx, ty);
				
			if index == tileIndex then {
				array_push(tilePositions, {x:tx,y:ty});
			}//end if
		}//end for
	}//end for	
	
	return tilePositions;
}//end function

function DefogRoom(xStart, yStart, ignoreFloor = false){
	
		var xlist = ds_list_create();
		var ylist = ds_list_create();
		var overFloor = collision_tile_index(xStart,yStart) == 4; 	
		var visited = tilemap_get_at_pixel(obj_stats.fog_tilemap,xStart,yStart) == 0;	 
		var Q = new Queue();
		var V = new List();
		
		function Visited(cn, visitedList) {
			for (var i = 0; i < visitedList.count; ++i) {
			    var tn = visitedList.Get(i);
				if cn.tx == tn.tx and cn.ty == tn.ty then return true;
			}
			return false;
		}
	
		Q.Enqueue({tx : xStart , ty : yStart});
  
		while Q.count > 0 {	
			var n = Q.Dequeue();				
			var overFloor = collision_tile_index(n.tx,n.ty) == 4 or ignoreFloor == true;
			var visitIndex = tilemap_get_at_pixel(obj_stats.fog_tilemap,n.tx,n.ty);
			var visited = Visited(n, V);
  
			if overFloor and not visited {
				V.Add({tx : n.tx, ty : n.ty});
				ds_list_add(xlist,n.tx);
				ds_list_add(ylist,n.ty);
				//alreadyDefogged = false;
			    //print("--adding neighbors to queue");			
				if visitIndex != 0 then {
					tilemap_set_at_pixel(obj_stats.fog_tilemap, 5, n.tx,n.ty);
				}//end if
				
				Q.Enqueue({ tx : n.tx + 00, ty : n.ty + 16}); //to the south of node.
				Q.Enqueue({ tx : n.tx + 00, ty : n.ty - 16}); //to the north of node
				Q.Enqueue({ tx : n.tx - 16, ty : n.ty + 00}); //to the west of node
				Q.Enqueue({ tx : n.tx + 16, ty : n.ty + 00}); //to the east of node	
			}
		}
	
		ds_list_sort(xlist, true);
		ds_list_sort(ylist, true);
		//if not alreadyDefogged then {
			defogRoomArea = {x0 : xlist[| 0], y0 : ylist[| 0], x1 : xlist[| ds_list_size(xlist) - 1], y1 : ylist[| ds_list_size(ylist) - 1]};
		//}//end if
		ds_list_destroy(xlist)
		ds_list_destroy(ylist)
		
		return true;     
}



function DefogAroundMe(xStart, yStart){
	defogRoomArea = {x0 :xStart - 8 , y0 : yStart , x1 : xStart + 8, y1 : yStart };		
	return true;     
}



function UncoverRoom(){
	if is_undefined(defogRoomArea) then return;
	
	if (is_undefined(defogRoomArea.x0) || 
	    is_undefined(defogRoomArea.y0) || 
	    is_undefined(defogRoomArea.x1) || 
	    is_undefined(defogRoomArea.y1)) {
		defogRoomArea = undefined;
		return;
	}
	
	defogTimer += 1;
	
	
	if defogTimer mod 3 == 0 then {
		var done = DefogArea(defogRoomArea.x0 - 8, defogRoomArea.y0 - 24, defogRoomArea.x1 + 16, defogRoomArea.y1  + 16);
		if done then defogRoomArea = undefined;
		defogTimer = 0;
	}//end if

}//end function


