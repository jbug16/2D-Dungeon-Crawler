

function AttackData() constructor {
	source = undefined;
	target = undefined ;
	attackType = ATTACK_TYPE_NULL;
	attackWaitTime = 45;
	attackSpellData = undefined;
	attackThrowData = undefined;
	selfUseData = undefined;
}//end function

function Point(newX, newY) constructor {
	x = newX;
	y = newY;	
}//end if

function Spell() constructor {
	name		   = "";
	spellPower	   = 1;
	targetType	   = 0;	  
	mpCost	       = 0;	  
	hitPercent	   = 0; 
	element		   = ELE_NULL 
	statusEffect   = STATUS_NULL
	description	   = ""
	travelSequence = undefined;
	hitSequence    = undefined;
}//end if

function InventorySlot() constructor{
	itemId = ITEM_EMPTY;
	count  = 0;
}//end if

function Inventory() constructor {
	_itemData = [];
	_spellData = [];

	#region LOAD ITEM DATA
		var LoadItemData = function() {

			#region HELPERS
				var GetIconByType = function( itemType) {				
					if (itemType & ITEM_TYPE_SWORD	    ) > 0 then return ICO_SWORD;
					if (itemType & ITEM_TYPE_SPEAR	    ) > 0 then return ICO_SPEAR;
					if (itemType & ITEM_TYPE_SHIELD	    ) > 0 then return ICO_SHIELD;
					if (itemType & ITEM_TYPE_WHIP	    ) > 0 then return ICO_WHIP;
					if (itemType & ITEM_TYPE_HELMET	    ) > 0 then return ICO_HELMET;
					if (itemType & ITEM_TYPE_AXE	    ) > 0 then return ICO_AXE	;
					if (itemType & ITEM_TYPE_THROW	    ) > 0 then return ICO_THROW;
					if (itemType & ITEM_TYPE_BOW	    ) > 0 then return ICO_BOW	;
					if (itemType & ITEM_TYPE_ARMOR	    ) > 0 then return ICO_ARMOR;
					if (itemType & ITEM_TYPE_RING       ) > 0 then return ICO_SPECIAL;
					if (itemType & ITEM_TYPE_POTION     ) > 0 then return ICO_POTION;	
					if (itemType & ITEM_TYPE_SPELL      ) > 0 then return ICO_BOOK;
					
					if (itemType & ITEM_TYPE_KATANA   ) > 0 then return ICO_KATANA;
					if (itemType & ITEM_TYPE_STAFF    ) > 0 then return ICO_STAFF;
					if (itemType & ITEM_TYPE_BOW      ) > 0 then return ICO_BOW;
					if (itemType & ITEM_TYPE_CLAW     ) > 0 then return ICO_CLAW;
					
					if (itemType & ITEM_TYPE_CROSSBOW ) > 0 then return ICO_CROSSBOW;
					if (itemType & ITEM_TYPE_HAMMER   ) > 0 then return ICO_HAMMER;
					if (itemType & ITEM_TYPE_ROD      ) > 0 then return ICO_ROD;
					if (itemType & ITEM_TYPE_SCYTHE   ) > 0 then return ICO_SCYTHE;
					
					return "";
				}//end if	
			
				var TypeToString = function( itemType) {
					if (itemType & ITEM_TYPE_SWORD	) > 0 then return "SWORD";
					if (itemType & ITEM_TYPE_SPEAR	) > 0 then return "SPEAR";
					if (itemType & ITEM_TYPE_SHIELD	) > 0 then return "SHIELD";
					if (itemType & ITEM_TYPE_WHIP	) > 0 then return "WHIP";
					if (itemType & ITEM_TYPE_HELMET	) > 0 then return "HELMET";
					if (itemType & ITEM_TYPE_AXE	) > 0 then return "AXE"	;
					if (itemType & ITEM_TYPE_THROW	) > 0 then return "THROW";
					if (itemType & ITEM_TYPE_BOW	) > 0 then return "BOW"	;
					if (itemType & ITEM_TYPE_ARMOR	) > 0 then return "ARMOR";
					if (itemType & ITEM_TYPE_RING   ) > 0 then return "SPECIAL";
					if (itemType & ITEM_TYPE_POTION ) > 0 then return "POTION";	
					if (itemType & ITEM_TYPE_SPELL ) > 0 then return "SPELL";
					
					if (itemType & ITEM_TYPE_SPELL ) > 0 then return "SPELL";
					if (itemType & ITEM_TYPE_KATANA    ) > 0 then return "KATANA";
					if (itemType & ITEM_TYPE_KNIFE     ) > 0 then return "KNIFE";  
					if (itemType & ITEM_TYPE_BOW       ) > 0 then return "BOW";
					if (itemType & ITEM_TYPE_HAMMER    ) > 0 then return "HAMMER";
					if (itemType & ITEM_TYPE_ROD       ) > 0 then return "ROD";
					if (itemType & ITEM_TYPE_HARP      ) > 0 then return "HARP";      
					if (itemType & ITEM_TYPE_TOOL      ) > 0 then return "TOOL";
					if (itemType & ITEM_TYPE_CLAW      ) > 0 then return "CLAW"; 
					if (itemType & ITEM_TYPE_STAFF     ) > 0 then return "STAFF"; 
					if (itemType & ITEM_TYPE_ROBE      ) > 0 then return "ROBE";
					if (itemType & ITEM_TYPE_BELL      ) > 0 then return "BELL";
					if (itemType & ITEM_TYPE_GLOVE     ) > 0 then return "GLOVE";  
					if (itemType & ITEM_TYPE_ARROW     ) > 0 then return "ARROW";
					if (itemType & ITEM_TYPE_BOOK      ) > 0 then return "BOOK";
					if (itemType & ITEM_TYPE_NUNCHAKU  ) > 0 then return "NUNCHAKU";
					if (itemType & ITEM_TYPE_BOOMERANG ) > 0 then return "BOOMERANG";
					if (itemType & ITEM_TYPE_CROSSBOW  ) > 0 then return "CROSSBOW ";
					if (itemType & ITEM_TYPE_BOLT      ) > 0 then return "BOLT";
					if (itemType & ITEM_TYPE_SCYTHE    ) > 0 then return "SCYTHE";
					if (itemType & ITEM_TYPE_PICKAXE   ) > 0 then return "PICKAXE";	
    					
					return "";
				}//end if	
	
				var process_combined_bitfield = function(str, delimiter) {
					que_values = ds_queue_create();
					var p = string_pos(delimiter, str);
					var dl = string_length(delimiter);
					var return_value = 0;

					if (dl) while (p) {
					    p -= 1;
					    ds_queue_enqueue(que_values, real(string_copy(str, 1, p)));
					    str = string_delete(str, 1, p + dl);
					    p = string_pos(delimiter, str);
					}//end if

					ds_queue_enqueue(que_values, real(str));

					while (not ds_queue_empty(que_values)) {
						return_value = return_value | ds_queue_dequeue(que_values);
					}//end while

					ds_queue_destroy(que_values);

					//print ("processed combined field");
					return return_value;
				}//end subfunction
			#endregion
		
			var inFile  = file_text_open_read(working_directory + "items.csv");
			var line    = file_text_readln(inFile);//consume header
			var rowData = [];
			count       = 1;
		
			_itemData[0] = new Item();
			_itemData[0].name = "Nothing";
			_itemData[0].iconSprite = 0;
		
			
			while (! file_text_eof(inFile)) {
			    line    = file_text_readln(inFile);
				line    = string_trim(line);
				rowData = string_split(line, ",");
					
				var attack		   = real(rowData[01]);
				var defense		   = real(rowData[02]);
				var magic		   = real(rowData[03]);
				var hit			   = real(rowData[04]);
				var evade		   = real(rowData[05]);
				var luck		   = real(rowData[06]);
				var maxHp		   = real(rowData[07]);
				var maxMp		   = real(rowData[08]);
				var maxFp		   = real(rowData[09]);
				var hpRecoverRate  = real(rowData[10]);
				var mpRecoverRate  = real(rowData[11]);
				var fpRecoverRate  = real(rowData[12]);
				var element		   = process_combined_bitfield(rowData[13], ";");
				var eleStrong	   = process_combined_bitfield(rowData[14], ";");
				var eleWeak		   = process_combined_bitfield(rowData[15], ";");
				var eleImmune	   = process_combined_bitfield(rowData[16], ";");
				var eleAbsorb	   = process_combined_bitfield(rowData[17], ";");
				var statusImmune   = process_combined_bitfield(rowData[18], ";");
				var statusInflict  = process_combined_bitfield(rowData[19], ";");
				var statusCause	   = process_combined_bitfield(rowData[20], ";");
				var class		   = process_combined_bitfield(rowData[21], ";");
				var type		   = process_combined_bitfield(rowData[22], ";");
				var killerType	   = process_combined_bitfield(rowData[23], ";");
				var sprite		   = real(rowData[24]);
				var description	   = rowData[25];
			
				var equipJob	   = process_combined_bitfield(rowData[26], ";");
				var equipSex	   = process_combined_bitfield(rowData[27], ";");
				var spell	       = real(rowData[28]);
				var spellHit	   = real(rowData[29]);
				var spellMult      = real(rowData[30]);
				var uses    	   = real(rowData[31]);
				var weaponSprite   = asset_get_index(rowData[32]);
			
				var name		                 = GetIconByType(type) + rowData[00];
				_itemData[count]                 = new Item();
				_itemData[count].name            = name;
				_itemData[count].att             = attack;
				_itemData[count].def             = defense;
				_itemData[count].mag             = magic;
				_itemData[count].hit             = hit;
				_itemData[count].evd             = evade;
				_itemData[count].luk             = luck;
				_itemData[count].max_hp	         = maxHp;
				_itemData[count].max_mp	         = maxMp;
				_itemData[count].max_fp	         = maxFp;
				_itemData[count].recoverHpRate   = hpRecoverRate;
				_itemData[count].recoverMpRate   = mpRecoverRate;
				_itemData[count].recoverFpRate   = fpRecoverRate;
				_itemData[count].element         = element;
				_itemData[count].eleStrong       = eleStrong;
				_itemData[count].eleWeak         = eleWeak;
				_itemData[count].eleImmune       = eleImmune;
				_itemData[count].statusImmune    = statusImmune;
				_itemData[count].statusInflict   = statusInflict;
				_itemData[count].statusCause     = statusCause;
				_itemData[count].class           = class;
				_itemData[count].type            = type;
				_itemData[count].killerType      = killerType;
				_itemData[count].iconSprite      = sprite;
				_itemData[count].description     = description;
				_itemData[count].equipJob	     = equipJob;
				_itemData[count].equipSex	     = equipSex;
				_itemData[count].spell	         = spell;
				_itemData[count].spellHit	     = spellHit;
				_itemData[count].id	             = count;
				_itemData[count].uses	         = uses;
				_itemData[count].spellMultiplier = spellMult;
				_itemData[count].weaponSprite    = weaponSprite;
				
				var typeName   = string_upper(TypeToString(type))
				var itemName   = string_replace_all(string_upper(rowData[00]), " ", "");
				var itemNumber = string(count);
				
				print("macro# ITEM_" + itemName + "_" + typeName + " " + itemNumber);
				count += 1;
			}//end while
			
			file_text_close(inFile);
		}//end function
	
		LoadItemData();
	#endregion

	#region LOAD SPELL DATA
		var LoadSpellData = function() {

			#region HELPERS	
				var process_combined_bitfield = function(str, delimiter) {
					que_values = ds_queue_create();
					var p = string_pos(delimiter, str);
					var dl = string_length(delimiter);
					var return_value = 0;

					if (dl) while (p) {
					    p -= 1;
					    ds_queue_enqueue(que_values, real(string_copy(str, 1, p)));
					    str = string_delete(str, 1, p + dl);
					    p = string_pos(delimiter, str);
					}//end if

					ds_queue_enqueue(que_values, real(str));

					while (not ds_queue_empty(que_values)) {
						return_value = return_value | ds_queue_dequeue(que_values);
					}//end while

					ds_queue_destroy(que_values);

					//print ("processed combined field");
					return return_value;
				}//end subfunction
			#endregion
		
			var inFile  = file_text_open_read(working_directory + "spells.csv");
			var line    = string_trim(file_text_readln(inFile));//consume header
			var rowData = [];
			count       = 1;
		
			_spellData[0] = new Spell();
			_spellData[0].name = "";
		
			//file_text_readln(inFile);//consume header row
			
			while (! file_text_eof(inFile)) {
			    line    = string_trim(file_text_readln(inFile));
				rowData = string_split(line, ",");
					
				var name		   = rowData[00];
				var spellPower	   = real(rowData[01]);
				var mpCost		   = real(rowData[02]);
				var hitPercent	   = real(rowData[03]);
				var element		   = process_combined_bitfield(rowData[04],";");
				var statusEffect   = process_combined_bitfield(rowData[05],";");
				var description	   = rowData[06];
				var travelSequence = asset_get_index(rowData[07]);
				var hitSequence	   = asset_get_index(rowData[08]);



				_spellData[count] = new Spell();
				_spellData[count].name		      = name;		
				_spellData[count].spellPower	  = spellPower;		 
				_spellData[count].mpCost		  = mpCost;				 
				_spellData[count].hitPercent	  = hitPercent;	 
				_spellData[count].element		  = element;			 
				_spellData[count].statusEffect    = statusEffect;	 
				_spellData[count].description	  = description;		 
				_spellData[count].travelSequence  = travelSequence;		 
				_spellData[count].hitSequence	  = hitSequence;		 
				
				//print(line);
			
				var spellName = string_upper(rowData[00]);
				var spellNumber = string(count);
					
				print("macro# SPELL_" + spellName + " " + spellNumber);
				count += 1;
			}//end while
			
			file_text_close(inFile);
		}//end function
	
		LoadSpellData();
	#endregion






	AddItem = function(itemId) {
		var newSlot = new InventorySlot()
		newSlot.itemId = itemId;
		newSlot.count  = 1;	
		slots.Add(newSlot);
	}//end function
	
	#region SLOTS
		slots = new List();
	#endregion	

	GetAllItems = function() {
		var items = new List();
		
		for (var i = 0; i < slots.count; ++i) {
		    var slotItem = GetSlotItemsData(i);
			items.Add(slotItem);
		}//end for
		
		return items;
	}//end function

	GetItemsOfClass = function(itemClass) {
		var itemsOfClass = new List();
		
		for (var i = 0; i < slots.count; ++i) {
		    var slotItem = GetSlotItemsData(i);
			if slotItem.IsClass(itemClass) then {
				itemsOfClass.Add(slotItem);
			}//end if
		}//end for
		
		return itemsOfClass;
	}//end function

	GetItemsData = function(itemId) {
		return _itemData[itemId];
	}//end function
	
	GetSlotItemsData = function(slotIndex) {
		var slotData = slots.Get(slotIndex);
		var data = GetItemsData(slotData.itemId);
		return data;
	}//end function	
	
    AddAllItems = function() {
		for (var i = 1; i < MAX_ITEM_COUNT; ++i) {
		    AddItem(i);
		}//end for
	}//end function

	GetSpellData = function(spellId) {
		return _spellData[spellId];
	}//end function

	RemoveItemInSlot = function(slotIndex) {
		if slotIndex < slots.count then {
			slots.RemoveAt(slotIndex);//.count -= 1; //Get(slotIndex);	
		}//end if
	}//end function
	
	InventoryIsEmpty = function() {
		return slots.count <= 0;
	}//end function
	
}//end onstructor

