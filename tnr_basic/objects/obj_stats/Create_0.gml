random_set_seed(256);

background_tilemap = 0;
collision_tilemap  = 0;
fog_tilemap        = 0;
attackQueue        = new Queue();
attackQueueTimer   = 0;
menuOpen           = false;
timer              = 0;

menuLevel          = 0
selectionLevel     = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
itemListOffset     = 0;

inventory          = new Inventory();

handSlotItemsList = undefined;
headSlotItemsList = undefined;
bodySlotItemsList = undefined;
accSlotItemsList  = undefined;
equippableItems   = []
setItems          = [undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined];
setItemIndex      = -1;

houseSeed   = 256;
townSeed    = 512;
dungeonSeed = 128;

lastRoom = undefined;
lastX    = undefined
lastY    = undefined

lstTakenPositions = ds_list_create();


function ClearReserveTiles() {
	ds_list_clear(lstTakenPositions);
}


function ReserveTile(tileX, tileY) {
	ds_list_add(lstTakenPositions, new Point(tileX, tileY));
}


function TileReserved(tileX, tileY) {
	var length = ds_list_size(lstTakenPositions);
	var point = undefined;
	
	for (var index = 0; index < length; ++index) {
		point = lstTakenPositions[| index];
		if point.x == tileX and point.y == tileY then return true;
	}//end for
	
	return false;
}//end function

	
function ProcessMenu() {
	if obj_camera.fading then exit;
	
	if obj_controller. CheckButton(K_PSTART) then {
		menuOpen = not menuOpen	;
		menuLevel = 0;
		obj_camera.FadeIn(30, c_black);
	}//end if
	
	//close menu
	if menuOpen and menuLevel == 0 and obj_controller.CheckButtonThenClear(K_PA) then {
		menuOpen = false;
		obj_camera.FadeIn(30, c_black);
	}//end if
	
	if menuOpen then {
		if menuLevel == 0 then {
			selectionLevel[menuLevel] += obj_controller.CheckButtonLeftRight();
			if selectionLevel[menuLevel] < 0 then selectionLevel[menuLevel] = 4
			selectionLevel[menuLevel] = selectionLevel[menuLevel] mod 5;
			
			if obj_controller.CheckButtonThenClear(K_PB) then {
				//1 = equip  // - item  -stats  -options -save
				if selectionLevel[menuLevel] == 0 then {
					menuLevel = 1;	
					
					//refresh carried equippable items
						handSlotItemsList = inventory.GetItemsOfClass(ITEM_CLASS_HAND);
						headSlotItemsList = inventory.GetItemsOfClass(ITEM_CLASS_HEAD);
						bodySlotItemsList = inventory.GetItemsOfClass(ITEM_CLASS_BODY);
						accSlotItemsList  = inventory.GetItemsOfClass(ITEM_CLASS_ACCESSORY);	
						equippableItems = [handSlotItemsList, handSlotItemsList, headSlotItemsList,  bodySlotItemsList, accSlotItemsList];
								
					obj_camera.FadeIn(30, c_black);				
				}//end if

					
				if selectionLevel[menuLevel] == 1 then {
					menuLevel = 8;
					itemListOffset = 0;
					obj_camera.FadeIn(30, c_black);							
				}//end if
				
					
				if selectionLevel[menuLevel] == 2 then {
					menuLevel = 20;
					//itemListOffset = 0;
					obj_camera.FadeIn(30, c_black);							
				}//end if
					
				if selectionLevel[menuLevel] == 3 then {
					menuLevel = 12;
					itemListOffset = 0;
					obj_camera.FadeIn(30, c_black);							
				}//end if
			
			
				if selectionLevel[menuLevel] == 4 then {
					menuLevel = 13;
					obj_camera.FadeIn(30, c_black);							
				}//end if
				
			}//end if
		}//end if
		
		#region EQUIP
			//slot
				if menuLevel == 1 then {
					//select slot
					selectionLevel[menuLevel] += obj_controller.CheckButtonDownUp();
					if selectionLevel[menuLevel] < 0 then selectionLevel[menuLevel] = 4
					selectionLevel[menuLevel] = selectionLevel[menuLevel] mod 5;
			
					//choose slot
					if obj_controller.CheckButtonThenClear(K_PB) then {
						menuLevel = 2;
					}//end if
					
					//go back
					if obj_controller.CheckButtonThenClear(K_PA) then {
						menuLevel = 0;
						obj_camera.FadeIn(30, c_black);						
					}//end if
				}//end if
		
			//select items
				if menuLevel == 2 then {
					var maxItems = equippableItems[selectionLevel[1]].count;
					
					//select item
					var move = obj_controller.CheckButtonLeftRight() + 2 * obj_controller.CheckButtonDownUp();
					selectionLevel[menuLevel] += obj_controller.CheckButtonLeftRight() + 2 * obj_controller.CheckButtonDownUp();
					
					if selectionLevel[menuLevel] < 0 and move < 0 then {
						if itemListOffset > 0 then itemListOffset -= 1;
						selectionLevel[menuLevel] = 0;
					}//end if
					
					if selectionLevel[menuLevel] > 7 and move > 0 then {
						if itemListOffset < maxItems div 2 then itemListOffset += 1;
						selectionLevel[menuLevel] = 7 - (selectionLevel[menuLevel] mod 2 == 0)
					}//end if					


					//equip item
					if obj_controller.CheckButtonThenClear(K_PB) then {
						var selectedSlotItems = equippableItems[selectionLevel[1]];
						var selectedItemIndex = selectionLevel[menuLevel] + itemListOffset * 2;
						var selectedItemData  = selectedSlotItems.Get(selectedItemIndex);
						var slotIndex         = selectionLevel[1];
						var oldItem           = undefined;
											
						if is_undefined(selectedItemData) then {
							selectedItemData = new Item()
						}//end if
		
						//STORE OLD ITEM
							if slotIndex == 0 then oldItem = obj_player.stats.equipment.leftHand ;
							if slotIndex == 1 then oldItem = obj_player.stats.equipment.rightHand;
							if slotIndex == 2 then oldItem = obj_player.stats.equipment.head     ;
							if slotIndex == 3 then oldItem = obj_player.stats.equipment.body     ;
							if slotIndex == 4 then oldItem = obj_player.stats.equipment.acc      ;							
								
						//REMOVE NEW ITEM FROM INVENTORY
							inventory.RemoveItemInSlot(selectedItemIndex);
								
						//EQUIP NEW ITEM
							if slotIndex == 0 then obj_player.stats.equipment.leftHand  = selectedItemData;
							if slotIndex == 1 then obj_player.stats.equipment.rightHand = selectedItemData;
							if slotIndex == 2 then obj_player.stats.equipment.head      = selectedItemData;
							if slotIndex == 3 then obj_player.stats.equipment.body      = selectedItemData;
							if slotIndex == 4 then obj_player.stats.equipment.acc       = selectedItemData;
					
						//RECALC STATS
							obj_player.stats.RecalculateBaseStats(false);
							obj_player.stats.RefreshStats();
			
						//PUT OLD ITEM BACK
							inventory.AddItem(oldItem.id);

												
						//refresh carried equippable items
							handSlotItemsList = inventory.GetItemsOfClass(ITEM_CLASS_HAND);
							headSlotItemsList = inventory.GetItemsOfClass(ITEM_CLASS_HEAD);
							bodySlotItemsList = inventory.GetItemsOfClass(ITEM_CLASS_BODY);
							accSlotItemsList  = inventory.GetItemsOfClass(ITEM_CLASS_ACCESSORY);	
							equippableItems = [handSlotItemsList, handSlotItemsList, headSlotItemsList,  bodySlotItemsList, accSlotItemsList];
																		
							menuLevel -= 1;	
					}//end if
					
					//go back
					if obj_controller.CheckButtonThenClear(K_PA) then {			
						menuLevel = 1;
						obj_camera.FadeIn(30, c_black);
					}//end if

				}//end if
							
		#endregion

		#region VIEW ITEMS
			if menuLevel == 8 then {
				var move = obj_controller.CheckButtonLeftRight() + 2 * obj_controller.CheckButtonDownUp();
				selectionLevel[menuLevel] += obj_controller.CheckButtonLeftRight() + 2 * obj_controller.CheckButtonDownUp();
					
				if selectionLevel[menuLevel] < 0 and move < 0 then {
					if itemListOffset > 0 then itemListOffset -= 1;
					selectionLevel[menuLevel] = 0;
				}//end if
					
				if selectionLevel[menuLevel] > 15 and move > 0 then {
					if itemListOffset < inventory.slots.count div 2 then itemListOffset += 1;
					selectionLevel[menuLevel] = 15 - (selectionLevel[menuLevel] mod 2 == 0)
				}//end if	
				
				
				if obj_controller.CheckButtonThenClear(K_PB) then {
					//ready to use item
					menuLevel = 9;
				}//end if

				if obj_controller.CheckButtonThenClear(K_PA) then {//go back
					menuLevel = 0;
					obj_camera.FadeIn(30, c_black);
				}//end if

			}//end if
			
			//VIEW & USE
			if menuLevel == 9 then {
				//var maxItems = //equippableItems[selectionLevel[1]].count;
				//select item
				var move = obj_controller.CheckButtonLeftRight() ;
				selectionLevel[menuLevel] += obj_controller.CheckButtonLeftRight() + 2 * obj_controller.CheckButtonDownUp();
				//selectionLevel[menuLevel] = clamp(selectionLevel[menuLevel],0,2);
					
				//select slot
				selectionLevel[menuLevel] += obj_controller.CheckButtonDownUp();
				if selectionLevel[menuLevel] < 0 then selectionLevel[menuLevel] = 2
				selectionLevel[menuLevel] = selectionLevel[menuLevel] mod 3;
				
				
				if obj_controller.CheckButtonThenClear(K_PB) then {
					var inventoryItems = inventory.GetAllItems();
					var selectedItemIndex = selectionLevel[8] + itemListOffset * 2;
					var selectedItemData = inventoryItems.Get(selectedItemIndex);
					
					var using = selectionLevel[menuLevel] == 0;
					var throwing = selectionLevel[menuLevel] == 1;
					var dropping = selectionLevel[menuLevel] == 2;
		
					var canUse   = not selectedItemData.IsClass(ITEM_CLASS_PLOT | ITEM_CLASS_UNTHROWABLE);//selectedItemData.IsClass(ITEM_CLASS_USE | ITEM_CLASS_SPELL);
					var canThrow = not selectedItemData.IsClass(ITEM_CLASS_PLOT | ITEM_CLASS_UNTHROWABLE);
					var canDrop  = not selectedItemData.IsClass(ITEM_CLASS_PLOT | ITEM_CLASS_UNDROPPABLE);
					
					if using and canUse then {

						var setSlot = FindFreeSetSlot();
						
						if setSlot > -1 then {
							setItems[setSlot] = new SetItem(selectedItemData, selectedItemData.uses);
							
							
							//selectedItemData.set = true;
							//selectedItemData.setSlot = setSlot;
							inventory.RemoveItemInSlot(selectedItemIndex)
							//CONFIRM
						}else{
							//BUZZ	
						}
											menuLevel = 8;
					}else if throwing and canThrow then {
						menuLevel = 8;
						
					}else if dropping and canDrop then {
						menuLevel = 8;
						
					}//end if
					
					
					//to do check if usable throwable or droppable & perform action
				}//end if
				
				if obj_controller.CheckButtonThenClear(K_PA) then {//go back
					menuLevel = 8;
					obj_camera.FadeIn(30, c_black);
				}//end if

			}//end if			
		
		
			if menuLevel == 20 then {										
				//GO BACK
					if obj_controller.CheckButtonThenClear(K_PA) then {
						menuOpen = not menuOpen	;
						menuLevel = 0;
						obj_camera.FadeIn(30, c_black);									
					}//end if		
			}//end if
		#endregion

		#region STATS
			if menuLevel == 12 then {
				if obj_controller.CheckButtonThenClear(K_PA) then {
					menuLevel = 0;
					obj_camera.FadeIn(30, c_black);					
				}//end if		
			}//end if			
			
		#endregion

		#region SAVE
			if menuLevel == 13 then {
				//SELECT SLOT
					selectionLevel[menuLevel] += obj_controller.CheckButtonDownUp();
					if selectionLevel[menuLevel] < 0 then selectionLevel[menuLevel] = 2
					selectionLevel[menuLevel] = selectionLevel[menuLevel] mod 3;
			
					//choose slot
					if obj_controller.CheckButtonThenClear(K_PB) then {
						menuLevel = 14;
					}//end if
										
				//GO BACK
					if obj_controller.CheckButtonThenClear(K_PA) then {
						menuLevel = 0;
						obj_camera.FadeIn(30, c_black);					
					}//end if		
			}//end if
			
			if menuLevel == 14 then {
				//SAVE
					if obj_controller.CheckButtonThenClear(K_PB) then {
						obj_camera.FadeIn(30, c_black);	
						menuLevel = 13;
					}//end if
										
				//GO BACK
					if obj_controller.CheckButtonThenClear(K_PA) then {
						menuLevel = 13;
					}//end if		
			}//end if
			
			
		#endregion
	
		#region OVERWORLDMAP VIEW
			if menuLevel == 15 then {
										
				//GO BACK
					if obj_controller.CheckButtonThenClear(K_PA) then {
						menuOpen = not menuOpen	;
						menuLevel = 0;
						obj_camera.FadeIn(30, c_black);									
					}//end if		
			}//end if			
		#endregion	
	
	}else{
		var selectDelta = obj_controller.CheckButton(K_PR)  - obj_controller.CheckButton(K_PL);
			
		if selectDelta != 0 then {
			setItemIndex += selectDelta;
		    sound_play(snd_select_item, false);
			if setItemIndex < -1 then setItemIndex = 7;
			if setItemIndex > 7 then setItemIndex = -1;
		}//end if
	}
}//end function


