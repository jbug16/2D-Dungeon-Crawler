#macro ACTOR_CLASS_PLAYER  1
#macro ACTOR_CLASS_MONSTER 2

#macro ACTOR_TYPE_NULL	  0x00
#macro ACTOR_TYPE_WERE	  0x01
#macro ACTOR_TYPE_GIANT   0x02
#macro ACTOR_TYPE_INSECT  0x04
#macro ACTOR_TYPE_HUMAN   0x08
#macro ACTOR_TYPE_FLYING  0x10
#macro ACTOR_TYPE_UNDEAD  0x20
#macro ACTOR_TYPE_MACHINE 0x40
#macro ACTOR_TYPE_DEMON   0x80
#macro ACTOR_TYPE_BOSS    0x100
#macro ACTOR_TYPE_AQUATIC 0x200
#macro ACTOR_TYPE_DRAGON  0x400
#macro ACTOR_TYPE_MAGICAL 0x800
#macro ACTOR_TYPE_BEAST   0x1000
#macro ACTOR_TYPE_REPTILE 0x2000
#macro ACTOR_TYPE_PLANT   0x4000

stats = new Stats();

image_speed = .05;


state         = ST_WAITING;
destX         = x;
destY         = y;
tileX         = x div TILE_SIZE;
tileY         = y div TILE_SIZE;
faceDirection = 0;
currentTile   = TILE_TYPE.FLOOR;
xOffset       = 0;
yOffset       = -4;
attackType    = ATTACK_TYPE_MELEE;
hurtTimer     = 0;
attackTimer   = 0;

animations = {
	walk : [],
	stand : [],
	attack : [],
	hurt : [],
	current : undefined
}//end struct

currentAnimation = [];

function StatsUpdate(){
	if stats.hp <= 0 then {
		if stats.class = ACTOR_CLASS_PLAYER then {
			stats.status = STATUS_KO;
		}//end if
	
		if stats.class = ACTOR_CLASS_MONSTER then {
			instance_destroy(id);	
		}//end if
	}//end if	
}//end function

function LineOfSight(x1, y1, x2, y2) {
	var tx1       = snap(x1, TILE_SIZE) div TILE_SIZE; 
	var ty1       = snap(y1, TILE_SIZE) div TILE_SIZE; 
	var tx2       = snap(x2, TILE_SIZE) div TILE_SIZE; 
	var ty2       = snap(y2, TILE_SIZE) div TILE_SIZE; 
	var checkX    = 0;
	var checkY    = 0;
	var dx        = tx2 - tx1
	var dy        = ty2 - ty1;
	var tileIndex = 0;
    var step = 0;
    var i = 1;
	var door = false;
	var scanX = 0;
	var scanY 	= 0;
	if (abs(dx) >= abs(dy)) {
		step = abs(dx);
	}else{
		step = abs(dy);
	}//end if
 
	dx = dx / step;
	dy = dy / step;
	checkX = tx1;
	checkY = ty1;
	
	while (i <= step) {
		scanX = checkX * TILE_SIZE + 8;
		scanY = checkY * TILE_SIZE + 8;
		tileIndex = collision_tile_index(scanX, scanY);
		door  = collision_point(scanX,scanY,obj_door,false,true) > 0
		if tileIndex == 1 or door then return false;
		checkX += dx;
		checkY += dy;
		i += 1;
	}//end while

	return true;
	
}//end function

function ChangeState(newState) {
	if state != newState then {
		print(object_get_name(id.object_index) + " changes to " + StateString())
	}//end if
	
	state = newState;
}//end function

function AddState(newState) {
	state = state | newState;
}//end function

function HasState(checkState) {
	return (state & checkState) > 0;
}//end function

function RemoveState(oldState) {
	state = state & ~oldState;
}//end function

function MoveTowardDestination() {
	if HasState(ST_ATTACKING | ST_HURT | ST_MAGIC_SHOT) then exit;
	x += sign(destX - x);	
	y += sign(destY - y);	
}//end function
	