function Item() constructor {
	name            = "";
	id              = 0;
	att             = 0;
	def             = 0;
	hit             = 0;
	evd             = 0;
	luk             = 0;
	max_hp	        = 0;
	max_mp	        = 0;
	max_fp	        = 0;	
	description	    = "";
	equipJob	    = JOB_ANY;
	equipSex	    = SEX_ANY;
				    
	recoverHpRate   = 0;
	recoverMpRate   = 0;
	recoverFpRate   = 0;
				    
	element         = ELE_NULL;
	eleStrong       = ELE_NULL;
	eleWeak         = ELE_NULL;
	eleImmune       = ELE_NULL;
	eleAbsorb       = ELE_NULL;
				    
	statusImmune    = STATUS_NULL;
	statusInflict   = STATUS_NULL;
	statusCause     = STATUS_NULL;     //wearing item caauses this status
				    
	class           = ITEM_CLASS_NULL; //weapon armor etc
	type            = ITEM_TYPE_NULL;  //potion sword, bow, etc
	killerType      = ACTOR_TYPE_NULL;
	iconSprite      = undefined
    weaponSprite    = spr_null;
	
	equipJob	    = JOB_ANY;
	equipSex	    = SEX_ANY;
	spell	        = 0;
	spellHit	    = 0;
	useSpell	    = 0;
	spellMultiplier = 1;

	set     = false;
	setSlot = -1;
	uses    = 0;
	
	#region ITEM TABLE 
		item_use_throw = function(itemData) {
			obj_stats.attackQueue.Enqueue({source :  obj_player.id, target : undefined, attackType : ATTACK_TYPE_THROW, attackThrowData : itemData, attackWaitTime : 0});
			obj_player.ChangeState(ST_QUEUED);
		}//end function
		
		
		item_use_item = function(itemData) {
			obj_stats.attackQueue.Enqueue({source :  obj_player.id, target : undefined, attackType : ATTACK_TYPE_USE_ITEM, selfUseData : itemData, attackWaitTime : 0});
			obj_player.ChangeState(ST_QUEUED);
		}//end function		

		item_use_spell = function(data) {		
			var spellIndex = data.spell;
			var spellData = obj_stats.inventory.GetSpellData(spellIndex);
			
			obj_stats.attackQueue.Enqueue({source : obj_player.id, target : undefined, attackType : ATTACK_TYPE_MAGIC, attackSpellData : spellData, attackWaitTime : 0});
			obj_player.ChangeState(ST_QUEUED);
		}//end function	
	#endregion
	
	IsType = function(typeConstant) {
		return type & typeConstant > 0;
	}//end function		
	
	IsClass = function(clasConstant) {
		return class & clasConstant > 0;
	}//end function	
	
	UseItem = function(itemData) {
		var useFunction = item_use_throw;
		
		if itemData.IsClass(ITEM_CLASS_SPELL) then {
			useFunction = item_use_spell;
		}//end if
		
		if itemData.IsClass(ITEM_CLASS_USE) then {
			useFunction = item_use_item;
		}//end if

		useFunction(itemData);
	}//end if
}

