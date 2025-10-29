var planetTiles = obj_universe.selected_planet_tile_data;
random_set_seed(obj_universe.planet_seed);

poiData = [];

for (var tileY = 0; tileY < planetTiles.height ; tileY += 1) {
	for (var tileX = 0; tileX < planetTiles.width ; tileX += 1) {
	    var currentTileData = planetTiles.data[tileX,tileY];

		if currentTileData == TILE.DUNGEON then {
			array_push(poiData, {locationName : ICO_DUNGEON + random_name(irandom_range(4,8)) , locationType : "Dungeon", x : tileX, y : tileY});		
		}//end if
		
		if currentTileData == TILE.TOWN then {
			array_push(poiData, {locationName : ICO_TOWN + random_name(irandom_range(4,8)) , locationType : "Town", x : tileX, y : tileY});		
		}//end if
		
	}//end for
}//end for

poiIndex = 0;

function DrawBracket(_x, _y) {
	var bracketFrame = current_time div 100 mod 4;
	draw_sprite_ext(spr_terminal_bracket, bracketFrame, _x - 6, _y - 4,  1,  1, 0, c_white, 1);
	draw_sprite_ext(spr_terminal_bracket, bracketFrame, _x + 6, _y - 4, -1,  1, 0, c_white, 1);
	draw_sprite_ext(spr_terminal_bracket, bracketFrame, _x - 6, _y + 4,  1, -1, 0, c_white, 1);
	draw_sprite_ext(spr_terminal_bracket, bracketFrame, _x + 6, _y + 4, -1, -1, 0, c_white, 1);			
}


xPosition = 0;
yPosition = 0;