function CheckForCollision() {
	//player
	tilCollide = collision_tile(destX + 8, destY + 8) == 1;
	objCollide = CheckForObject(mas_actor) > 0;
	itmCollide = CheckForObject(mas_object) ;
			
	if itmCollide > 0 then {
		itmCollide = itmCollide.blocking;
	}//end if
	
	return  tilCollide or objCollide or itmCollide;
}//end function

function MoveTo(xPos, yPos){
	x = xPos;
	y = yPos;
	destX = x;
	destY = y;
}


function PlayerMovement() {
	if x == destX and y == destY then {
		if HasState(ST_ATTACKING | ST_HURT | ST_MAGIC_SHOT) then exit;
		
		var warpObjId =  CheckForObjectAt(obj_warp,x + 8, y + 8);
		
		if warpObjId > 0 then {
					
				obj_stats.lastRoom = room;
				obj_stats.lastX = warpObjId.x;
				obj_stats.lastY = warpObjId.y + TILE_SIZE;				
				room_goto(warpObjId.dest);		

		}//end if
		
		ChangeState(ST_STANDING);
		
	    var xMov = (obj_controller.CheckButton(K_RIGHT) - obj_controller.CheckButton(K_LEFT)) ;	
		var yMov = (obj_controller.CheckButton(K_DOWN)  - obj_controller.CheckButton(K_UP)) ;
		
		//FAVOR X MOVEMENT OVER Y
		if xMov != 0 then yMov = 0;
	
		//IF MOVING	
		if xMov != 0 or yMov != 0 then {	
			//GET GRID POS
		    var xLoc = xMov * TILE_SIZE;	
			var yLoc = yMov * TILE_SIZE;

			//SET DESTINATION TO GRID POS
			destX = snap(x + xLoc, TILE_SIZE);
			destY = snap(y + yLoc, TILE_SIZE);
			
			//SET FACING DIRECTION
			faceDirection = point_direction(x,y,destX,destY);
	        
			if CheckForCollision() and ActorsNotMoving() then {
				destX = x;
				destY = y;
				xMov  = 0;
				yMov  = 0;					
			}else{			
				//UNCOVER DARKNESS IN ROOM
					var currentTile = collision_tile_index(destX,destY);	
					
					
					if currentTile == TILE_TYPE.FLOOR then {
						obj_camera.DefogRoom(destX,destY);
					}//end if
				
				//uncover darkness in HALL
					if currentTile == TILE_TYPE.HALL then {
						obj_camera.DefogAroundMe(destX,destY);
					}//end if	
				
				//RESERVE MY TILE SO MONSTERS DON TRY TO OCCUPY SAME TILE;
					obj_stats.ClearReserveTiles();				
					var reserveX = destX div TILE_SIZE;
					var reserveY = destY div TILE_SIZE;
					obj_stats.ReserveTile(reserveX, reserveY);
					
				MoveMonsters();	
				
				//START MOVING
					x += xMov;
					y += yMov;
					
				if x != destX or y != destY then {
					ChangeState(ST_WALKING);
				}//end if			
			}//end if		
		}//end if	
	}//end if
}//end function

function PlayerAction() {
	if HasState(ST_ATTACKING | ST_HURT | ST_MAGIC_SHOT | ST_WALKING) then exit;

	if ActorsNotMoving() then {
		if obj_controller.CheckButton(K_PB) then {
			var objId = CheckForObject(mas_object,false);
			var actId = CheckForObject(mas_actor,false);
			
			if instance_exists(objId) then {				
				if objId.object_index != obj_pot_large and objId.object_index != obj_pot_small  {
					ChangeState(ST_INTERACTING);
				}//end if	
				objId.Interacted();						
			}//end if	
			
			if instance_exists(actId) then {
				actId.Interact(id,actId);
			}//end if
			
			if HasState(ST_STANDING | ST_QUEUED) then {
				ChangeState(ST_ATTACKING);
				currentAnimation = animations.attack;
				
				//GET WEAPON EQ'd				
					var weaponItem = obj_player.stats.equipment.leftHand;
				
				//GET WEAPON TYPE
					var weaponType = weaponItem.type;
					
				//GET WEAPON SPRITE
					var weaponSprite = weaponItem.weaponSprite;
				
				var weaponID = instance_create_depth(0,-255, depth,obj_weapon);
				weaponID.parent = id;
				weaponID.sprite_index = weaponSprite;
			}//end if
				
			MoveMonsters();	
			exit;
		}//end if
		
		if obj_controller.CheckButton(K_PA) then {
			var lootId = CheckForLoot();	
			if instance_exists(lootId) then {
				ChangeState(ST_INTERACTING);
				lootId.Interacted();					
				MoveMonsters();				
			}else{
				TryToUseItem();
			}//end if				
		}//end if
			
		UpdateTilePosition();
	}//end if
}//end function