function SetItem(newItem, initialUses) constructor{
	item = newItem;
	uses = initialUses;
}//end struct

function Stats() constructor {
	name = "null"
	hp		= 0;
	mp		= 0;
	fp	    = 0;
	max_hp	= 0;
	max_mp	= 0;
	max_fp	= 0;
	att		= 0;
	mag		= 0;
	def		= 0;
	hit		= 0;
	evd     = 0;
	luk     = 0;	
	
	lvl     = 1;	
	xp      = 0;
	next    = 20;
	job     = JOB_VIKING;
	skill   = 0.0;
	
	itemCommon = ITEM_NULL;
	itemRare = ITEM_NULL;
	dropRateCommon = 0;
	dropRateRare = 0;
	
	recoverHpRate = 1;
	recoverMpRate = 1;
	recoverFpRate = -1;
	
	eleAttack = ELE_NULL;
	eleStrong = ELE_NULL;
	eleWeak   = ELE_NULL;
	eleImmune = ELE_NULL;
	eleAbsorb = ELE_NULL;
	
	statusImmune  = STATUS_NULL;
	statusAttack = STATUS_NULL;
	status  	  = STATUS_NULL;
	
	sex     = SEX_UNDEFINED;	
	class = ACTOR_CLASS_MONSTER;
	type  = ACTOR_TYPE_NULL;
	target = obj_player;
	
	equipment = {
		leftHand  : undefined,
		rightHand : undefined,
		head      : undefined,
		body      : undefined,
		acc       : undefined
	}//end if

	bonusMax_hp	= 0;
	bonusMax_mp	= 0;
	bonusMax_fp	= 0;
	bonusAtt	= 0;
	bonusMag	= 0;
	bonusDef	= 0;
	bonusHit	= 0;
	bonusEvd	= 0;
	bonusLuk	= 0;
	bonusRecoverHpRate = 0;
	bonusRecoverMpRate = 0;
	bonusRecoverFpRate = 0;	

	HasStatus = function(checkStatus) {
		return (checkStatus & status) > 0;
	}//end function

	RefreshStats = function() {
		bonusMax_hp	       = equipment.leftHand.max_hp + equipment.rightHand.max_hp + equipment.head.max_hp + equipment.body.max_hp + equipment.acc.max_hp;
		bonusMax_mp	       = equipment.leftHand.max_mp + equipment.rightHand.max_mp + equipment.head.max_mp + equipment.body.max_mp + equipment.acc.max_mp;
		bonusMax_fp	       = equipment.leftHand.max_fp + equipment.rightHand.max_fp + equipment.head.max_fp + equipment.body.max_fp + equipment.acc.max_fp;
		bonusAtt	       = equipment.leftHand.att + equipment.rightHand.att + equipment.head.att + equipment.body.att + equipment.acc.att;
		bonusDef	       = equipment.leftHand.def + equipment.rightHand.def + equipment.head.def + equipment.body.def + equipment.acc.def;
		
		var eqpLft = equipment.leftHand.id > 0; 
		var eqpRgt  = equipment.rightHand.id > 0;
		var dualWield = eqpLft and eqpRgt;
		var bareFist =  eqpLft == false and eqpRgt == false;		
		
		if bareFist then {
			bonusHit = 60;		
		}else if dualWield then {
			bonusHit = equipment.leftHand.hit + equipment.rightHand.hit div 2; 			
		}else{
			bonusHit = equipment.leftHand.hit + equipment.rightHand.hit
		}//end if
		
		bonusHit	       += equipment.head.hit + equipment.body.hit + equipment.acc.hit;
		
		//implement shield check
		bonusEvd	       = equipment.leftHand.evd + equipment.rightHand.evd + equipment.head.evd + equipment.body.evd + equipment.acc.evd;
		bonusLuk	       = equipment.leftHand.luk + equipment.rightHand.luk + equipment.head.luk + equipment.body.luk + equipment.acc.luk;
		bonusRecoverHpRate = equipment.leftHand.recoverHpRate + equipment.rightHand.recoverHpRate + equipment.head.recoverHpRate + equipment.body.recoverHpRate+ equipment.acc.recoverHpRate;
		bonusRecoverMpRate = equipment.leftHand.recoverMpRate + equipment.rightHand.recoverMpRate + equipment.head.recoverMpRate + equipment.body.recoverMpRate+ equipment.acc.recoverMpRate;
		bonusRecoverFpRate = equipment.leftHand.recoverFpRate + equipment.rightHand.recoverFpRate + equipment.head.recoverFpRate + equipment.body.recoverFpRate+ equipment.acc.recoverFpRate;			
	
		eleAttack     = equipment.leftHand.element   | equipment.rightHand.element   | equipment.head.element   | equipment.body.element   | equipment.acc.element;
		eleStrong     = equipment.leftHand.eleStrong | equipment.rightHand.eleStrong | equipment.head.eleStrong | equipment.body.eleStrong | equipment.acc.eleStrong;
		eleWeak       = equipment.leftHand.eleWeak   | equipment.rightHand.eleWeak   | equipment.head.eleWeak   | equipment.body.eleWeak   | equipment.acc.eleWeak  ;
		eleImmune     = equipment.leftHand.eleImmune | equipment.rightHand.eleImmune | equipment.head.eleImmune | equipment.body.eleImmune | equipment.acc.eleImmune;
		
		statusImmune  = equipment.leftHand.statusImmune  | equipment.rightHand.statusImmune  | equipment.head.statusImmune  | equipment.body.statusImmune  | equipment.acc.statusImmune ;
		statusAttack  = equipment.leftHand.statusInflict | equipment.rightHand.statusInflict | equipment.head.statusInflict | equipment.body.statusInflict | equipment.acc.statusInflict;
		status        = equipment.leftHand.statusCause   | equipment.rightHand.statusCause   | equipment.head.statusCause   | equipment.body.statusCause   | equipment.acc.statusCause  ;
		killerType    = equipment.leftHand.killerType    | equipment.rightHand.killerType    | equipment.head.killerType    | equipment.body.killerType    | equipment.acc.killerType   ;
	}//end function
	
	RecalculateBaseStats = function(heal = true) {
		
	var hpCurveChannel = animcurve_get_channel(anc_normal_hp_growth, "value");
	var hpCurveValue   = ceil(animcurve_channel_evaluate(hpCurveChannel, lvl/99));
		
	var mpCurveChannel = animcurve_get_channel(anc_normal_hp_growth, "value");
	var mpCurveValue   = ceil(animcurve_channel_evaluate(mpCurveChannel, lvl/99));
		
	var fpCurveChannel = animcurve_get_channel(anc_normal_hp_growth, "value");
	var fpCurveValue   = ceil(animcurve_channel_evaluate(fpCurveChannel, lvl/99));
		
	var expCurveChannel = animcurve_get_channel(anc_normal_exp_growth, "value");
	var expCurveValue   = ceil(animcurve_channel_evaluate(expCurveChannel, lvl/99));
	
	var hitCurveChannel = animcurve_get_channel(anc_normal_hit_growth, "value");
	var hitCurveValue   = ceil(animcurve_channel_evaluate(hitCurveChannel, lvl/99));

	//for (var i = 0; i < 99; ++i) {
	//    var temp  =[i, i/99, ceil(animcurve_channel_evaluate(expCurveChannel, i/99))];
	//	print(temp);
	//}
	
	//base based on terra
	max_hp	= 40 + hpCurveValue;
	max_mp	= 16 + mpCurveValue;
	max_fp	= 24 + fpCurveValue;
	
	if heal then {
		hp	= max_hp;
		mp	= max_mp;
		fp	= max_fp;
	}//end if
	
	att		= 5 //+ statCurveValue;
	mag		= 5 //+ statCurveValue;
	def		= 5 //+ statCurveValue;
	
	//from e
	hit		= hitCurveValue;
		
	evd     = 5 //+ statCurveValue;
	luk     = 7 //+ statCurveValue;	
	next    = expCurveValue;//(4 * power(lvl,3)) div 5 + 1;		
	
	recoverHpRate = lvl div 2 + 1;
	recoverMpRate = lvl div 4 + 1;
	recoverFpRate = -(lvl div 8) + 1;		
	}//end if

}