function DrawItems(lstItems, rowOffset, maxDisplay, xpos, ypos) {
	var drawColor = c_frost;
	
	for (var i = rowOffset * 2; i < min(lstItems.count,maxDisplay + rowOffset * 2) ; ++i) {
		var itemData = lstItems.Get(i);
		drawColor = c_frost;
		if itemData.set then drawColor = c_grass;
		
		draw_text_ext_hue(obj_camera.x + xpos + (80 * ((i mod 2) == 1)), obj_camera.y + ypos  + (10 * (i div 2) - (rowOffset * 10)), itemData.name, 08, -1, drawColor);
	}//end for		
}//end function


function DrawMenu() {

}//end if


function CalculatePhysicalAttackDamage2(attackerStats, defenderStats, itemData) {
	
	var AttackHit = function(attackerStats, defenderStats){
		
		//1)  If the Target has Sleep, Paralyze or Charm status, the attack automatically hits.  Goto Step 10.
		if defenderStats.HasStatus(STATUS_SLEEP | STATUS_STOP) then return true;
		
		//2)  If the Attacker is using Aim, Jump, Throw, Sword Dance or X-Fight or if the  Attacker is attacking himself, the attack automatically hits.  Goto Step 10.
		if attackerStats.HasStatus(STATUS_JUMPING) then return true;
	
		//3)  If the Target can't evade Physical (check "Can't Evade" parameter), the  attack automatically hits.  Goto Step 10.
		//4)  Check to see if Evade ability, Weapon Block (due to Hardened or Defender), Weapon Block (due to Guardian) or Elf Cape succeed (6.3.4).  If any of their checks succeed, the attack misses;  do not follow any more steps.  None of these abilities can succeed if the Target has Sleep, Paralyze, Charm or Stop status or is attacking himself.
		//5)  Apply Target status effect modifiers to physical Evade% (6.3.7)
		
		var evadePercent = defenderStats.evd + defenderStats.bonusEvd;
		if defenderStats.HasStatus(STATUS_SLOW) then evadePercent = evadePercent div 2;	
		if defenderStats.HasStatus(STATUS_MINI) then evadePercent = evadePercent * 2;
		evadePercent = min(evadePercent, 99);


		//6)  Apply Attacker status effect modifiers to physical Hit% (6.3.8)
		var hitPercent = attackerStats.hit + attackerStats.bonusHit;	
		if attackerStats.HasStatus(STATUS_BLIND) then hitPercent = hitPercent div 4;			
		if attackerStats.HasStatus(STATUS_SLOW) hitPercent = hitPercent div 2;	
	
		//7)  Let N1 = (0..99)  If N1 >= Hit%, the attack misses;  do not follow any more steps.
		var hitRoll = irandom_range(0,99);
		if hitRoll >= hitPercent then return false;
		//9)  Let N2 = (0..99)  If N2 < Evade%, the attack misses;  do not follow any more steps.
		var evadeRoll = irandom_range(0,99);
		if evadeRoll < evadePercent then return false;		
		
		//10)  If the Target has Image status, the attack misses, but the Target loses one Image;  do not follow any more steps.
		//todo
		
		//11)  The attack hits.  Follow the rest of the steps to calculate damage.		
		return true;

	}
	
	//	ATTACK TYPE (HEX: 31) (Swords)
	var  hit = attackerStats.hit + attackerStats.bonusHit;
	var  evd = defenderStats.evd + defenderStats.bonusEvd;
	
	//2) Follow Hit Determination for Physical Attacks steps (6.2.1).	
	var attackSuccessful = AttackHit(attackerStats, defenderStats);

	
	var   attack = floor((attackerStats.att + attackerStats.bonusAtt) * random_range(1,1.5)) ;
	
	// calculate for 2hand
	
	var   modifier = 1
	var   defense = defenderStats.def
		if attackerStats.HasStatus(STATUS_MINI) then attack = attack div 8;
		if attackerStats.HasStatus(STATUS_BERSERK) then attack = attack * 2;

		if attackerStats.HasStatus(STATUS_MAGICSWORD) {

		}
			
	var atkEle       = attackerStats.eleAttack;
	var defEleImmune = (defenderStats.eleImmune  & atkEle) > 0 ;
	var defEleWeak   = (defenderStats.eleWeak    & atkEle) > 0 ;
	var defEleStrong = (defenderStats.eleStrong  & atkEle) > 0 ;
	var defEleAbsorb = (defenderStats.eleAbsorb  & atkEle) > 0 ;

	if defEleAbsorb then {
		attack = -attack;
		defense = 0;
	}//end if
	
	if defEleImmune then {
			attack = 0;	
	}//end if
		
	if defEleWeak then {
		attack =  attack * 2;
		defense = 0;
	}//end if
		
	if defEleStrong then {
		attack =  attack div 2;		
	}//end if	

	var damage = clamp((attack - defense) * modifier,0, 9999);
	
	if itemData.spell > 0 then {
		spellchance = irandom_range(1,99);
		if spellchance < itemData.spellHit then {
			//queue up spell//cast spell 100 it	
		}
	}
	
	return damage;
}//end function
	
	
function CalculatePhysicalAttackDamage(attackerStats, defenderStats) {
	
//************************
// 2.1  damage calculation
//************************
//
//Determining the amount of  damage an attack can do is complicated, and I broke
//it down into 9 steps. The 1st step has 4 parts. Depending on whether the attack
//is physical or magical, and whether the attacker it a character or monster, it
//uses a different part of step 1. After step 1, you have the base maximum
// damage that the attack can do. The following 8 steps will further modify the
// damage, and are used for all attacks, magical or physical, made by monsters or
//characters. At the end of all steps you will have the amount of  damage the
//attack can do.
//
//
//Step 1. Maximum  damage calculation

    var strength = (attackerStats.att + attackerStats.bonusAtt) * 2;
    if attackerStats.att +  attackerStats.bonusAtt >= 128 then strength = 255;
    var Attack = attackerStats.pow + strength;
    var  damage = attackerStats.pow + ((attackerStats.lvl * attackerStats.lvl * Attack) div 256) * 3 div 2;
    
	//If character is equipped with two weapons
	var weaponType = ITEM_TYPE_SWORD | ITEM_TYPE_KATANA| ITEM_TYPE_KNIFE | ITEM_TYPE_SPEAR |	ITEM_TYPE_WHIP | ITEM_TYPE_HAMMER |	ITEM_TYPE_ROD |	ITEM_TYPE_HARP | ITEM_TYPE_AXE | ITEM_TYPE_CLAW | ITEM_TYPE_STAFF | ITEM_TYPE_BELL | ITEM_TYPE_BOOK |ITEM_TYPE_NUNCHAKU |ITEM_TYPE_BOOMERANG |ITEM_TYPE_SCYTHE |ITEM_TYPE_PICKAXE;
	var leftTypeWeapon =  attackerStats.equipment.leftHand.IsType(weaponType);
	var rightTypeWeapon =  attackerStats.equipment.rightHand.IsType(weaponType);
	
	if leftTypeWeapon and rightTypeWeapon then {
		 damage = ceil( damage * 3 div 4)
	}//end if  

//  damage Multipliers #1
   var multiplier = 0;

//  Berserk - If physical attack and attacker has berserk status add 1 to  damage
	multiplier += attackerStats.HasStatus(STATUS_BERSERK)

//  Critical hit -
	if irandom(100) <= 3 then {
		multiplier += 2;
	}//end if

	 damage =  damage + (( damage div 2) * multiplier)

// Step 6a Randomize
     damage = floor( damage * random_range(1, 1.5));

//  Step 6b. Defense modification
     damage = ( damage * (255 - defenderStats.def + defenderStats.bonusDef) div 256) + 1


//If physical attack and target is Defending:
	if defenderStats.HasStatus(STATUS_DEFENDING) then {
	     damage =  damage div 2;
	}//end if

//Step 9. Elemental resistance
	var atkEle       = attackerStats.eleAttack;
	var defEleImmune = (defenderStats.eleImmune  & atkEle) > 0 ;
	var defEleWeak   = (defenderStats.eleWeak    & atkEle) > 0 ;
	var defEleStrong = (defenderStats.eleStrong  & atkEle) > 0 ;
	var defEleAbsorb = (defenderStats.eleAbsorb  & atkEle) > 0 ;

	if defEleAbsorb then {
		 damage = - damage;
	}//end if
	
	if defEleImmune then {
		 damage = 0;	
	}//end if
		
	if defEleWeak then {
		 damage =  damage * 2;
	}//end if
		
	if defEleStrong then {
		 damage =  damage div 2;		
	}//end if
	
	return  damage;
}