function PlayerAnimate() {
	if HasState(ST_WALKING)  then currentAnimation = animations.walk;
	if HasState(ST_STANDING) then currentAnimation = animations.stand;
		
	if HasState(ST_HURT)     then {
		currentAnimation = animations.hurt;
		hurtTimer += 1;
		
		if hurtTimer > 29 then {
			ChangeState(ST_STANDING);
			hurtTimer = 0;
		}//end if
	}//end if
}//end function

function CheckForObject(object){
	var xLook = middle_x() + dcos(faceDirection) * TILE_SIZE;
	var yLook = middle_y() - dsin(faceDirection) * TILE_SIZE;
	var objId = collision_point(xLook, yLook, object, false, true);	

	return objId ;
}//emd functino

function CheckForLoot(){
	var xLook = middle_x();
	var yLook = middle_y();
	var objId = collision_point(xLook, yLook, obj_item, false, true);	
	return objId ;
}//emd functino

function CheckForObjectAt(object, xLook, yLook){	
	var objId = collision_point(xLook, yLook, object, false, true);	
	return objId;
}//emd functino

function Interact(source_id, target_id){	
	var atkData    = new AttackData();
	atkData.source = source_id
	atkData.target = target_id
		
	if source_id.stats.class = ACTOR_CLASS_PLAYER then {
		atkData.attackType = ATTACK_TYPE_MELEE;
	}//end if
	
	if source_id.stats.class = ACTOR_CLASS_MONSTER then {
		atkData.attackType =  ATTACK_TYPE_MONSTER;		
	}//end if
	
	obj_stats.attackQueue.Enqueue(atkData);// attacktype pulled from instance
	source_id.ChangeState(ST_QUEUED);
	
}

function ActorsNotMoving() {
	var allStill = true;
	
	with mas_actor {
		if x != destX and y != destY then {
			allStill = false;
		}//end if
	}//end with
	
	return allStill;
}//end function

function TryToUseItem() {
	var tryIndex = obj_stats.setItemIndex;
	
	if tryIndex > -1 then {
		var setItem = obj_stats.setItems[tryIndex];
		var canUseItem = not is_undefined(setItem);
		
		if canUseItem then {
			var itemToUse   = setItem.item;

			setItem.uses -= 1;
			
			if setItem.uses < 1 then obj_stats.setItems[tryIndex] = undefined;				
			
			itemToUse.UseItem(itemToUse);
		}//end if
	}//end if
}//end function

function UpdateTilePosition() {
	tileX = x div TILE_SIZE;
	tileY = y div TILE_SIZE;	
}//end function