function List() constructor {
	count = 0;
	nodes = [];
	
	function Add(data) {
		nodes[array_length(nodes)] = data;
		count += 1;
	}//end function
	
	function Get(index){
		if index >= count then {
			return undefined;
		}//end if
		
		return nodes[index];
	}//end function
	
	function RemoveAt(index) {	
		if index >= count then {
			throw ("Index " + string(index) + "is outside of bounds " + string(count - 1) + " for List");
		}//end if
		
		var returnValue = nodes[index];
		var newArray = [];
				
		if count == 1 then {
			nodes = [];
			count = 0;
			return returnValue;
		}//end if
			
		//rebuild node array without node				
			for (var checkIndex = 0; checkIndex < array_length(nodes) ; checkIndex += 1) {
				if checkIndex != index then {
					newArray[array_length(newArray)] = nodes[checkIndex];
				}//end if
			}//end for
		
			nodes = [];
			array_copy(nodes, 0, newArray, 0, array_length(newArray));
			
		count -= 1;
		return returnValue;
	}//end function

	function Contains(value) {	
		if count == 0 then {
			return false;
		}//end if
						
		//check node array 
			for (var checkIndex = 0; checkIndex < array_length(nodes) ; checkIndex += 1) {
				if nodes[index] == value then return true;
			}//end for
		
		return false;
	}//end function


	function IsEmpty() {
		return count == 0;		
	}//end function
			
}//end struct		