function CalculateMagicalAttackDamage(attackerStats, defenderStats, spellData) {

//*****************
//10.3) WHITE MAGIC
//*****************
//
//SPELL    ATT  MP  HT%  ELEM   STAT    DUR  TAR  R  SPECIAL           PRICE  DF
//Cure      15   4    A                   0    A  Y  Heal HP             180  10
//Scan       0   1    A                   0   SE  Y  Scan Monster         80  1D
//Antdt      0   2    A         Pois      0   SA  Y  Remove Status        90  19
//
//Mute       0   2   75         Mute    180    E  Y                      280  13
//Armor      0   3    A         Armor     A   SA  Y                      280  14
//Size       0   5   90         Mini      A    E  Y  Toggle Status       300  15
//
//Cure2     45   9    A                   0    A  Y  Heal HP             620  10
//Life    1/16  29   50                   0   SA* Y  Revive with % HP    700  1A
//Charm      0   4   75         Charm     A   SE  Y                      650  13
//
//Image      0   6    A         Image(2)  A   SA  Y                     3000  13
//Shell      0   5    A         Shell     A   SA  Y                     3000  14
//Heal       0  10    A         Dk,Po,Mi, 0   SA* Y  Remove Status      3000  19
//                              To,St,Mu,
//                              Ch,Pz,Sl,
//                              Ag
//                              
//Cure3    180  27    A                   0    A  Y  Heal MAX HP on S   6000  11
//Wall       0  15    A         Wall     52*  SA  Y                     6000  14
//Bersk      0   8    A         Bersk     A   SA  Y                     6000  13
//
//Life2  16/16  50   99                   0   SA* Y  Revive with % HP  10000  1A
//Holy     241  20    A  Holy             0   SE  Y                    10000  06
//Dispel     0  12    A         Fl,Im,Be, 0   SE  N  Remove Status     10000  19
//                              Re,Sw,Ha,
//                              Sp,Sh,Ar,
//                              Wa
//
//*****************
//10.4) BLACK MAGIC
//*****************
//
//SPELL    ATT  MP  HT%  ELEM   STAT    DUR  TAR  R  SPECIAL           PRICE  DF
//Fire      15   4    A  Fire             0    E  Y                      150  06
//Ice       15   4    A  Ice              0    E  Y                      150  06
//Bolt      15   4    A  Lit              0    E  Y                      150  06
//
//Venom      0   2   99         Pois      A   SE  Y                      290  12
//Sleep      0   3   90         Sleep     A    E  Y                      300  13
//Toad       0   8   80         Toad      A    E  Y                      300  15
//
//Fire2     50  10    A  Fire             0    E  Y                      600  06
//Ice 2     50  10    A  Ice              0    E  Y                      600  06
//Bolt2     50  10    A  Lit              0    E  Y                      600  06
//
//Drain     45  13   75                   0   SE  N  Drain              3000  0D
//Break      0  15   75         Stone     A   SE  Y                     3000  12
//Bio      105  16    A  Pois             A    E  Y  HP Leak            3000  0C
//
//Fire3    185  25    A  Fire             0    E  Y                     6000  06
//Ice 3    185  25    A  Ice              0    E  Y                     6000  06
//Bolt3    185  25    A  Lit              0    E  Y                     6000  06
//
//Flare    254  39    A                   0   SE  Y  Pierce MDef       10000  08
//Doom       0  29   80         Dead      A   SE  Y                    10000  17
//Psych      8   1   99                   0   SE  N  Osmose            10000  0E




// MAGIC DAMAGE PARAMETERS
//Attack = Spell Attack + (0..(Spell Attack/8))
//M = (Level*Magic Power)/256 + 4
//Defense = Magic Defense

//2) Use Magic Damage Parameters (6.4.1): 

var attackPower = spellData.spellPower + irandom_range(0, spellData.spellPower div 8);
var modifier    = (attackerStats.lvl * attackerStats.mag) div 256 + 4;
var defense     = defenderStats.mag; //consider usein magicpower;
var damage      = (attackPower - defense) * modifier; 

//6) Apply Attack Element modifiers to Attack and Defense (6.5.16).
	var atkEle       = spellData.element;
	var defEleImmune = (defenderStats.eleImmune  & atkEle) > 0 ;
	var defEleWeak   = (defenderStats.eleWeak    & atkEle) > 0 ;
	var defEleStrong = (defenderStats.eleStrong  & atkEle) > 0 ;
	var defEleAbsorb = (defenderStats.eleAbsorb  & atkEle) > 0 ;

	if defEleAbsorb then {
		 damage = - damage;
	}//end if
	
	if defEleImmune then {
		 damage = 0;	
	}//end if
		
	if defEleWeak then {
		 damage =  damage * 2;
	}//end if
		
	if defEleStrong then {
		 damage =  damage div 2;		
	}//end if
	
	return damage;
}//end if