function UpdateAnimations() {
	var aniWalkLeft = new AnimationData();
	aniWalkLeft.AddFrame(sprite_index, 0, 1, -1, 1, 16, 0, 0, 1);
	aniWalkLeft.AddFrame(sprite_index, 1, 1, -1, 1, 16, 0, 0, 1);

	var aniWalkRight = new AnimationData();
	aniWalkRight.AddFrame(sprite_index, 0, 1, 1, 1, 0, 0, 0, 1);
	aniWalkRight.AddFrame(sprite_index, 1, 1, 1, 1, 0, 0, 0, 1);

	var aniWalkUp = new AnimationData();
	aniWalkUp.AddFrame(sprite_index, 2, 1, 1, 1, 0, 0, 0, 1);
	aniWalkUp.AddFrame(sprite_index, 2, -1,  1, 1, 0, 0, 0, 1);

	var aniWalkDown = new AnimationData();
	aniWalkDown.AddFrame(sprite_index, 3, 1, 1, 1, 0, 0, 0, 1);
	aniWalkDown.AddFrame(sprite_index, 3, -1,  1, 1, 0, 0, 0, 1);

	animations.walk = [aniWalkRight, aniWalkUp, aniWalkLeft, aniWalkDown];
	
	var aniStandLeft = new AnimationData();
	aniStandLeft.AddFrame(sprite_index, 0, 1, -1, 1, 16, 0, 0, 1);

	var aniStandRight = new AnimationData();
	aniStandRight.AddFrame(sprite_index, 0, 1, 1, 1, 0, 0, 0, 1);

	var aniStandUp = new AnimationData();
	aniStandUp.AddFrame(sprite_index, 2, 1, 1, 1, 0, 0, 0, 1);

	var aniStandDown = new AnimationData();
	aniStandDown.AddFrame(sprite_index, 3, 1, 1, 1, 0, 0, 0, 1);

	animations.stand = [aniStandRight, aniStandUp, aniStandLeft, aniStandDown];
	
	var aniAttackLeft = new AnimationData();
	aniAttackLeft.AddFrame(sprite_index, 4, 1, -1, 1, 16, 0, 0, .1);

	var aniAttackRight = new AnimationData();
	aniAttackRight.AddFrame(sprite_index, 4, 1, 1, 1, 0, 0, 0, .1);

	var aniAttackUp = new AnimationData();
	aniAttackUp.AddFrame(sprite_index, 5, 1, 1, 1, 0, 0, 0, .1);

	var aniAttackDown = new AnimationData();
	aniAttackDown.AddFrame(sprite_index, 6, 1, 1, 1, 0, 0, 0, .1);

	animations.attack = [aniAttackRight, aniAttackUp, aniAttackLeft, aniAttackDown];
				

	var aniHurtLeft = new AnimationData();
	aniHurtLeft.AddFrame(sprite_index, 7, 1, -1, 1, 16, 0, 0, 8);
	aniHurtLeft.AddFrame(sprite_index, 7, 1, -1, 1, 17, 0, 0, 8);
	aniHurtLeft.AddFrame(sprite_index, 7, 1, -1, 1, 16, 0, 0, 8);
	aniHurtLeft.AddFrame(sprite_index, 7, 1, -1, 1, 17, 0, 0, 8);

	var aniHurtRight = new AnimationData();
	aniHurtRight.AddFrame(sprite_index, 7, 1,  1, 1, 00, 0, 0, 8);
	aniHurtRight.AddFrame(sprite_index, 7, 1,  1, 1, 01, 0, 0, 8);
	aniHurtRight.AddFrame(sprite_index, 7, 1,  1, 1, 00, 0, 0, 8);
	aniHurtRight.AddFrame(sprite_index, 7, 1,  1, 1, 01, 0, 0, 8);

	var aniHurtUp = new AnimationData();
	aniHurtUp.AddFrame(sprite_index, 8, 1,  1, 1, 00, 0, 0, 8);
	aniHurtUp.AddFrame(sprite_index, 8, 1,  1, 1, 01, 0, 0, 8);
	aniHurtUp.AddFrame(sprite_index, 8, 1,  1, 1, 00, 0, 0, 8);
	aniHurtUp.AddFrame(sprite_index, 8, 1,  1, 1, 01, 0, 0, 8);

	var aniHurtDown = new AnimationData();
    aniHurtDown.AddFrame(sprite_index, 9, 1,  1, 1, 00, 0, 0, 8);
    aniHurtDown.AddFrame(sprite_index, 9, 1,  1, 1, 01, 0, 0, 8);
    aniHurtDown.AddFrame(sprite_index, 9, 1,  1, 1, 00, 0, 0, 8);
    aniHurtDown.AddFrame(sprite_index, 9, 1,  1, 1, 01, 0, 0, 8);

	animations.hurt = [aniHurtRight, aniHurtUp, aniHurtLeft, aniHurtDown];
								
	currentAnimation = animations.stand;
}//end function