function Queue() constructor {
	count = 0;
	nodes = [];
	
	function Enqueue(data) {
		nodes[array_length(nodes)] = data;
		count += 1;
	}//end function
	
	function Dequeue() {	
		if count == 0 then return undefined;
		
		var returnValue = nodes[0];
		var newArray = [];
				
		if count == 1 then {
			nodes = [];
			count = 0;
			return returnValue;
		}//end if
			
		//rebuild node array without first (front) node				
			for (var index = 1; index < array_length(nodes) ; index += 1) {
					newArray[array_length(newArray)] = nodes[index];
			}//end for
		
			nodes = [];
			array_copy(nodes, 0, newArray, 0, array_length(newArray));
			
		count -= 1;
		return returnValue;
	}//end function

	function IsEmpty() {
		return count == 0;		
	}//end function
	
	function toString() {
		var str = "";
		for (var index = 0; index < array_length(nodes) ; index += 1) {
			if index == 0 then {
				str += string(nodes[index]) + ICO_ARROW_LF + "\n";
			}else{
				str += string(nodes[index]) + "\n";
			}//end if
		}//end for
		return str
				
	}

		
}//end struct		

function Grid (init_width, init_height) constructor {		
	width = init_width;
	height = init_height;
		
	//initalize array
	for (var xi = 0; xi < width ; ++xi) {
		for (var yi = 0; yi < height ; ++yi) {
			data[xi,yi] = undefined;
		}
	}			
		
		
	static SetElement = function(xp, yp, value) {
		data[xp, yp] = value;  
	}//end function
	
	static SetRegion = function(x1, y1, x2, y2, value) {		
		if x1 > width  or x1 < 0 then show_error("Grid x1 out of bounds",true);	
		if y1 > height or y1 < 0 then show_error("Grid y1 out of bounds",true);
		if x2 > width  or x2 < 0 then show_error("Grid x2 out of bounds",true);	
		if y2 > height or y2 < 0 then show_error("Grid y2 out of bounds",true);
		if x1 > x2 then show_error("Grid x1, x2 out of order",true);	
		if y1 > y2 then show_error("Grid y1, y2 out of order",true);			

		for (var xi = x1; xi < x2 ; ++xi) {
			for (var yi = y1; yi < y2 ; ++yi) {
				data[xi,yi] = value;
			}
		}		
	}//end function
		
	static Fill = function(value) {
		SetRegion(0, 0, width , height , value);	
	}//end function
	
	static toString = function () {
		return string(data);
	};
}//end struct
	