function ProcessAttackQueue(){
	attackQueueTimer -= 1;
	
	if attackQueueTimer < 1 and attackQueue.IsEmpty() == false {	
		attData = attackQueue.Dequeue();
		
		var attacker   = attData.source;
		var defender   = attData.target;
		var attackType = attData.attackType;
		var attackWait = attData.attackWaitTime;
		
		attackQueueTimer = attackWait;
		
		//stop if atttaker is dead
		if instance_exists(attacker) == false then {
			attackQueueTimer = 2;
			return;	
		}//end if
		
		if attackType == ATTACK_TYPE_MONSTER then {
			attackType = attacker.attackType;
		}//end if
		
		if attackType == ATTACK_TYPE_MELEE {	
			attacker.ChangeState(ST_ATTACKING);
		    
			//IF ATTACK LANDS
			defender.ChangeState(ST_HURT);
		
			//calcs
			var weaponType = ITEM_TYPE_SWORD | ITEM_TYPE_KATANA| ITEM_TYPE_KNIFE | ITEM_TYPE_SPEAR | ITEM_TYPE_WHIP | ITEM_TYPE_HAMMER |	ITEM_TYPE_ROD |	ITEM_TYPE_HARP | ITEM_TYPE_AXE | ITEM_TYPE_CLAW | ITEM_TYPE_STAFF | ITEM_TYPE_BELL | ITEM_TYPE_BOOK |ITEM_TYPE_NUNCHAKU |ITEM_TYPE_BOOMERANG |ITEM_TYPE_SCYTHE |ITEM_TYPE_PICKAXE;
			var leftTypeWeapon =  attacker.stats.equipment.leftHand.IsType(weaponType) ;
			var rightTypeWeapon =  attacker.stats.equipment.rightHand.IsType(weaponType);
			var dmg = 0;
		
			if leftTypeWeapon and rightTypeWeapon then {
				dmg =  CalculatePhysicalAttackDamage2(attacker.stats, defender.stats, attacker.stats.equipment.leftHand);
				dmg += CalculatePhysicalAttackDamage2(attacker.stats, defender.stats, attacker.stats.equipment.rightHand);
			}else if leftTypeWeapon then {
				dmg = CalculatePhysicalAttackDamage2(attacker.stats, defender.stats, attacker.stats.equipment.leftHand);			
			}else if rightTypeWeapon then {
				dmg +=  CalculatePhysicalAttackDamage2(attacker.stats, defender.stats, attacker.stats.equipment.rightHand);			
			}else {
				dmg = CalculatePhysicalAttackDamage2(attacker.stats, defender.stats, attacker.stats.equipment.leftHand);			
			}//end if
			
			//show  damage
			damId = instance_create_depth(middle_x(defender), defender.bbox_top + 2, defender.depth - 1, obj_damage);
			damId.value = dmg;
					
			defender.stats.hp -= dmg;
		}//end if
	
		if attackType == ATTACK_TYPE_MAGIC {
			attacker.ChangeState(ST_MAGIC_SHOT);
			
			//GET SPELL
			var spellData = attData.attackSpellData;
			
			//CREATE SHOT
			var shotDirection = attacker.faceDirection
			
			var projId        = instance_create_depth(middle_x(attacker), middle_y(attacker),attacker.depth - 1, obj_projectile);
			projId.parent     = attacker;	
			projId.attackType = ATTACK_TYPE_MAGIC;	
			projId.spellData  = spellData;	
			projId.direction  = shotDirection;	
		}//end if
	
		if attackType == ATTACK_TYPE_THROW {
			attacker.ChangeState(ST_THROWING );
			
			var itemData = attData.attackThrowData;
			var shotDirection = attacker.faceDirection
			
			var projId            = instance_create_depth(middle_x(attacker), middle_y(attacker),attacker.depth - 1, obj_projectile);
			projId.parent         = attacker;	
			projId.attackType     = ATTACK_TYPE_THROW;	
			projId.thrownItemData = itemData; 
			projId.direction      = shotDirection;	
		}//end if
	
		if attackType == ATTACK_TYPE_USE_ITEM {
			attacker.ChangeState(ST_USING_ITEM);			
			var itemData = attData.selfUseData;	
			var statTypeString = "";
			var statTypeSign   = "+";
			var statTypeValue  = 0;
			var statColor      = c_frost;
			
			//STATS BOOST
				if itemData.att             != 0 then {statTypeValue = itemData.att   ; attacker.stats.att    += itemData.att          ; statTypeString = "Att"    ; if itemData.att    < 0 then statTypeSign = "-";};
				if itemData.def             != 0 then {statTypeValue = itemData.def   ; attacker.stats.def    += itemData.def          ; statTypeString = "Def"    ; if itemData.def    < 0 then statTypeSign = "-";};
				if itemData.hit             != 0 then {statTypeValue = itemData.hit   ; attacker.stats.hit    += itemData.hit          ; statTypeString = "Hit"    ; if itemData.hit    < 0 then statTypeSign = "-";};
				if itemData.evd             != 0 then {statTypeValue = itemData.evd   ; attacker.stats.evd    += itemData.evd          ; statTypeString = "Evd"    ; if itemData.evd    < 0 then statTypeSign = "-";};
				if itemData.luk             != 0 then {statTypeValue = itemData.luk   ; attacker.stats.luk    += itemData.luk          ; statTypeString = "Luk"    ; if itemData.luk    < 0 then statTypeSign = "-";};
				if itemData.max_hp	        != 0 then {statTypeValue = itemData.max_hp; attacker.stats.max_hp += itemData.max_hp       ; statTypeString = "Max Hp" ; if itemData.max_hp < 0 then statTypeSign = "-";};
				if itemData.max_mp	        != 0 then {statTypeValue = itemData.max_mp; attacker.stats.max_mp += itemData.max_mp       ; statTypeString = "Max Mp" ; if itemData.max_mp < 0 then statTypeSign = "-";};
				if itemData.max_fp	        != 0 then {statTypeValue = itemData.max_fp; attacker.stats.max_fp += itemData.max_fp       ; statTypeString = "Max Fp" ; if itemData.max_fp < 0 then statTypeSign = "-";};
			
			//RECOVERY
				if itemData.recoverHpRate   != 0 then {statColor = c_grass; statTypeValue = itemData.recoverHpRate; attacker.stats.hp     += itemData.recoverHpRate; statTypeString = "" };
				if itemData.recoverMpRate   != 0 then {statColor = c_azure; statTypeValue = itemData.recoverMpRate; attacker.stats.mp     += itemData.recoverMpRate; statTypeString = "" };
				if itemData.recoverFpRate   != 0 then {statColor = c_gold ; statTypeValue = itemData.recoverFpRate; attacker.stats.fp     += itemData.recoverFpRate; statTypeString = "" };
			
			
			//STATUS
			
			
			//DAMAGE
				damId = instance_create_depth(middle_x(attacker), attacker.bbox_top + 2, attacker.depth - 1, obj_damage);
			
				if statTypeString != "" then {
					damId.value = statTypeString + " " + statTypeSign + string(statTypeValue);				
				}else{
					damId.value = statTypeValue;	
				}//end if
			
				damId.color = statColor;
					
		}//end if
	
	}//end if
}//end function