function DrawSprite(animation){
	var animationIndex = faceDirection div 90;
	var animationData  = animation[animationIndex];
	var frame          = animationData.GetFrameData(image_index);
	
	draw_sprite(spr_shadow,0,x,y + yOffset div 2);
	draw_sprite_general(frame.iconSprite, frame.imageIndex, 0,0, sprite_width, 8, x + frame.xOffset, y + frame.yOffset + 0 + yOffset, frame.xScale, frame.yScale, frame.rotation, image_blend,  image_blend,  image_blend,  image_blend, image_alpha)
	draw_sprite_general(frame.iconSprite, frame.imageIndex, 0 ,8, sprite_width, 8, x + frame.xOffset + 16 * (frame.bottomXscale < 0), y + frame.yOffset + 8 + yOffset, frame.xScale * frame.bottomXscale, frame.yScale, frame.rotation, image_blend,  image_blend,  image_blend,  image_blend, image_alpha)
	image_index += image_speed * frame.speedMult;
}

function MoveMonsters() {
	
	//RESERVE PLAYER TILE SO MONSTERS DON TRY TO OCCUPY SAME TILE;
	with mas_actor {	
		if stats.class = ACTOR_CLASS_PLAYER {
			obj_stats.ClearReserveTiles();				
			var reserveX = destX div TILE_SIZE;
			var reserveY = destY div TILE_SIZE;
			obj_stats.ReserveTile(reserveX, reserveY);
		}//end if
	}//end with
	
	with mas_actor {
		if stats.class = ACTOR_CLASS_MONSTER {			
			targetMiddleX = middle_x(stats.target);
			targetMiddleY = middle_y(stats.target);
			
			myMiddleX = middle_x(id);
			myMiddleY = middle_y(id);
					
			if HasState(ST_WAITING) { 
				if LineOfSight(myMiddleX, myMiddleY, targetMiddleX, targetMiddleY) then {
					RemoveState(ST_WAITING);	
				}//end if
			}else{							
				var xdir = 0;
				var ydir = 0;
						
				var northDistance = point_distance(targetMiddleX,targetMiddleY,myMiddleX + 0,myMiddleY - TILE_SIZE);
				var southDistance = point_distance(targetMiddleX,targetMiddleY,myMiddleX + 0,myMiddleY + TILE_SIZE);
				var eastDistance  = point_distance(targetMiddleX,targetMiddleY,myMiddleX + TILE_SIZE,myMiddleY - 0);
				var westDistance  = point_distance(targetMiddleX,targetMiddleY,myMiddleX - TILE_SIZE,myMiddleY - 0);
			
				var eastTilCollide  = collision_tile(myMiddleX + TILE_SIZE, myMiddleY + 0) == 1;
				var northTilCollide = collision_tile(myMiddleX + 0, myMiddleY - TILE_SIZE) == 1;
				var westTilCollide  = collision_tile(myMiddleX - TILE_SIZE, myMiddleY + 0) == 1;
				var southTilCollide = collision_tile(myMiddleX + 0, myMiddleY + TILE_SIZE) == 1;
			
				var eastObjCollide  = CheckForObjectAt(mas_object, myMiddleX + TILE_SIZE, myMiddleY + 0) > 0;
				var northObjCollide = CheckForObjectAt(mas_object, myMiddleX + 0, myMiddleY - TILE_SIZE) > 0;
				var westObjCollide  = CheckForObjectAt(mas_object, myMiddleX - TILE_SIZE, myMiddleY + 0) > 0;
				var southObjCollide = CheckForObjectAt(mas_object, myMiddleX + 0, myMiddleY + TILE_SIZE) > 0;
			
				
				var eastActCollide  =  CheckForObjectAt(mas_actor, myMiddleX + TILE_SIZE, myMiddleY + 0) > 0;
				var northActCollide =  CheckForObjectAt(mas_actor, myMiddleX + 0, myMiddleY - TILE_SIZE) > 0;
				var westActCollide  =  CheckForObjectAt(mas_actor, myMiddleX - TILE_SIZE, myMiddleY + 0) > 0;
				var southActCollide =  CheckForObjectAt(mas_actor, myMiddleX + 0, myMiddleY + TILE_SIZE) > 0;
									
				var eastCollide  = eastTilCollide 	or eastObjCollide  or eastActCollide;  
				var northCollide = northTilCollide	or northObjCollide or northActCollide; 
				var westCollide  = westTilCollide 	or westObjCollide  or westActCollide;  
				var southCollide = southTilCollide	or southObjCollide or southActCollide;
			
				eastDistance  += eastCollide  * 255;
				northDistance += northCollide * 255;
				westDistance  += westCollide  * 255;			
				southDistance += southCollide * 255;
			
			
				var distArray = [eastDistance, northDistance, westDistance, southDistance];
				var smallestDirection = array_min_index(distArray) * 90;
			
				xdir = dcos(smallestDirection)  * TILE_SIZE;
				ydir = -dsin(smallestDirection) * TILE_SIZE;
				
				//FAVOR X MOVEMENT OVER Y
					if xdir != 0 then {
						ydir = 0;
					}//end if
					
				destX = snap(x + xdir, TILE_SIZE);
				destY = snap(y + ydir, TILE_SIZE);
			
				if destX != x or destY != y then {
					faceDirection = point_direction(x,y,destX,destY);
				}//end if
				
				//CHECK FOR ATTACK
				var eastTgtCollide  = CheckForObjectAt(stats.target, myMiddleX + TILE_SIZE, myMiddleY + 0) > 0;
				var northTgtCollide = CheckForObjectAt(stats.target, myMiddleX + 0, myMiddleY - TILE_SIZE) > 0;
				var westTgtCollide  = CheckForObjectAt(stats.target, myMiddleX - TILE_SIZE, myMiddleY + 0) > 0;
				var southTgtCollide = CheckForObjectAt(stats.target, myMiddleX + 0, myMiddleY + TILE_SIZE) > 0;
				var attack = eastTgtCollide  or	northTgtCollide or	westTgtCollide  or	southTgtCollide;
			
			
				var reservedCollide = obj_stats.TileReserved(destX div TILE_SIZE, destY div TILE_SIZE);
				
				if reservedCollide then {
					print("tried to move into reserved tile");	
					obj_stats.TileReserved(destX div TILE_SIZE, destY div TILE_SIZE);//debug call
				}//end if
				
				if attack then {
					Interact(id, stats.target)	;
					destX = x;
					destY = y;
					faceDirection = point_direction(x,y,stats.target.x,stats.target.y);	
				}//end if
						
				if CheckForCollision() or reservedCollide then {
					destX = x;
					destY = y;
				}else{
					if not attack then {
						x += dcos(smallestDirection);
						y += -dsin(smallestDirection);
					}
				}//end if
			}//end if
			
			obj_stats.ReserveTile(destX div TILE_SIZE,destY div TILE_SIZE);
			
		}//end if
	}//end with
}//end function

