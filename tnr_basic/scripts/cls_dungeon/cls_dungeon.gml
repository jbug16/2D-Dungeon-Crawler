enum Tile {
	Unused		  = 0,
	Floor		  = 1,
	CorridorFloor = 2,
	RoomWall	  = 4,
	CorridorWall  = 5,
	ClosedDoor	  = 6,
	OpenDoor	  = 7,
	UpStairs	  = 8,
	DownStairs	  = 9,
	HiddenDoor    = 10
};

enum Direction	{
	North,
	South,
	West,
	East,
	DirectionCount
};


function Dungeon2(width, height) constructor {	
	_width  = width;
	_height = height;
	_tiles  = ds_grid_create(width, height);
 	_rooms  = []; //rects
	_exits  = []; //rects
	_data    = [];	
	
	ds_grid_clear(_tiles, Tile.Unused);
	

	function Generate(maxFeatures) {
		//random_set_seed(4);
		random_set_seed(5);
		
		var roomIndex = 0;
		var roomData  = [];
		
	    //var currentRoom = MakeRoom(_width div 2, _height div 2, irandom_range(3,7), irandom_range(3,7));
	    var currentRoom = MakeRoom(_width div 2, _height div 2, Direction.South, 5, 5);
		array_push(roomData,currentRoom);
		
		repeat maxFeatures {
			print(currentRoom.exits);
			while array_length(currentRoom.exits) > 0 {
				var roomExit = currentRoom.PopExit();	
				var subRoom  = undefined;
				
				var featureX       = roomExit.position.x + roomExit.xOffset;
				var featureY       = roomExit.position.y + roomExit.yOffset;
				var featureWidth   = choose(4,5,6,8,7,9,10);
				var featureHeight  = choose(4,5,6,8,7,9,10);
				var subFeatureData = undefined;
				
				if choose(true, false) then {
					subFeatureData = MakeRoom(featureX, featureY, roomExit.facing, featureWidth, featureHeight);
					if is_undefined(subFeatureData) then {
						continue;
					}//end if
				}else{
					subFeatureData = MakeCorridor(featureX, featureY, featureWidth, roomExit.facing);
					if is_undefined(subFeatureData) then {
						continue;
					}//end if
					
					var turnNorth      = choose(Direction.East,Direction.West);
					var turnSouth      = choose(Direction.East,Direction.West);
					var turnWest       = choose(Direction.North,Direction.South);
					var turnEast       = choose(Direction.North,Direction.South);
					var turnDirections = [turnNorth,turnSouth,turnWest,turnEast];
					var turnDirection  = turnDirections[roomExit.facing];	
					var turn           = choose(true, false, false);	
					
					if turn then {
						array_push(roomData,subFeatureData);
						roomExit = subFeatureData.PopExit();
						
						featureX       = roomExit.position.x + roomExit.xOffset;
						featureY       = roomExit.position.y + roomExit.yOffset;
						featureWidth   = choose(4,5,6,8,7,9,10);						
						turnOffsetX    = 0;
						turnOffsetY    = 0;
						
						//TEST MARKER
							var temp = _tiles[# featureX,featureY];
							ds_grid_set(_tiles,featureX,featureY,"X");
							Print("Generation " + string(roomIndex));						
							ds_grid_set(_tiles,featureX,featureY,temp);
						
						if roomExit.facing == Direction.East then {
							if turnDirection == Direction.South {
								turnOffsetX =  1;
								turnOffsetY = -1;
							}//end if
										
							if turnDirection == Direction.North {
								turnOffsetX =  1;
								turnOffsetY = +1;
							}//end if						
						}//end if

						if roomExit.facing == Direction.West then {
							turnOffsetX = -3;
							turnOffsetY = -1;							
						}//end if
						
						if roomExit.facing == Direction.North then {
							turnOffsetX =  1;
							turnOffsetY = -1;							
						}//end if

						if roomExit.facing == Direction.South then {
							if turnDirection == Direction.East then {
								turnOffsetX = -1;
								turnOffsetY = 1;
							}//end if
							
							if turnDirection == Direction.West then {
								turnOffsetX = 1;
								turnOffsetY = 1;
							}//end if
						}//end if

						subFeatureData = MakeCorridor(featureX + turnOffsetX, featureY + turnOffsetY, featureWidth, turnDirection, true, roomExit.facing);
					
						Print("Generation " + string(roomIndex));								
					
						if is_undefined(subFeatureData) then {
							continue;
						}//end if					
					}
				}//end if
				
				array_push(roomData,subFeatureData);				
			}//end while
			
			//Print("Generation " + string(roomIndex));
			
			roomIndex   += 1;
			
			if roomIndex >= array_length(roomData) {
				continue;	
			}//end if
			
			currentRoom  = roomData[roomIndex];
		}//end repeat
		
		print("done");
		
	}//end function


	function Print(title = "") {
		var str = "";
		print("**********************************" + title + "********************************************")
		for (var yp = 0; yp < _height; ++yp) {
			for (var xp = 0; xp < _width; ++xp) {
				var tileValue = string(_tiles[# xp, yp]);
				
				if tileValue == "0" then {
					str += " ";
				}else{
					str += string(_tiles[# xp, yp]);					
				}//end if
            }//end for
			str += "\n";
		}//end for
		
		print(str);
		print("******************************************************************************\n\n")		
	}//end function


	function MakeRoom(x, y, dir, width, height, anyExit = false)	{
		//BUILD RECT
			var newRoom         = new Room();
			var exitDirections = [];
			
			if dir == Direction.South then {
				newRoom.rect.x      = x - width div 2;
				newRoom.rect.y      = y;
				newRoom.rect.width  = width;
				newRoom.rect.height = height;
				newRoom.rect.CalculateEndpoints();
				exitDirections = [Direction.South, Direction.East, Direction.West];
			}else if dir == Direction.North then {
				newRoom.rect.x      = x - width div 2;
				newRoom.rect.y      = y - height + 1;
				newRoom.rect.width  = width;
				newRoom.rect.height = height;
				newRoom.rect.CalculateEndpoints();
				exitDirections = [Direction.North, Direction.East, Direction.West];
			}else if dir == Direction.East then {
				newRoom.rect.x      = x;
				newRoom.rect.y      = y - height div 2;
				newRoom.rect.width  = width;
				newRoom.rect.height = height;
				newRoom.rect.CalculateEndpoints();
				exitDirections = [Direction.East, Direction.South, Direction.North];				
			}else if dir == Direction.West then {
				newRoom.rect.x      = x - width + 1 ;
				newRoom.rect.y      = y - height div 2;
				newRoom.rect.width  = width;
				newRoom.rect.height = height;
				newRoom.rect.CalculateEndpoints();
				exitDirections = [Direction.West, Direction.South, Direction.North];					
			}//end if
			
		//TEST LOCATION
			var tileSum   = ds_grid_get_sum(_tiles,newRoom.rect.x1,newRoom.rect.y1,newRoom.rect.x2,newRoom.rect.y2); 
			var available = tileSum == 0;			
			var inBounds = newRoom.rect.x1 > 0 and newRoom.rect.y1 > 0 and newRoom.rect.x2 < _width - 1 and newRoom.rect.y2 < _height - 1;
			
			if not available or not inBounds then {
				return undefined;	
			}//end if
			
		//BUILD WALLS
			ds_grid_set_region(_tiles,newRoom.rect.x1,newRoom.rect.y1,newRoom.rect.x2,newRoom.rect.y2,Tile.RoomWall);
		
		//BUILD FLOOR
			ds_grid_set_region(_tiles,newRoom.rect.x1 + 1,newRoom.rect.y1 + 1,newRoom.rect.x2 - 1,newRoom.rect.y2 - 1,Tile.Floor);
		
			if anyExit then exitDirections = [Direction.North ,Direction.South, Direction.East, Direction.West];
		//BUILD EXITS
			var exitCount = min(choose(0,1,1,1,1,2,2,2,3,3,4), array_length(exitDirections));
			var exitDirectionArray = array_shuffle(exitDirections);
			
			repeat exitCount {
				newRoom.CarveExit(array_pop(exitDirectionArray));
			}//end repeat
			
			for (var exitIndex = 0; exitIndex < array_length(newRoom.exits); exitIndex += 1){
				var currentExit = newRoom.exits[exitIndex];
				ds_grid_set(_tiles,currentExit.position.x,currentExit.position.y, Tile.CorridorFloor);
				
				if currentExit.facing == Direction.North  then {
					ds_grid_set(_tiles,currentExit.position.x - 0,currentExit.position.y + 1, choose(Tile.OpenDoor, Tile.ClosedDoor));	
					ds_grid_set(_tiles,currentExit.position.x - 1,currentExit.position.y,     Tile.CorridorWall);	
					ds_grid_set(_tiles,currentExit.position.x + 1,currentExit.position.y,     Tile.CorridorWall);	
				}//end if
				
				if currentExit.facing == Direction.South then {
					ds_grid_set(_tiles,currentExit.position.x - 0,currentExit.position.y - 1, choose(Tile.OpenDoor, Tile.ClosedDoor));	
					ds_grid_set(_tiles,currentExit.position.x - 1,currentExit.position.y,     Tile.CorridorWall);	
					ds_grid_set(_tiles,currentExit.position.x + 1,currentExit.position.y,     Tile.CorridorWall);	
				}//end if
				
				if currentExit.facing == Direction.East then {
					ds_grid_set(_tiles,currentExit.position.x - 1,currentExit.position.y, choose(Tile.OpenDoor, Tile.ClosedDoor));	
					ds_grid_set(_tiles,currentExit.position.x,currentExit.position.y + 1, Tile.CorridorWall);	
					ds_grid_set(_tiles,currentExit.position.x,currentExit.position.y - 1, Tile.CorridorWall);	
				}//end if
				
				if currentExit.facing == Direction.West then {
					ds_grid_set(_tiles,currentExit.position.x + 1,currentExit.position.y, choose(Tile.OpenDoor, Tile.ClosedDoor));	
					ds_grid_set(_tiles,currentExit.position.x,currentExit.position.y + 1, Tile.CorridorWall);	
					ds_grid_set(_tiles,currentExit.position.x,currentExit.position.y - 1, Tile.CorridorWall);	
				}//end if
				
				
			}//end for
			
			ds_grid_set(_tiles,x , y, Tile.CorridorFloor);
			
			//ds_grid_set(_tiles,x , y, "#");	
			
		
		//ADD TO ROOMS ARRAY
			array_push(_rooms, newRoom);

			return newRoom;
	}//end function


	function MakeCorridor(x, y, length, dir, turnRoom = false, turnExitDir = -1) {
		//BUILD RECT
			var newCorridor     = new Room();
			
			if dir == Direction.East then {
				newCorridor.rect.x      = x;
				newCorridor.rect.y      = y - 1;
				newCorridor.rect.width  = length;
				newCorridor.rect.height = 3;
				
				var doorID        = new Door();
				doorID.facing     = dir;
				doorID.position   = new Point(x + length - 1,y); 
				doorID.xOffset    = 1;
				doorID.yOffset    = 0;
				newCorridor.exits = [doorID];
				
				newCorridor.rect.CalculateEndpoints();
			}else if dir == Direction.West then {
				newCorridor.rect.x      = x - length + 1;
				newCorridor.rect.y      = y - 1;
				newCorridor.rect.width  = length;
				newCorridor.rect.height = 3;
				
				var doorID = new Door();
				doorID.facing = dir;
				doorID.position = new Point(x - length + 1,y); 
				doorID.xOffset  = 1;
				doorID.yOffset  = 0;				
				newCorridor.exits = [doorID];
				
				newCorridor.rect.CalculateEndpoints();
			}else if dir == Direction.South then {
				newCorridor.rect.x      = x - 1;
				newCorridor.rect.y      = y ;
				newCorridor.rect.width  = 3;
				newCorridor.rect.height = length;
				
				var doorID = new Door();
				doorID.facing = dir;
				doorID.position = new Point(x,y + length - 1); 
				doorID.xOffset  = 0;
				doorID.yOffset  = 1;
				newCorridor.exits = [doorID];	
				
				newCorridor.rect.CalculateEndpoints();	
			}else if dir == Direction.North then {
				newCorridor.rect.x      = x - 1;
				newCorridor.rect.y      = y - length + 1;
				newCorridor.rect.width  = 3;
				newCorridor.rect.height = length;
				
				var doorID = new Door();
				doorID.facing = dir;
				doorID.position = new Point(x,y - length + 1); 
				doorID.xOffset  = 0;
				doorID.yOffset  = -1;				
				newCorridor.exits = [doorID];	
				
				newCorridor.rect.CalculateEndpoints();					
			}//end if	
			
			
			//END POINTS
				var x1 = newCorridor.rect.x1;
				var y1 = newCorridor.rect.y1;
				var x2 = newCorridor.rect.x2;
				var y2 = newCorridor.rect.y2;
				
			//TEST LOCATION
				var tileSum   = ds_grid_get_sum(_tiles,x1,y1,x2,y2); 
				var available = tileSum == 0;
				var inBounds  = x1 > 0 and y1 > 0 and x2 < _width - 1 and y2 < _height - 1;
			
				if not available or not inBounds then {				
					return undefined;	
				}//end if
			
			//WALLS			
				ds_grid_set_region(_tiles,x1,y1,x2,y2,Tile.CorridorWall);

				if dir == Direction.North then {
					ds_grid_set_region(_tiles,x1+1,y1,x1+1,y2,Tile.CorridorFloor);
					
					if turnRoom then {
						if turnExitDir == Direction.East then {
							ds_grid_set(_tiles, x1 + 1, y1 + length - 1 , Tile.CorridorWall);							
							ds_grid_set(_tiles, x1, y1 + length - 2,  Tile.CorridorFloor);
						}//end if
						
						if turnExitDir == Direction.West then {
							ds_grid_set(_tiles, x1 + 1, y1, Tile.CorridorWall);
							ds_grid_set(_tiles, x1 + 2, y1 + 1, Tile.CorridorFloor);
						}//end if
					}//end if				
				
				}else if dir == Direction.South then {
					ds_grid_set_region(_tiles,x1+1,y1,x1+1,y2-1,Tile.CorridorFloor);
					
					if turnRoom then {
						if turnExitDir == Direction.East then {
							ds_grid_set(_tiles, x1 + 1, y1, Tile.CorridorWall);
							ds_grid_set(_tiles, x1, y1 + 1, Tile.CorridorFloor);
						}//end if
						
						if turnExitDir == Direction.West then {
							ds_grid_set(_tiles, x1 + 1, y1, Tile.CorridorWall);
							ds_grid_set(_tiles, x1 + 2, y1 + 1, Tile.CorridorFloor);
						}//end if
					}//end if
				
				}else if dir == Direction.East  then {
					ds_grid_set_region(_tiles,x1,y1+1,x2-1,y1+1,Tile.CorridorFloor);
				
					if turnRoom then {
						if turnExitDir == Direction.North then {
							ds_grid_set(_tiles, x1 + 1, y1, Tile.CorridorWall);
							ds_grid_set(_tiles, x1, y1 + 1, Tile.CorridorFloor);
						}//end if
						
						if turnExitDir == Direction.South then {
							ds_grid_set(_tiles, x1 + 1, y1, Tile.CorridorFloor);
							ds_grid_set(_tiles, x1    , y1 + 1, Tile.CorridorWall);
						}//end if
					}//end if					
				}else if dir == Direction.West  then {
					
					ds_grid_set_region(_tiles,x1,y1+1,x2,y1+1,Tile.CorridorFloor);					
					
					if turnRoom then {
						if turnExitDir == Direction.North then {
							ds_grid_set(_tiles, x1 + length - 1, y1 + 1, Tile.CorridorWall);
							ds_grid_set(_tiles, x1 + length - 2, y1 + 2, Tile.CorridorFloor);
						}//end if
						
						if turnExitDir == Direction.South then {
							ds_grid_set(_tiles, x1 + length - 1, y1 + 1, Tile.CorridorWall);
							ds_grid_set(_tiles, x1 + length - 2, y1 , Tile.CorridorFloor);
						}//end if
					}//end if		
					
				}//end if
				
			
			//EXIT OPEN DOOR
				ds_grid_set(_tiles,newCorridor.exits[0].position.x,newCorridor.exits[0].position.y,Tile.OpenDoor);			
			
			//
				array_push(_rooms, newCorridor);

			return newCorridor;
	}//end function


	function GetData() {	
		var height =  ds_grid_height(_tiles);
		var width  =  ds_grid_width(_tiles);
		
		_data[height][width] = undefined;
		
		for (var row = 0; row < height; row += 1) {
			for (var col = 0; col < width; col += 1) {
				_data[row,col] = _tiles[# row,col];
				
			}//end for
		}//end for
		
		ds_grid_destroy(_tiles);

		return _data;
	}//end function

};