function DrawStats(xOff, yOff) {
	if instance_exists(obj_player) == false then exit;

	var showHp = (obj_player.stats.hp / obj_player.stats.max_hp) * 100
	var showMp = (obj_player.stats.mp / obj_player.stats.max_mp) * 100
	var showFp = (obj_player.stats.fp / obj_player.stats.max_fp) * 100
	
	draw_text_hue(obj_camera.x + 8 + xOff, obj_camera.y + yOff, "HP", c_gold);
	draw_healthbar_box(obj_camera.x + 24 + xOff, obj_camera.y + yOff,obj_camera.x + 56 + xOff,c_ruby,c_gold,showHp);
	
	draw_text_hue(obj_camera.x + 64 + xOff, obj_camera.y + yOff, "MP", c_gold);	
	draw_healthbar_box(obj_camera.x + 80 + xOff,obj_camera.y +  yOff,obj_camera.x + 112 + xOff,c_ruby,c_gold, showMp);
	
	draw_text_hue(obj_camera.x + 120 + xOff,obj_camera.y +  yOff, "FP", c_gold);
	draw_healthbar_box(obj_camera.x + 136 + xOff,obj_camera.y + yOff,obj_camera.x + 168 + xOff,c_ruby,c_gold, showFp);


}


function DrawSetItems(xOff, yOff){
	if setItemIndex > -1 then {
		var selectedSetItem = setItems[setItemIndex];
	
		if is_undefined(selectedSetItem) == false then {
			draw_set_halign(fa_center);
				draw_text_hue(obj_camera.x + xOff + CAMERA_WIDTH div 2,obj_camera.y + yOff - 8 ,selectedSetItem.item.name, c_frost);
			draw_set_halign(fa_left);
		}//end if
	}//end if
	
    for (var setIndex = 0; setIndex < 8; setIndex += 1) {
	    var currentSetItem = setItems[setIndex];
		
		if is_undefined(currentSetItem) == false then {
			draw_sprite(spr_items, currentSetItem.item.iconSprite, obj_camera.x + xOff + setIndex * 24, obj_camera.y + yOff);
			if currentSetItem.uses > 1 then draw_text_hue(obj_camera.x + xOff + setIndex * 24 + 8, obj_camera.y + yOff + 8, currentSetItem.uses, c_white);
		}//end if
	}//end for
	
	if setItemIndex > -1 then {
		draw_sprite    (spr_menu_bracket, 0, obj_camera.x + xOff + setItemIndex * 24     , obj_camera.y + yOff);
		draw_sprite_ext(spr_menu_bracket, 0, obj_camera.x + xOff + setItemIndex * 24 + 16, obj_camera.y + yOff, -1, 1, 0, c_white,1);
		draw_sprite_ext(spr_menu_bracket, 0, obj_camera.x + xOff + setItemIndex * 24     , obj_camera.y + yOff + 16, 1, -1, 0, c_white,1);
		draw_sprite_ext(spr_menu_bracket, 0, obj_camera.x + xOff + setItemIndex * 24 + 16, obj_camera.y + yOff + 16, -1, -1, 0, c_white,1);
	}//end if
	
}


function FindFreeSetSlot(){
    for (var setIndex = 0; setIndex < 8; setIndex += 1) {
	    
		if is_undefined(setItems[setIndex]) then {
			 return setIndex;			
		}//end if
	}//end if	
		return -1;	
}//end function