function Vector2() constructor{
    x = 0;
    y = 0;
    xSign = 0;
    ySign = 0;
	
    static Add = function( _other ){
        x += _other.x;
        y += _other.y;
		UpdateSign();
    }//end function
	
    static Set = function(_x, _y ){
	    x = _x;
	    y = _y;
		UpdateSign();
    }//end function
	
    static UpdateSign = function(){
	    xSign = sign(x);
	    ySign = sign(y);
    }//end function
	
		
    static Is = function(_x, _y ){
	    return x == _x and y == _y;
    }//end function
}

function FrameData() constructor {
	sprite = undefined;
	imageIndex = 0;
	bottomXscale = 1;
	xScale = 1;
	yScale = 1;
	xOffset = 0;
	yOffset = 0;
	rotation = 0;
	speedMult = 1;
}

function AnimationData() constructor {
	frames = new List();
	maxFrames = 0;
	
	function AddFrame(sprite, imageIndex, bottomXscale, xScale, yScale, xOffset, yOffset, rotation, speedMult){
		var newFrame = new FrameData();
		newFrame.iconSprite = sprite;
		newFrame.imageIndex = imageIndex;
		newFrame.bottomXscale = bottomXscale;
		newFrame.xScale = xScale;
		newFrame.yScale = yScale;
		newFrame.xOffset = xOffset;
		newFrame.yOffset = yOffset;
		newFrame.rotation = rotation;
		newFrame.speedMult = speedMult;
		
		frames.Add(newFrame);
		maxFrames += 1;
	}
	
	function GetFrameData(frameIndex) {
		//if frameIndex >= maxFrames then frameIndex = frameIndex - maxFrames;
		return frames.Get(floor(frameIndex mod maxFrames));
		//return frames.Get(floor(frameIndex));
	}//end function
	
}//end struct