#region DEBUG
	function DrawDebug(xp, yp){
		draw_set_font(global.fnt_small);
			draw_text_hue(xp, yp + 00, "x  " + string(x) , c_gold);    
			draw_text_hue(xp, yp + 08, "y  " + string(y) , c_gold);     
			draw_text_hue(xp, yp + 16, "dX " + string(destX) , c_gold); 
			draw_text_hue(xp, yp + 24, "dY " + string(destY) , c_gold); 
			draw_text_hue(xp, yp + 32, "st " + string(state) , c_gold);    
		draw_set_font(global.fnt_8bit);
		
		if instance_exists(stats.target) then {
			DrawLineOfSight(x,y,stats.target.x,stats.target.y);
		}//end if
	}//end function

	function DrawLineOfSight(x1, y1, x2, y2) {
		var tx1       = snap(x1, TILE_SIZE) div TILE_SIZE; 
		var ty1       = snap(y1, TILE_SIZE) div TILE_SIZE; 
		var tx2       = snap(x2, TILE_SIZE) div TILE_SIZE; 
		var ty2       = snap(y2, TILE_SIZE) div TILE_SIZE; 
		var checkX    = 0;
		var checkY    = 0;
		var dx        = tx2 - tx1
		var dy        = ty2 - ty1;
		var tileIndex = 0;
	    var step      = 0;
	    var i         = 1;
		var color     = c_azure;
		var door      = false;
		var scanX     = 0;
		var scanY     = 0;
		
		if (abs(dx) >= abs(dy)) {
			step = abs(dx);
		}else{
			step = abs(dy);
		}//end if
 
		dx = dx / step;
		dy = dy / step;
		checkX = tx1;
		checkY = ty1;
	
		while (i <= step) {
			scanX = checkX * TILE_SIZE + 8;
			scanY = checkY * TILE_SIZE + 8;
			tileIndex = collision_tile_index(scanX, scanY);
			door  = collision_point(scanX,scanY,obj_door,false,true) > 0
			if tileIndex == 1 or door then color = c_gold;
			draw_text_hue(checkX * TILE_SIZE + 4, checkY * TILE_SIZE + 2, ".", color);
			checkX += dx;
			checkY += dy;
			i += 1;
		}//end while
	}//end function


	function StateString() {
		var stateString = "";
		
		if HasState(ST_NULL)		 then stateString += "ST_NULL ";
		if HasState(ST_STANDING)	 then stateString += "ST_STANDING ";
		if HasState(ST_WALKING)		 then stateString += "ST_WALKING ";
		if HasState(ST_WAITING)		 then stateString += "ST_WAITING ";
		if HasState(ST_CHECK_LOS)	 then stateString += "ST_CHECK_LOS ";
		if HasState(ST_INTERACTING)	 then stateString += "ST_INTERACTING ";
		if HasState(ST_QUEUED)		 then stateString += "ST_QUEUED ";
		if HasState(ST_SWIMMING)	 then stateString += "ST_SWIMMING ";
		if HasState(ST_THROWING)	 then stateString += "ST_THROWING ";
		if HasState(ST_USING_ITEM)	 then stateString += "ST_USING_ITEM ";
		if HasState(ST_HIGH_JUMP)	 then stateString += "ST_HIGH_JUMP ";
		if HasState(ST_FALLING)		 then stateString += "ST_FALLING ";
		if HasState(ST_WALL_JUMPING) then stateString += "ST_WALL_JUMPING ";
		if HasState(ST_HURT)		 then stateString += "ST_HURT ";
		if HasState(ST_DEAD)		 then stateString += "ST_DEAD ";
		if HasState(ST_ATTACKING)	 then stateString += "ST_ATTACKING ";
		if HasState(ST_INVINCIBLE)	 then stateString += "ST_INVINCIBLE ";
		if HasState(ST_PUSHING)		 then stateString += "ST_PUSHING ";
		if HasState(ST_LIFTING)		 then stateString += "ST_LIFTING ";
		if HasState(ST_MAGIC_PLUME)	 then stateString += "ST_MAGIC_PLUME ";
		if HasState(ST_MAGIC_SHOT)	 then stateString += "ST_MAGIC_SHOT ";
		if HasState(ST_THROW_BOMB)	 then stateString += "ST_THROW_BOMB ";
		if HasState(ST_TALKING)		 then stateString += "ST_TALKING ";
		if HasState(ST_SHOPING)		 then stateString += "ST_SHOPING ";
		if HasState(ST_CANT_MOVE)	 then stateString += "ST_CANT_MOVE ";
		
		return stateString;
	}//end function


	function DrawState(xPos, yPos) {
		draw_text_hue(xPos, yPos, StateString(), c_grass);
	}//end function


#endregion