function SetRoomTiles(width, height, roomData) {	
	_data = roomData.map;

	var buildingData = roomData.buildings
	
	var lay_id = layer_get_id("lay_collision");
	var map_id = layer_tilemap_get_id(lay_id);

	var lay_bg_id = layer_get_id("lay_background");
	var map_bg_id = layer_tilemap_get_id(lay_bg_id);
	
	var lay_fg_id = layer_get_id("lay_foreground");
	var map_fg_id = layer_tilemap_get_id(lay_fg_id);

	//BUILD WALL COLLISION
		for (var row = 0; row < height; row += 1) {
			for (var col = 0; col < width; col += 1) {
				var tileData = roomData.map[col, row];
		
				if tileData == TownTile.Wall {
					tilemap_set(map_id, 1, col, row);
				}//end if
								
		
				if tileData == TownTile.Grass {	
					if is_undefined(obj_stats.lastX) then {
						obj_stats.lastX = col * TILE_SIZE;
						obj_stats.lastY = row * TILE_SIZE;
					}//end if
					
					if instance_exists(obj_player) == false then {
						instance_create_depth(obj_stats.lastX , obj_stats.lastY,0,obj_player)	
					}else{
						obj_player.MoveTo(obj_stats.lastX , obj_stats.lastY);
					}//end if
				}//end if
			}//end for
		}//end for
	
	//DRAW GRASS AND STREETS
		for (var row = 0; row < height; row += 1) {
			for (var col = 0; col < width; col += 1) {
				var tileData = roomData.map[col, row];
				var cellX = col * 2;
				var cellY = row * 2;
				
				if tileData == TownTile.Grass {
					var tl = tile_set(28, false, false, false);
					var tr = tile_set(28, false, false, false);
					var bl = tile_set(28, false, false, false);
					var br = tile_set(28, false, false, false);
					
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if
		
				if tileData == TownTile.StreetEW or tileData == TownTile.StreetNS {
					var tl = tile_set(27, false, false, false);
					var tr = tile_set(27, false, false, false);
					var bl = tile_set(27, false, false, false);
					var br = tile_set(27, false, false, false);
					
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				}//end if
			}//end for
		}//end for
	
	//WALLS
		for (var row = 0; row < height; row += 1) {
			for (var col = 0; col < width; col += 1) {
				var wallData   = tilemap_get(map_id, col + 0, row + 0) == TownTile.Wall;
				var wallDataN  = tilemap_get(map_id, col + 0, row - 1) == TownTile.Wall;
				var wallDataS  = tilemap_get(map_id, col + 0, row + 1) == TownTile.Wall;
			
				var cellX = col * 2;
				var cellY = row * 2;
						
				//WALL FRONTS
				if wallData then {
					var tl = tile_set(52, false, false, false);
					var tr = tile_set(53, false, false, false);
					var bl = tile_set(52, false, false, false);
					var br = tile_set(53, false, false, false);
					
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR
				
					if not wallDataN then {
						var tl = tile_set(52, false, false, false);
						var tr = tile_set(53, false, false, false);
						var bl = tile_set(64, false, false, false);
						var br = tile_set(65, false, false, false);
					
						tilemap_set(map_fg_id,tl,cellX + 0,cellY - 1);//TL
						tilemap_set(map_fg_id,tr,cellX + 1,cellY - 1);//TR
				
					}				
				
					if not wallDataS then {
						var tl = tile_set(64, false, false, false);
						var tr = tile_set(65, false, false, false);
						var bl = tile_set(64, false, false, false);
						var br = tile_set(65, false, false, false);
					
						tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
						tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
						tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
						tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR					
					}
				}//end if
			}//end for
		}//end for

	//DRAW BUILDINGS
		for (index = 0; index < array_length(buildingData); index += 1){
			var currentBuilding = buildingData[index];
			currentBuilding.Render(map_bg_id, map_fg_id, map_id);
		}//end if
		
	//DRAW GRASS TRIM	
		for (var row = 1; row < height - 1; row += 1) {
			for (var col = 1; col < width - 1; col += 1) {
				var wallData   = _data[ col + 0, row + 0] == TownTile.Grass or _data[ col + 0, row + 0] == TownTile.Wall;
				var wallDataNW = _data[ col - 1, row - 1] == TownTile.Grass or _data[ col - 1, row - 1] == TownTile.Wall;
				var wallDataN  = _data[ col - 1, row + 0] == TownTile.Grass or _data[ col - 1, row + 0] == TownTile.Wall;
				var wallDataNE = _data[ col - 1, row + 1] == TownTile.Grass or _data[ col - 1, row + 1] == TownTile.Wall;
				var wallDataE  = _data[ col + 0, row + 1] == TownTile.Grass or _data[ col + 0, row + 1] == TownTile.Wall;
				var wallDataSE = _data[ col + 1, row + 1] == TownTile.Grass or _data[ col + 1, row + 1] == TownTile.Wall;
				var wallDataS  = _data[ col + 1, row + 0] == TownTile.Grass or _data[ col + 1, row + 0] == TownTile.Wall;
				var wallDataSW = _data[ col + 1, row - 1] == TownTile.Grass or _data[ col + 1, row - 1] == TownTile.Wall;
				var wallDataW  = _data[ col + 0, row - 1] == TownTile.Grass or _data[ col + 0, row - 1] == TownTile.Wall;
		
				var tileValue = 0;
		
				tileValue += wallData   * 0x001;
				tileValue += wallDataNW * 0x002;
				tileValue += wallDataN  * 0x004;
				tileValue += wallDataNE * 0x008;
				tileValue += wallDataE  * 0x010;
				tileValue += wallDataSE * 0x020;
				tileValue += wallDataS  * 0x040;
				tileValue += wallDataSW * 0x080;
				tileValue += wallDataW  * 0x100;
		
				var cellX = col * 2;
				var cellY = row * 2;
				
				
				
				#region OLD WAY
					//CORNER GRASS TOP LEFT
					if array_contains([017,065,081,113],tileValue) then {
						var tl = tile_set(27, false, false, false);
						var tr = tile_set(43, false, false, false);
						var bl = tile_set(43, false, false, false);
						//var br = tile_set(43, false, true, false);
					
						tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					    tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
						tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
						//tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
					}//end if
				
					//CORNER GRASS BOTTOM LEFT
					if array_contains([193,449,451],tileValue) then {
						var tl = tile_set(43, false, true, false);
						//var tr = tile_set(43, true, false, true);
						var bl = tile_set(27, false, false, false);
						var br = tile_set(43, false, true, false);
					
						tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
						//tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
						tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
						tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
					}//end if
				
					//CORNER GRASS BOTTOM RIGHT
					if array_contains([391,271,263],tileValue) then {
						//var tl = tile_set(43, true, false, false);
						var tr = tile_set(43, true, false, true);
						var bl = tile_set(43, true, false, true);
						var br = tile_set(27, false, false, false);
					
						//tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
						tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
						tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
						tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
					}//end if
				
					//CORNER GRASS BOTTOM 
					if array_contains([257],tileValue) then {
						var tl = tile_set(43, true, true, true);
						var tr = tile_set(43, true, false, true);
						var bl = tile_set(27, true, false, true);
						var br = tile_set(27, false, false, false);
					
						tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
						tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
						tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
						tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
					}//end if
								
					//CORNER GRASS TOP RIGHT
					if array_contains([013,021,005,029],tileValue) then {
						var tl = tile_set(43, true, false, false);
						var tr = tile_set(27, false, false, false);
						//var bl = tile_set(31, true, false, false);
						var br = tile_set(43, false, false, true);
					
						tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
						tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
						//tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
						tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
					}//end if
								
					//GRASS ALONG LEFT			
					if array_contains([467,403,499,121,507,497,505,249,401],tileValue) then {
						var tl = tile_set(31, true, false, false);
						//var tr = tile_set(31, false, false, false);
						var bl = tile_set(31, true, false, false);
						//var br = tile_set(31, false, false, false);
					
						tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
						//tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
						tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
						//tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
					}//end if
											
					//GRASS ALONG RIGHT			
					if array_contains([399,275,407,415,447,287,319],tileValue) then {
						//var tl = tile_set(32, false, false, false);
						var tr = tile_set(31, false, false, false);
						//var bl = tile_set(31, false, false, true);
						var br = tile_set(31, false, false, false);
					
						//tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
						tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
						//tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
						tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
					}//end if
				
					//GRASS ALONG BOTTOM
					if array_contains([453,481,483,487,463,455,109,495],tileValue) then {
						//var tl = tile_set(32, false, false, false);
						//var tr = tile_set(01, false, true, false);
						var bl = tile_set(31, false, false, true);
						var br = tile_set(31, false, false, true);
					
						//tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
						//tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
						tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
						tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
					}//end if
				
					//GRASS ALONG TOP			
					if array_contains([031,245,103,205,095,079,229,253,127,125,197,093,117,069,071,101,085,077],tileValue) then {
						var tl = tile_set(31, true, false, true);
						var tr = tile_set(31, true, false, true);
						//var bl = tile_set(31, false, false, true);
						//var br = tile_set(31, false, false, true);
					
						tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
						tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
						//tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
						//tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
					}//end if
				#endregion
			}//end for
		}//end for
	
	//RANDOM GRASS AND FLOWERS GRASS TRIM	
		for (var row = 0; row < height  * 2 - 1; row += 1) {
			for (var col = 0; col < width * 2 - 1; col += 1) {
				


				//SET BUSHES
					if col mod 2 == 0 and row mod 2 == 0 {
						var tileNE = tilemap_get(map_bg_id, col, row)         == 28;
						var tileNW = tilemap_get(map_bg_id, col + 1, row)     == 28;
						var tileSE = tilemap_get(map_bg_id, col, row + 1)     == 28;
						var tileSW = tilemap_get(map_bg_id, col + 1, row + 1) == 28;
						
						var allGrass = tileNE and tileNW and tileSE and tileSW;
						
						if allGrass and irandom(100) < 10 then {
							 tilemap_set(map_bg_id, 34, col, row)        ;//bush
							 tilemap_set(map_bg_id, 35, col + 1, row)    ;//bush
							 tilemap_set(map_bg_id, 46, col, row + 1)    ;//bush
							 tilemap_set(map_bg_id, 47, col + 1, row + 1);//bush
							 		 
							 tilemap_set(map_id, 1, col div 2, row div 2);//collision	 
						}//end if					
					}//end if
					
				//SET TREES
					if col mod 4 == 0 and row mod 4 == 0 {						
						var tileNE = tilemap_get(map_bg_id, col, row)         == 28;
						var tileNW = tilemap_get(map_bg_id, col + 1, row)     == 28;
						var tileSE = tilemap_get(map_bg_id, col, row + 1)     == 28;
						var tileSW = tilemap_get(map_bg_id, col + 1, row + 1) == 28;
						
						var allGrass = tileNE and tileNW and tileSE and tileSW;						
									
						if allGrass and irandom(100) < 10 then {
							//COLLISION
								tilemap_set(map_id, 1, col div 2, row div 2);
								
							//SET TRUNK								
								var tl = tile_set(59, false, false, false);
								var tr = tile_set(59, true, false, false);
								var bl = tile_set(71, false, false, false);
								var br = tile_set(71, true, false, false);
					
								tilemap_set(map_bg_id,tl,col + 0,row + 0);//TL
								tilemap_set(map_bg_id,tr,col + 1,row + 0);//TR
								tilemap_set(map_bg_id,bl,col + 0,row + 1);//BL
								tilemap_set(map_bg_id,br,col + 1,row + 1);//BR		
											 						
							//SET LEAVES ON LEFT
								tl = tile_set(58, false, false, false);
								bl = tile_set(70, false, false, false);	
								
								if tilemap_get(map_fg_id,col - 1,row + 0) == 0 then tilemap_set(map_fg_id,tl,col - 1,row + 0);//TL
								if tilemap_get(map_fg_id,col - 1,row + 1) == 0 then tilemap_set(map_fg_id,bl,col - 1,row + 1);//BL
								
								tl = tile_set(56, false, false, false);
								tr = tile_set(57, false, false, false);
								bl = tile_set(68, false, false, false);
								br = tile_set(69, false, false, false);	
								
								if tilemap_get(map_fg_id,col - 1,row - 2) == 0 then tilemap_set(map_fg_id,tl,col - 1,row - 2);//TL
								if tilemap_get(map_fg_id,col + 0,row - 2) == 0 then tilemap_set(map_fg_id,tr,col + 0,row - 2);//TR
								if tilemap_get(map_fg_id,col - 1,row - 1) == 0 then tilemap_set(map_fg_id,bl,col - 1,row - 1);//BL
								if tilemap_get(map_fg_id,col + 0,row - 1) == 0 then tilemap_set(map_fg_id,br,col + 0,row - 1);//BR
								
							//SET LEAVES ON RIGHT
								tr = tile_set(58, true, false, false);
								br = tile_set(70, true, false, false);	
								
								if tilemap_get(map_fg_id,col + 2,row + 0) == 0 then tilemap_set(map_fg_id,tr,col + 2,row + 0);//TL
								if tilemap_get(map_fg_id,col + 2,row + 1) == 0 then tilemap_set(map_fg_id,br,col + 2,row + 1);//BL
								
								tr = tile_set(56, true, false, false);
								tl = tile_set(57, true, false, false);
								br = tile_set(68, true, false, false);
								bl = tile_set(69, true, false, false);	
									
								if tilemap_get(map_fg_id,col + 1,row - 2) == 0 then tilemap_set(map_fg_id,tl,col + 1,row - 2);//TL
								if tilemap_get(map_fg_id,col + 2,row - 2) == 0 then tilemap_set(map_fg_id,tr,col + 2,row - 2);//TR
								if tilemap_get(map_fg_id,col + 1,row - 1) == 0 then tilemap_set(map_fg_id,bl,col + 1,row - 1);//BL
								if tilemap_get(map_fg_id,col + 2,row - 1) == 0 then tilemap_set(map_fg_id,br,col + 2,row - 1);//BR									
						}//end if				
					}//end if
				
				//SET HIGH GRASS AND FLOWERS
					var tileIndex   = tilemap_get(map_bg_id, col, row);
					var isGrassTile = tileIndex == 28;
					var newTile     = 28;
					
					if isGrassTile then {
						if irandom(100) < 15 then {
							if irandom(100) < 20 then {
								newTile = tile_set(choose(32,33,44,45), choose(true, false), false, false);//leafy grass
							}else{
								newTile = tile_set(40, choose(true, false), false, false);//leafy grass
							}//end if
					
							tilemap_set(map_bg_id,newTile,col,row);						
						}//end if
					}//end if
			}//end for
		}//end for
	
}//end function


function SetDungeonTiles(width, height, roomData) {	
	_data[height][width] = undefined;

	var lay_id = layer_get_id("lay_collision");
	var map_id = layer_tilemap_get_id(lay_id);

	var lay_bg_id = layer_get_id("lay_background");
	var map_bg_id = layer_tilemap_get_id(lay_bg_id);

	//COLLISION
	for (var row = 0; row < height; row += 1) {
		for (var col = 0; col < width; col += 1) {
			var tileData = roomData[row, col];
		
			if tileData == Tile.RoomWall or tileData == Tile.CorridorWall or tileData == Tile.Unused {
				tilemap_set(map_id, 1, row, col);
			}//end if
		
			if tileData == Tile.Floor {
			
				if instance_exists(obj_player) == false {
				    instance_create_layer(row * 16,col * 16,"lay_instances",obj_player);	
				}else{				
					obj_player.MoveTo(row * 16,col * 16);				
				}//end if
			
				tilemap_set(map_id, 4, row, col);
			}//end if
		
			if tileData == Tile.CorridorFloor {
				tilemap_set(map_id, 5, row, col);
			}//end if
		
			if tileData == Tile.ClosedDoor {
				tilemap_set(map_id, 7, row, col);
			}//end if
		
			if tileData == Tile.OpenDoor {
				tilemap_set(map_id, 6, row, col);
			}//end if
		}//end for
	}//end for

	//WALLS
	for (var row = 0; row < height; row += 1) {
		for (var col = 0; col < width; col += 1) {
			var wallData   = tilemap_get(map_id, row + 0, col + 0) == 1;
			var wallDataNW = tilemap_get(map_id, row - 1, col - 1) == 1;
			var wallDataN  = tilemap_get(map_id, row - 1, col + 0) == 1;
			var wallDataNE = tilemap_get(map_id, row - 1, col + 1) == 1;
			var wallDataE  = tilemap_get(map_id, row + 0, col + 1) == 1;
			var wallDataSE = tilemap_get(map_id, row + 1, col + 1) == 1;
			var wallDataS  = tilemap_get(map_id, row + 1, col + 0) == 1;
			var wallDataSW = tilemap_get(map_id, row + 1, col - 1) == 1;
			var wallDataW  = tilemap_get(map_id, row + 0, col - 1) == 1;
		
			var tileValue = 0;
		
			tileValue += wallData   * 0x001;
			tileValue += wallDataNW * 0x002;
			tileValue += wallDataN  * 0x004;
			tileValue += wallDataNE * 0x008;
			tileValue += wallDataE  * 0x010;
			tileValue += wallDataSE * 0x020;
			tileValue += wallDataS  * 0x040;
			tileValue += wallDataSW * 0x080;
			tileValue += wallDataW  * 0x100;
		
			var cellX = row * 2;
			var cellY = col * 2;

			//blackout
			if tileValue = 511 then {
				var tl = tile_set(32, false, false, false);
				var tr = tile_set(32, false, false, false);
				var bl = tile_set(32, false, false, false);
				var br = tile_set(32, false, false, false);
					
				tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
			}//end if
		
			// *
			//  
			if tileValue == 383 || tileValue == -113 then {
				var tl = tile_set(32, false, false, false);
				var tr = tile_set(01, false, true, false);
				var bl = tile_set(32, false, false, false);
				var br = tile_set(32, false, false, false);
					
				tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
			}//end if
		
			//*
			//  
			if tileValue == 509 || tileValue == -113 then {
				var tl = tile_set(01, true, true, false);
				var tr = tile_set(32, false, false, false);
				var bl = tile_set(32, false, false, false);
				var br = tile_set(32, false, false, false);
					
				tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
			}//end if
		
			//* *
			//* *  
			if tileValue == 475 ||  tileValue == 283 || tileValue == 279 || tileValue == 305 || tileValue == 273 || tileValue == 465 || tileValue == 401 then {
				var tl = tile_set(08, false, false, true);
				var tr = tile_set(08, false, true, true);
				var bl = tile_set(08, false, false, true);
				var br = tile_set(08, false, true, true);
					
				tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
			}//end if
		
			//**
			//
			//**  
			if tileValue == -1 || tileValue == -1 then {
				var tl = tile_set(08, false, true, false);
				var tr = tile_set(08, false, true , false);
				var bl = tile_set(08, false, false, false);
				var br = tile_set(08, false, false , false);
					
				tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
			}//end if
				

			//**
			//*
			if tileValue == 119 || tileValue == 241 || tileValue == 121 || tileValue == 113 then {
				var tl = tile_set(09, true, true, false);
				var tr = tile_set(08, false, true, false);
				var bl = tile_set(08, true, false, true);
				var br = tile_set(32, false, false, false);
					
				tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
			}//end if
			
			//**
			// *
			if tileValue == 031 || tileValue == 029 || tileValue == 61 then {
				var tl = tile_set(08, false, true, false);
				var tr = tile_set(09, false, true, false);
				var bl = tile_set(32, true, false, true);
				var br = tile_set(08, false, true, true);
					
				tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
			}//end if
		
			//**
			//** wall
			if tileValue == 367 || tileValue == 481 || tileValue == 257 || tileValue == 271 || tileValue == 391 || tileValue == 487 || tileValue == 449 || tileValue == 463 || tileValue == 399 || tileValue == 495  || tileValue == 483  || tileValue == 451  || tileValue == 455 || tileValue == 263 then {
				//var tr = tile_set_rotate(08,true);
				//var tr = tile_set_flip(tr,true);
					
				tilemap_set(map_bg_id,02,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,03,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,10,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,11,cellX + 1,cellY + 1);//BR		
			}//end if

			//
			// *
			if tileValue == -1 then {			
				tilemap_set(map_bg_id,32,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,32,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,32,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,01,cellX + 1,cellY + 1);//BR		
			}//end if
		
			// *
			// *
			if tileValue == 285 || tileValue == 447 || tileValue == 479 || tileValue == 319 || tileValue == 415 || tileValue == 287 then {
				var tr = tile_set_rotate(08,true);
				var tr = tile_set_flip(tr,true);
				var br = tile_set_rotate(08,true);
				var br = tile_set_flip(tr,true);
					
				tilemap_set(map_bg_id,32,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,32,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
			}//end if
		
			//* 
			//*
			if tileValue == 507 ||tileValue == 499 || tileValue == 505 || tileValue == 503 || tileValue == 497 then {
				var tl = tile_set(08, true, false, true);
				var tr = tile_set(32, false, false, false);
				var bl = tile_set(08, true, false, true);
				var br = tile_set(32, false, false, false);
					
				tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
			}//end if
						
			//** 
			//
			if tileValue == 199 || tileValue == 117 || tileValue == 255 || tileValue == 253 || tileValue == 125 || tileValue == 127 then {
				var tl = tile_set(08, false, true, false);
				var tr = tile_set(08, false, true, false);
				var bl = tile_set(32, false, false, false);
				var br = tile_set(32, false, false, false);
					
				tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
			}//end if
		
			//1 8 
			//  8
			if tileValue == 413 then {
				var tl = tile_set(01, true, true , false );
				var tr = tile_set(08, false, true , true );
				var bl = tile_set(32, false, false, false);
				var br = tile_set(08, false, true , true );
					
				tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
			}//end if
		
			//8 1
			//8 
			if tileValue == 375 then {
				var tl = tile_set(08, true, false, true);
				var tr = tile_set(01, false, true, false);
				var bl = tile_set(08, true, false, true);
				var br = tile_set(32, false, false, false);
					
				tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
				tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
				tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
				tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
			}//end if
		
		
		

		}//end for
	}//end for


	//FLOORS
	for (var row = 0; row < height; row += 1) {
		for (var col = 0; col < width; col += 1) {
			var floorTile         = tilemap_get(map_id, row + 0, col + 0) == 4;
			var hallTileIndex     = tilemap_get(map_id, row + 0, col + 0);
			var shadowfloorTile   = tilemap_get(map_id, row + 0, col - 1) == 1;

			var cellX = row * 2;
			var cellY = col * 2;		

			//floor tile
				if floorTile then {
					var tl = tile_set(06, false, false, false);
					var tr = tile_set(07, false, false, false);
					var bl = tile_set(14, false, false, false);
					var br = tile_set(15, false, false, false);
			
					if shadowfloorTile then {
						 tl = tile_set(16, false, false, false);
						 tr = tile_set(17, false, false, false);				
					}//end if
					
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
				}//end if
			
			//hall tile
				if hallTileIndex == 5 or hallTileIndex == 6 or hallTileIndex == 7 then {
					var tl = tile_set(22, false, false, false);
					var tr = tile_set(23, false, false, false);
					var bl = tile_set(30, false, false, false);
					var br = tile_set(31, false, false, false);
								
					tilemap_set(map_bg_id,tl,cellX + 0,cellY + 0);//TL
					tilemap_set(map_bg_id,tr,cellX + 1,cellY + 0);//TR
					tilemap_set(map_bg_id,bl,cellX + 0,cellY + 1);//BL
					tilemap_set(map_bg_id,br,cellX + 1,cellY + 1);//BR		
				}//end if
			
			//hall tile
				if hallTileIndex == 7 then {
					//instance_create_depth(272,688,-room_height,obj_door);
					instance_create_depth(row * TILE_SIZE,col * TILE_SIZE,-room_height,obj_door);
				}//end if

		}//end for
	}//end for

}//end function