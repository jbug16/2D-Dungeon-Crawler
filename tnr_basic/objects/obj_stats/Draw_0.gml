

if menuOpen then {
	//MAINMENU
	if menuLevel == 0 then {
		draw_menu_box(obj_camera.x, obj_camera.y,CAMERA_WIDTH, CAMERA_HEIGHT, c_black, c_frost, "Menu", true )
		var menuDesc = ["Equip", "Item", "Set Items", "Stats", "Save"];
		var iconXpos = [016 + 8,064 - 8,064 + 24,112 + 8,160 - 8];
		
		
		//ICONS
			draw_sprite(spr_menu_icons,0,obj_camera.x + iconXpos[0], obj_camera.y + 8);
			draw_sprite(spr_menu_icons,1,obj_camera.x + iconXpos[1], obj_camera.y + 8);			
			draw_sprite(spr_menu_icons,4,obj_camera.x + iconXpos[2], obj_camera.y + 8);						
			draw_sprite(spr_menu_icons,2,obj_camera.x + iconXpos[3], obj_camera.y + 8);
			draw_sprite(spr_menu_icons,3,obj_camera.x + iconXpos[4], obj_camera.y + 8);
		
		//DESCRIPTON
			var textX = obj_camera.x + CAMERA_WIDTH  div 2;
			var textY = obj_camera.y + CAMERA_HEIGHT div 2;
			var desc  = menuDesc[selectionLevel[menuLevel]];
			
			draw_set_halign(fa_center);
				draw_text_hue(textX, textY, desc, c_white);
			draw_set_halign(fa_left);	
			
		//CURSOR
			timer += 1
		
			if timer > 8 then {
				draw_sprite_ext(spr_menu_icons,sprite_get_number(spr_menu_icons) - 1, obj_camera.x + iconXpos[selectionLevel[menuLevel]], obj_camera.y + 8,1,1,0,c_white, .5);
			}//end if
		
			if timer > 16 then timer = 0;
	}//end if
	
	//EQUIP
	if menuLevel == 1 or menuLevel == 2 then {
		var eqpIcons  = ICO_LEFT_EQ	+ "\n" + ICO_RIGHT_EQ + "\n" + ICO_HEAD_EQ	+ "\n" + ICO_BODY_EQ + "\n" + ICO_ACC_EQ	
		var statNames = "HP\nMP\nFP\nAT\nDF\nHI\nEV\nLK";
		
		//borders
		draw_menu_box(obj_camera.x, obj_camera.y,CAMERA_WIDTH, CAMERA_HEIGHT, c_black, c_frost, "Equip", true )
		draw_menu_box(obj_camera.x + 96, obj_camera.y, 96, CAMERA_HEIGHT, c_black, c_frost, "Stats", true  )
		draw_menu_box(obj_camera.x, obj_camera.y + 72,192, 56, c_black, c_frost, "Items", true  )
		
		//text
		draw_text_ext_hue(obj_camera.x + 16, obj_camera.y + 16, eqpIcons, 10, -1, c_frost)
		draw_text_ext_hue(obj_camera.x + 104, obj_camera.y + 08, statNames,8, -1, c_frost);
			
		//current equipment
		var curEqp = obj_player.stats.equipment;
		draw_text_ext_hue(obj_camera.x + 32, obj_camera.y + 16, curEqp.leftHand.name, 08, -1, c_frost);
		draw_text_ext_hue(obj_camera.x + 32, obj_camera.y + 26, curEqp.rightHand.name, 08, -1, c_frost);
		draw_text_ext_hue(obj_camera.x + 32, obj_camera.y + 36, curEqp.head.name, 08, -1, c_frost);
		draw_text_ext_hue(obj_camera.x + 32, obj_camera.y + 46, curEqp.body.name, 08, -1, c_frost);
		draw_text_ext_hue(obj_camera.x + 32, obj_camera.y + 56, curEqp.acc.name, 08, -1, c_frost);
		
		//stats
		var hpString = string_lpad(obj_player.stats.max_hp + obj_player.stats.bonusMax_hp,3," ");
		var mpString = string_lpad(obj_player.stats.max_mp + obj_player.stats.bonusMax_mp,3," ");
		var fpString = string_lpad(obj_player.stats.max_fp + obj_player.stats.bonusMax_fp,3," ");
		var atString = string_lpad(obj_player.stats.att    + obj_player.stats.bonusAtt   ,3," ");
		var dfString = string_lpad(obj_player.stats.def    + obj_player.stats.bonusDef   ,3," ");
		var hiString = string_lpad(obj_player.stats.hit    + obj_player.stats.bonusHit   ,3," ");
		var evString = string_lpad(obj_player.stats.evd    + obj_player.stats.bonusEvd   ,3," ");
		var lkString = string_lpad(obj_player.stats.luk    + obj_player.stats.bonusLuk   ,3," ");
				
		draw_text_ext_hue(obj_camera.x + 128, obj_camera.y + 08, hpString, 08, -1, c_frost);
		draw_text_ext_hue(obj_camera.x + 128, obj_camera.y + 16, mpString, 08, -1, c_frost);
		draw_text_ext_hue(obj_camera.x + 128, obj_camera.y + 24, fpString, 08, -1, c_frost);
		draw_text_ext_hue(obj_camera.x + 128, obj_camera.y + 32, atString, 08, -1, c_frost);
		draw_text_ext_hue(obj_camera.x + 128, obj_camera.y + 40, dfString, 08, -1, c_frost);
		draw_text_ext_hue(obj_camera.x + 128, obj_camera.y + 48, hiString, 08, -1, c_frost);
		draw_text_ext_hue(obj_camera.x + 128, obj_camera.y + 56, evString, 08, -1, c_frost);
		draw_text_ext_hue(obj_camera.x + 128, obj_camera.y + 64, lkString, 08, -1, c_frost);

		//SHOW AVAILABE ITEMS FOR SELECTED SLOT
			var selectedSlotItems = equippableItems[selectionLevel[1]];
			DrawItems(selectedSlotItems,itemListOffset,8, 16, 80);
			
		//cursor
		if menuLevel == 1 then {
			draw_sprite(spr_menu_cursor,0 , obj_camera.x + 16, obj_camera.y + 16 + 10 * selectionLevel[menuLevel]);
		}else if menuLevel == 2 then {	
			var row = selectionLevel[menuLevel] div 2;
			var col = selectionLevel[menuLevel] mod 2;
			draw_sprite(spr_menu_cursor,0 , obj_camera.x + 16, obj_camera.y + 16 + 10 * selectionLevel[1]);
			draw_sprite(spr_menu_cursor,0 , obj_camera.x + 16 + col * 80, obj_camera.y + 80 + row * 10);
				
			//get current eq
			var slotIndex = selectionLevel[1];
			var currentEq = undefined;
				
			if slotIndex == 0 then currentEq = obj_player.stats.equipment.leftHand ;
			if slotIndex == 1 then currentEq = obj_player.stats.equipment.rightHand;
			if slotIndex == 2 then currentEq = obj_player.stats.equipment.head     ;
			if slotIndex == 3 then currentEq = obj_player.stats.equipment.body     ;
			if slotIndex == 4 then currentEq = obj_player.stats.equipment.acc      ;
				
			var hpOld = obj_player.stats.max_hp + obj_player.stats.bonusMax_hp
			var mpOld = obj_player.stats.max_mp + obj_player.stats.bonusMax_mp
			var fpOld = obj_player.stats.max_fp + obj_player.stats.bonusMax_fp
			var atOld = obj_player.stats.att    + obj_player.stats.bonusAtt   
			var dfOld = obj_player.stats.def    + obj_player.stats.bonusDef   
			var hiOld = obj_player.stats.hit    + obj_player.stats.bonusHit   
			var evOld = obj_player.stats.evd    + obj_player.stats.bonusEvd   
			var lkOld = obj_player.stats.luk    + obj_player.stats.bonusLuk  
				
			//TO DO!!! - DRAW SELECTED ITEM STATS
			var selectedItemData = selectedSlotItems.Get(selectionLevel[menuLevel] + itemListOffset * 2);	

			if not is_undefined(selectedItemData) then {
				//chnge eq
				if slotIndex == 0 then obj_player.stats.equipment.leftHand  = selectedItemData;
				if slotIndex == 1 then obj_player.stats.equipment.rightHand = selectedItemData;
				if slotIndex == 2 then obj_player.stats.equipment.head      = selectedItemData;
				if slotIndex == 3 then obj_player.stats.equipment.body      = selectedItemData;
				if slotIndex == 4 then obj_player.stats.equipment.acc       = selectedItemData;
			}else{
				obj_player.stats.bonusMax_hp = 0;
				obj_player.stats.bonusMax_mp = 0;
				obj_player.stats.bonusMax_fp = 0;
				obj_player.stats.bonusAtt    = 0;
				obj_player.stats.bonusDef    = 0;
				obj_player.stats.bonusHit    = 0;
				obj_player.stats.bonusEvd    = 0;
				obj_player.stats.bonusLuk	 = 0;					
			}//end if
				
			obj_player.stats.RefreshStats();

			var hpNew = obj_player.stats.max_hp + obj_player.stats.bonusMax_hp
			var mpNew = obj_player.stats.max_mp + obj_player.stats.bonusMax_mp
			var fpNew = obj_player.stats.max_fp + obj_player.stats.bonusMax_fp
			var atNew = obj_player.stats.att    + obj_player.stats.bonusAtt   
			var dfNew = obj_player.stats.def    + obj_player.stats.bonusDef   
			var hiNew = obj_player.stats.hit    + obj_player.stats.bonusHit   
			var evNew = obj_player.stats.evd    + obj_player.stats.bonusEvd   
			var lkNew = obj_player.stats.luk    + obj_player.stats.bonusLuk
				
			//redraw stats
			var hpString = ICO_ARROW_RT + string_lpad(obj_player.stats.max_hp + obj_player.stats.bonusMax_hp,3," ");
			var mpString = ICO_ARROW_RT + string_lpad(obj_player.stats.max_mp + obj_player.stats.bonusMax_mp,3," ");
			var fpString = ICO_ARROW_RT + string_lpad(obj_player.stats.max_fp + obj_player.stats.bonusMax_fp,3," ");
			var atString = ICO_ARROW_RT + string_lpad(obj_player.stats.att    + obj_player.stats.bonusAtt   ,3," ");
			var dfString = ICO_ARROW_RT + string_lpad(obj_player.stats.def    + obj_player.stats.bonusDef   ,3," ");
			var hiString = ICO_ARROW_RT + string_lpad(obj_player.stats.hit    + obj_player.stats.bonusHit   ,3," ");
			var evString = ICO_ARROW_RT + string_lpad(obj_player.stats.evd    + obj_player.stats.bonusEvd   ,3," ");
			var lkString = ICO_ARROW_RT + string_lpad(obj_player.stats.luk    + obj_player.stats.bonusLuk   ,3," ");
				
			var col = c_frost;

			col = c_frost; if hpNew > hpOld then col = c_gold; if hpNew < hpOld then col = c_gray; 
			draw_text_ext_hue(obj_camera.x + 152, obj_camera.y + 08, hpString, 08, -1, col);
			col = c_frost; if mpNew > mpOld then col = c_gold; if mpNew < mpOld then col = c_gray; 
			draw_text_ext_hue(obj_camera.x + 152, obj_camera.y + 16, mpString, 08, -1, col);
			col = c_frost; if fpNew > fpOld then col = c_gold; if fpNew < fpOld then col = c_gray;
			draw_text_ext_hue(obj_camera.x + 152, obj_camera.y + 24, fpString, 08, -1, col);
			col = c_frost; if atNew > atOld then col = c_gold; if atNew < atOld then col = c_gray; 
			draw_text_ext_hue(obj_camera.x + 152, obj_camera.y + 32, atString, 08, -1, col);
			col = c_frost; if dfNew > dfOld then col = c_gold; if dfNew < dfOld then col = c_gray; 
			draw_text_ext_hue(obj_camera.x + 152, obj_camera.y + 40, dfString, 08, -1, col);
			col = c_frost; if hiNew > hiOld then col = c_gold; if hiNew < hiOld then col = c_gray;
			draw_text_ext_hue(obj_camera.x + 152, obj_camera.y + 48, hiString, 08, -1, col);
			col = c_frost; if evNew > evOld then col = c_gold; if evNew < evOld then col = c_gray; 
			draw_text_ext_hue(obj_camera.x + 152, obj_camera.y + 56, evString, 08, -1, col);
			col = c_frost; if lkNew > lkOld then col = c_gold; if lkNew < lkOld then col = c_gray;
			draw_text_ext_hue(obj_camera.x + 152, obj_camera.y + 64, lkString, 08, -1, col);				
			//var itemData = selectedSlotItems.Get(selectionLevel[menuLevel] + itemListOffset * 2);
				
			//chnge eq back
			if slotIndex == 0 then obj_player.stats.equipment.leftHand  = currentEq;
			if slotIndex == 1 then obj_player.stats.equipment.rightHand = currentEq;
			if slotIndex == 2 then obj_player.stats.equipment.head      = currentEq;
			if slotIndex == 3 then obj_player.stats.equipment.body      = currentEq;
			if slotIndex == 4 then obj_player.stats.equipment.acc       = currentEq;
				
			obj_player.stats.RefreshStats();		
		}//end if			
	}//end if - menuLevel 1

	//ITEMS
	if menuLevel == 8 then {	
		//borders
		draw_menu_box(obj_camera.x, obj_camera.y,CAMERA_WIDTH, CAMERA_HEIGHT, c_black, c_frost, "Items", true  );
		draw_menu_box(obj_camera.x, obj_camera.y + 096,CAMERA_WIDTH, 32, c_black, c_frost, "Info", true  );
		var inventoryItems = inventory.GetAllItems();
		DrawItems(inventoryItems ,itemListOffset,16, 24,16);
		
		var selectedItemData = inventoryItems.Get(selectionLevel[menuLevel] + itemListOffset * 2);
		if not is_undefined(selectedItemData) then {
			draw_text_ext_hue(obj_camera.x + 8, obj_camera.y + 104, selectedItemData.description,10, 176, c_gold)					
		}//end if
		
		var row = selectionLevel[menuLevel] div 2;
		var col = selectionLevel[menuLevel] mod 2;
		draw_sprite(spr_menu_cursor,0 , obj_camera.x + 24 + col * 80, obj_camera.y + 16 + row * 10);
	}//end if
	
	if menuLevel == 9 then {
		//borders
		draw_menu_box(obj_camera.x, obj_camera.y,CAMERA_WIDTH, CAMERA_HEIGHT, c_black, c_frost, "Items", true  );
		draw_menu_box(obj_camera.x, obj_camera.y + 096,CAMERA_WIDTH, 32, c_black, c_frost, "Info", true  );
		
		var inventoryItems = inventory.GetAllItems();		
		var selectedItemData = inventoryItems.Get(selectionLevel[8] + itemListOffset * 2);
		
		//NO ITEM SELECTED CODE
		if is_undefined(selectedItemData) then {
			menuLevel = 8;
			exit;
		}//end if
		

		draw_menu_box(obj_camera.x + 8, obj_camera.y + 8,CAMERA_WIDTH - 16, 56, c_black, c_frost, "Action", true  );
		draw_menu_box(obj_camera.x + 8, obj_camera.y + 8,CAMERA_WIDTH - 16, 24, c_black, c_frost, "Action", true  );
				
		
		var canUse   = not selectedItemData.IsClass(ITEM_CLASS_PLOT | ITEM_CLASS_UNTHROWABLE);//selectedItemData.IsClass(ITEM_CLASS_USE | ITEM_CLASS_SPELL);
		var canThrow = not selectedItemData.IsClass(ITEM_CLASS_PLOT | ITEM_CLASS_UNTHROWABLE);
		var canDrop  = not selectedItemData.IsClass(ITEM_CLASS_PLOT | ITEM_CLASS_UNDROPPABLE);
		
		var actionColor = [c_ruby, c_frost];
		
		draw_text_hue( obj_camera.x + 64, obj_camera.y + 16, selectedItemData.name, c_gold);
		draw_text_hue( obj_camera.x + 24, obj_camera.y + 40,       "Set"  , actionColor[canUse]);
		draw_text_hue( obj_camera.x + 24 + 48, obj_camera.y + 40,  "Throw", actionColor[canThrow]);
		draw_text_hue( obj_camera.x + 24 + 112, obj_camera.y + 40, "Drop" , actionColor[canDrop]);
		//draw_text_hue( obj_camera.x + 24, obj_camera.y + 40, "Use   Throw   Drop", c_white);
		var tempoffset = 16 * (selectionLevel[menuLevel] == 2);
		
		draw_sprite(spr_menu_cursor, 0 , obj_camera.x + 24 + selectionLevel[menuLevel] * 48 + tempoffset, obj_camera.y + 40);
	}//end if
	
	if menuLevel == 20 then {
		//BORDER
			draw_menu_box(obj_camera.x, obj_camera.y,CAMERA_WIDTH, CAMERA_HEIGHT, c_black, c_frost, "Items", true  );
			draw_menu_box(obj_camera.x, obj_camera.y + 096,CAMERA_WIDTH, 32, c_black, c_frost, "Info", true  );
		
			var inventoryItems   = inventory.GetAllItems();		
			var selectedItemData = inventoryItems.Get(selectionLevel[8] + itemListOffset * 2);
		
		//DRAW SET ITEMS
			draw_text_hue(obj_camera.x + 032, obj_camera.y + 16, "Set 1", c_gold);
			draw_text_hue(obj_camera.x + 112, obj_camera.y + 16, "Set 2", c_gold);
	
		//DRAW LEFT ITEMS
		    for (var setIndex = 0; setIndex < 8; setIndex += 2) {
			    var currentSetItem = setItems[setIndex];
		
				if is_undefined(currentSetItem) == false then {
					draw_sprite(spr_items, currentSetItem.item.iconSprite, obj_camera.x + 72, obj_camera.y + 16 + setIndex * 8);
					if currentSetItem.uses > 1 then draw_text_hue(obj_camera.x + 72 + 16, obj_camera.y + 16 + 08 + setIndex * 8, currentSetItem.uses, c_white);
				}//end if

			}//end for	
	
		//DRAW RIGHT ITEMS
		    for (var setIndex = 1; setIndex < 8; setIndex += 2) {
			    var currentSetItem = setItems[setIndex];
		
				if is_undefined(currentSetItem) == false then {
					draw_sprite(spr_items, currentSetItem.item.iconSprite, obj_camera.x + 160, obj_camera.y + 08 + setIndex * 8);
					if currentSetItem.uses > 1 then draw_text_hue(obj_camera.x + 160 + 16, obj_camera.y + 08 + 08 + setIndex * 8, currentSetItem.uses, c_white);
				}//end if

			}//end for	
			//draw_text_hue( obj_camera.x + 32, obj_camera.y + 24, "Set 2", c_gold);
			//draw_text_hue( obj_camera.x + 32, obj_camera.y + 24, "Set 3", c_gold);
			//draw_text_hue( obj_camera.x + 32, obj_camera.y + 24, "Set 4", c_gold);
			//draw_text_hue( obj_camera.x + 32, obj_camera.y + 24, "Set 5", c_gold);
			//draw_text_hue( obj_camera.x + 32, obj_camera.y + 24, "Set 6", c_gold);
			//draw_text_hue( obj_camera.x + 32, obj_camera.y + 24, "Set 7", c_gold);
			//draw_text_hue( obj_camera.x + 32, obj_camera.y + 24, "Set 8", c_gold);
		
		

		//draw_menu_box(obj_camera.x + 8, obj_camera.y + 8,CAMERA_WIDTH - 16, 56, c_black, c_frost, "Action", true  );
		//draw_menu_box(obj_camera.x + 8, obj_camera.y + 8,CAMERA_WIDTH - 16, 24, c_black, c_frost, "Action", true  );
		//		
		//
		//var canUse   = not selectedItemData.IsClass(ITEM_CLASS_PLOT | ITEM_CLASS_UNTHROWABLE);//selectedItemData.IsClass(ITEM_CLASS_USE | ITEM_CLASS_SPELL);
		//var canThrow = not selectedItemData.IsClass(ITEM_CLASS_PLOT | ITEM_CLASS_UNTHROWABLE);
		//var canDrop  = not selectedItemData.IsClass(ITEM_CLASS_PLOT | ITEM_CLASS_UNDROPPABLE);
		//
		//var actionColor = [c_ruby, c_frost];
		//
		//draw_text_hue( obj_camera.x + 64, obj_camera.y + 16, selectedItemData.name, c_gold);
		//draw_text_hue( obj_camera.x + 24, obj_camera.y + 40,       "Set"  , actionColor[canUse]);
		//draw_text_hue( obj_camera.x + 24 + 48, obj_camera.y + 40,  "Throw", actionColor[canThrow]);
		//draw_text_hue( obj_camera.x + 24 + 112, obj_camera.y + 40, "Drop" , actionColor[canDrop]);
		////draw_text_hue( obj_camera.x + 24, obj_camera.y + 40, "Use   Throw   Drop", c_white);
		//var tempoffset = 16 * (selectionLevel[menuLevel] == 2);
		//
		//draw_sprite(spr_menu_cursor, 0 , obj_camera.x + 24 + selectionLevel[menuLevel] * 48 + tempoffset, obj_camera.y + 40);
	}//end if
	
	
	//STATUS
	if menuLevel == 12 then {	
		//borders
		draw_menu_box(obj_camera.x, obj_camera.y,CAMERA_WIDTH, CAMERA_HEIGHT, c_black, c_frost, "Status", true  );
		var statsData = obj_player.stats;
		
		var strName		  = "Kyrala" ;
		var strClass	  = "Bio Magus" ;
		var strLevel	  = string(statsData.lvl);//"16" ;
		var strSkill	  = string(statsData.skill) ;
		var strAuria	  = "1024";
		var strExperince  = string_lpad(statsData.next - statsData.xp, 7, " ")  ;//95 / 120" ;
		var strHp		  = string_lpad(statsData.hp, 3, " ") + " / " + string_lpad(statsData.max_hp, 3, " ");// " 86 / 100" ;
		var strMp		  = string_lpad(statsData.mp, 3, " ") + " / " + string_lpad(statsData.max_mp, 3, " ");// " 25 /  80" ;
		var strFp		  = string_lpad(statsData.fp, 3, " ") + " / " + string_lpad(statsData.max_fp, 3, " ");// " 50 /  50" ;
		var strAtt		  = string_lpad(statsData.att, 3, " ");//" ;
		var strMag		  = string_lpad(statsData.mag, 3, " ");//" ;
		var strHit		  = string_lpad(statsData.hit, 3, " ");//%" ;
		var strEvd		  = string_lpad(statsData.evd, 3, " ");//%" ;
		var strDef		  = string_lpad(statsData.def, 3, " ");//" ;
		var strLuk		  = string_lpad(statsData.luk, 3, " ");//" ;
		
		draw_sprite(obj_player.sprite_index, 3, obj_camera.x + 08, obj_camera.y + 08);

		draw_sprite(spr_mugs, 1, obj_camera.x + 120, obj_camera.y + 32);
		draw_menu_box( obj_camera.x + 112, obj_camera.y + 24,72, 72, c_black, c_frost, "Face", false);
		
		draw_text_ext_hue( obj_camera.x + 32, obj_camera.y + 08, strName,8,-1, c_white);
		draw_text_ext_hue( obj_camera.x + 32, obj_camera.y + 16, "Lv. " + strLevel,8,-1, c_white);
		draw_text_ext_hue( obj_camera.x + 96, obj_camera.y + 08, strClass,8,-1,  c_white);
		draw_text_ext_hue( obj_camera.x + 96, obj_camera.y + 16, "Sk. " + strSkill,8,-1,  c_white);
		
		draw_text_ext_hue( obj_camera.x + 08, obj_camera.y + 32, "Auria " + strAuria,8,-1,  c_white);
		draw_text_ext_hue( obj_camera.x + 08, obj_camera.y + 48, "Next " + strExperince ,8,-1,  c_white);
		
		draw_text_ext_hue( obj_camera.x + 08, obj_camera.y + 64, "Hp " + strHp,8,-1,  c_white);
		draw_text_ext_hue( obj_camera.x + 08, obj_camera.y + 72, "Mp " + strMp,8,-1,  c_white);
		draw_text_ext_hue( obj_camera.x + 08, obj_camera.y + 80, "Fp " + strFp,8,-1,  c_white);
		draw_text_ext_hue( obj_camera.x + 08, obj_camera.y + 96, "Att " + strAtt,8,-1,  c_white);
		draw_text_ext_hue( obj_camera.x + 08, obj_camera.y + 104, "Hit " + strHit,8,-1,  c_white);
		draw_text_ext_hue( obj_camera.x + 08, obj_camera.y + 112, "Luk " + strLuk,8,-1,  c_white);
		draw_text_ext_hue( obj_camera.x + 80, obj_camera.y + 96, "Def " + strDef,8,-1,  c_white);
		draw_text_ext_hue( obj_camera.x + 80, obj_camera.y + 104, "Evd " + strEvd,8,-1,  c_white);
		draw_text_ext_hue( obj_camera.x + 80, obj_camera.y + 112, "Mag " + strMag,8,-1,  c_white);
	}//end if	
		
	//SAVE
	if menuLevel == 13 or menuLevel == 14 then {
		var dimColor = c_blue;
		
		//BORDERS
			draw_menu_box(obj_camera.x, obj_camera.y,CAMERA_WIDTH, CAMERA_HEIGHT, c_black, c_frost, "Save", true);	
			draw_menu_box(obj_camera.x + 24, obj_camera.y + 16,CAMERA_WIDTH - 32, 32, c_black, dimColor, "Save 1", true);
			draw_menu_box(obj_camera.x + 24, obj_camera.y + 48,CAMERA_WIDTH - 32, 32, c_black, dimColor, "Save 2", true);	
			draw_menu_box(obj_camera.x + 24, obj_camera.y + 80,CAMERA_WIDTH - 32, 32, c_black, dimColor, "Save 3", true);
		
		//DRAW GFX
			draw_sprite_ext(spr_chest_small,0,obj_camera.x + 8, obj_camera.y + 24,1,1,0, dimColor, .75);
			draw_sprite_ext(spr_chest_small,0,obj_camera.x + 8, obj_camera.y + 56,1,1,0, dimColor, .75);
			draw_sprite_ext(spr_chest_small,0,obj_camera.x + 8, obj_camera.y + 88,1,1,0, dimColor, .75);
		
			
		#region DRAW OLD SAVES
			//SLOT 1
				var strName1  = "Mallia" ;
				var strLevel1  = "5";
				var strTower1  = "8";
				var strFloor1  = "4"		
		
				draw_sprite_ext(spr_player, 3, obj_camera.x + 30, obj_camera.y + 24 + 00, 1, 1, 0,  dimColor, .75);			
				draw_text_hue(obj_camera.x + 048, obj_camera.y + 24 + 00, strName1,             dimColor);
				draw_text_hue(obj_camera.x + 104, obj_camera.y + 24 + 00, "Lv. " + strLevel1 ,  dimColor);
				draw_text_hue(obj_camera.x + 048, obj_camera.y + 24 + 10, "Tower " + strTower1, dimColor);
				draw_text_hue(obj_camera.x + 112, obj_camera.y + 24 + 10, "Floor " + strFloor1, dimColor);		
	
			//SLOT 2
				var strName1  = "Gaile" ;
				var strLevel1  = "12";
				var strTower1  = "1";
				var strFloor1  = "8"		
		
				draw_sprite_ext(spr_player, 3, obj_camera.x + 30, obj_camera.y + 24 + 32, 1, 1, 0,  dimColor, .75);			
				draw_text_hue(obj_camera.x + 048, obj_camera.y + 24 + 00 + 32, strName1,             dimColor);
				draw_text_hue(obj_camera.x + 104, obj_camera.y + 24 + 00 + 32, "Lv. " + strLevel1 ,  dimColor);
				draw_text_hue(obj_camera.x + 048, obj_camera.y + 24 + 10 + 32, "Tower " + strTower1, dimColor);
				draw_text_hue(obj_camera.x + 112, obj_camera.y + 24 + 10 + 32, "Floor " + strFloor1, dimColor);		

			//SLOT 3
				var strName1  = "Sarah" ;
				var strLevel1  = "1";
				var strTower1  = "2";
				var strFloor1  = "3"		
		
				draw_sprite_ext(spr_player, 3, obj_camera.x + 30, obj_camera.y + 24 + 64, 1, 1, 0,  dimColor, .75);			
				draw_text_hue(obj_camera.x + 048, obj_camera.y + 24 + 00 + 64, strName1,             dimColor);
				draw_text_hue(obj_camera.x + 104, obj_camera.y + 24 + 00 + 64, "Lv. " + strLevel1 ,  dimColor);
				draw_text_hue(obj_camera.x + 048, obj_camera.y + 24 + 10 + 64, "Tower " + strTower1, dimColor);
				draw_text_hue(obj_camera.x + 112, obj_camera.y + 24 + 10 + 64, "Floor " + strFloor1, dimColor);		
		#endregion
		
		
		//DRAW SAVE DATA
			if menuLevel == 13 then {	
				var slot  = selectionLevel[menuLevel];
				var slotY = obj_camera.y + 24 + slot * 32;
				var statsData = obj_player.stats;
				var strName	  = "Kyrala" ;
				var strLevel  = string(statsData.lvl);
				var strTower  = "1";
				var strFloor  = "1";
				
				draw_sprite(spr_chest_large, 0, obj_camera.x + 8, slotY);
					
				draw_menu_box(obj_camera.x + 24, obj_camera.y + 16 + slot * 32,CAMERA_WIDTH - 32, 32, c_black, c_frost, "Save " + string(slot + 1), true);				
				
				draw_sprite(spr_player,3,obj_camera.x + 30, slotY);	
				draw_text_hue(obj_camera.x + 48, slotY, strName + " Lv. " + strLevel , c_white);
				draw_text_hue(obj_camera.x + 48, slotY + 10, "Tower " + strTower, c_white);
				draw_text_hue(obj_camera.x + 112, slotY + 10, "Floor " + strFloor, c_white);	
			}//end if
	}//end if	


	if menuLevel == 14 then {
		var slot  = selectionLevel[menuLevel - 1];
		var slotY = obj_camera.y + 24 + slot * 32;
			
		//DRAW SAVE DATA
			var statsData = obj_player.stats;
			var strName	  = "Kyrala" ;
			var strLevel  = string(statsData.lvl);
			var strTower  = "1";
			var strFloor  = "1";
			
			draw_sprite(spr_chest_large, 1, obj_camera.x + 8, slotY);
		
			draw_menu_box(obj_camera.x + 24, obj_camera.y + 16 + slot * 32,CAMERA_WIDTH - 32, 32, c_black, c_gold, "Save Here?", true);				
			
			draw_sprite_ext(spr_player,4,obj_camera.x + 46, slotY,-1,1,0,c_white,1);	
			draw_text_hue(obj_camera.x + 48, slotY, strName + " Lv. " + strLevel , c_gold);
			draw_text_hue(obj_camera.x + 48, slotY + 10, "Tower " + strTower, c_gold);
			draw_text_hue(obj_camera.x + 112, slotY + 10, "Floor " + strFloor, c_gold);	
	}//end if	

	if menuLevel == 15 then {
		var iconPosX = obj_camera.x + obj_universe.overworldShipX div TILE_SIZE;
		var iconPosY = obj_camera.y + obj_universe.overworldShipY div TILE_SIZE;
		
		draw_sprite(obj_universe.selected_planet_sprite, 0, obj_camera.x, obj_camera.y);
		draw_sprite_ext(spr_icons, 2, iconPosX, iconPosY,1,1,0,choose(c_black,c_white),1);
		
		map_data = obj_universe.grd_planet_surface_map;

		for (var ypos = 0; ypos <  map_data.width ; ypos += 1) {
			for (var xpos = 0; xpos <  map_data.height ; xpos += 1) {
				var tileData = map_data.data[xpos][ypos] + 1;
				
				
				if tileData == TILE.TOWN {
					iconPosX = obj_camera.x + xpos;
					iconPosY = obj_camera.y + ypos;
					draw_sprite_ext(spr_icons, 0, iconPosX, iconPosY,1,1,0,c_white,1);
				}
				
				if tileData == TILE.DUNGEON {
					iconPosX = obj_camera.x + xpos;
					iconPosY = obj_camera.y + ypos;					
					draw_sprite_ext(spr_icons, 1, iconPosX, iconPosY,1,1,0,c_white,1);
				}
				
			}//end if
		}//end if
	}//end if

	//DEBUG
	draw_text_hue(obj_camera.x, obj_camera.y, string(menuLevel) , c_ruby);



}else{
	DrawStats(4,4);
	DrawSetItems(4,104);
}//end if

//debug
	//draw_text_hue(obj_camera.x, obj_camera.y+8, string([menuLevel,selectionLevel[menuLevel], itemListOffset]), c_grass)