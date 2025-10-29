//@description Insert description here you can write your code in this editor
//draw_sprite(obj_universe.selected_planet_sprite, 0, 0, 0);
var selectedLocation = poiData[poiIndex];

var xOffset   = CAMERA_WIDTH div 2 - selectedLocation.x;
var yOffset   = CAMERA_HEIGHT div 2 - selectedLocation.y;
var mapWidth  = sprite_get_width(obj_universe.selected_planet_sprite);
var mapHeight = sprite_get_height(obj_universe.selected_planet_sprite);


xPosition += sign(xOffset - xPosition) * 2;
yPosition += sign(yOffset - yPosition) * 2;

for (var wrapIndexY = -1; wrapIndexY < 2; wrapIndexY += 1) {
	for (var wrapIndexX = -1; wrapIndexX < 2; wrapIndexX += 1) {
		var wrapOffsetX =  (mapWidth * wrapIndexX);
		var wrapOffsetY =  (mapWidth * wrapIndexY);
		
		draw_sprite(obj_universe.selected_planet_sprite, 0, wrapOffsetX + xPosition, wrapOffsetY + yPosition);

		for (var locationIndex = 0; locationIndex < array_length(poiData); locationIndex += 1) {
		    var currentLocation = poiData[locationIndex];
	 
			draw_sprite_ext(spr_pixel,0, wrapOffsetX + xPosition + currentLocation.x, wrapOffsetY + yPosition + currentLocation.y,1,1,0,c_fuchsia,1);

			//poiData.Add({locationName : random_name(6) , locationType : "Dungeon", x : tileX, y : tileY});		
		}//end for	
	
	}
}

//show ship Position
//var bracketFrame = current_time div 100 mod 4;
//draw_sprite_ext(spr_terminal_bracket, bracketFrame, obj_universe.shipPlanetPosX - 6, obj_universe.shipPlanetPosY - 4,  1,  1, 0, c_white, 1);
//draw_sprite_ext(spr_terminal_bracket, bracketFrame, obj_universe.shipPlanetPosX + 6, obj_universe.shipPlanetPosY - 4, -1,  1, 0, c_white, 1);
//draw_sprite_ext(spr_terminal_bracket, bracketFrame, obj_universe.shipPlanetPosX - 6, obj_universe.shipPlanetPosY + 4,  1, -1, 0, c_white, 1);
//draw_sprite_ext(spr_terminal_bracket, bracketFrame, obj_universe.shipPlanetPosX + 6, obj_universe.shipPlanetPosY + 4, -1, -1, 0, c_white, 1);

DrawBracket(xPosition + obj_universe.shipPlanetPosX, yPosition + obj_universe.shipPlanetPosY);		
		
//show POI


	DrawBracket(xPosition + selectedLocation.x, yPosition + selectedLocation.y);		

	//draw_text(0,0,selectedLocation.locationName);
	

	draw_sprite_ext(spr_pixel, 0, 0, 0, CAMERA_WIDTH, TILE_SIZE, 0, c_black, 1);
	draw_sprite_ext(spr_pixel, 0, 0, 0, 24, CAMERA_HEIGHT, 0, c_black, 1);

	
	draw_sprite_ext(spr_pixel, 0, CAMERA_WIDTH - 24, 0, 24, CAMERA_HEIGHT, 0, c_black, 1);
	draw_sprite_ext(spr_pixel, 0, 0, CAMERA_HEIGHT - 24, CAMERA_WIDTH, TILE_SIZE, 0, c_black, 1);
	
	
	draw_textbox(16, 08, CAMERA_WIDTH - 16,CAMERA_HEIGHT - 16, 1)

	
	draw_sprite(    spr_dash,0, CAMERA_WIDTH div 2, CAMERA_HEIGHT - 32);
	draw_sprite_ext(spr_dash,0, CAMERA_WIDTH div 2, CAMERA_HEIGHT - 32,-1,1,0,c_white,1);


	draw_set_halign(fa_center);
		draw_text(CAMERA_WIDTH div 2,CAMERA_HEIGHT - 10, selectedLocation.locationName);
	draw_set_halign(fa_left);
	
//draw_text(0,0,obj_universe.selected_planet_tile_data);
