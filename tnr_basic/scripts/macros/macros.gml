#macro ATTACK_TYPE_NULL				     0x0
#macro ATTACK_TYPE_THROW				 0x1
#macro ATTACK_TYPE_MELEE				 0x2
#macro ATTACK_TYPE_MAGIC				 0x4
#macro ATTACK_TYPE_ALL_ENEMIES			 0x8
#macro ATTACK_TYPE_ALL_ENEMIES_IN_ROOM	 0x10
#macro ATTACK_TYPE_ALL_ENEMIES_IN_RANGE	 0x20
#macro ATTACK_TYPE_NEAREST_ENEMY		 0x40
#macro ATTACK_TYPE_MONSTER               0x80
#macro ATTACK_TYPE_USE_ITEM              0x100

	#macro TILE_SIZE 0x10

	enum TILE_TYPE {
		NULL = 0,
		WALL = 1,
		STAIRS_UP = 2,
		STAIRS_DOWN = 3,			
		FLOOR = 4,
		HALL = 5,
	}//end enum

#region ITEM_DATA
	#macro ITEM_NULL 0
#endregion


#region ITEM_CLASS
	#macro ITEM_CLASS_NULL  	 0x00
	#macro ITEM_CLASS_HAND  	 0x01
	#macro ITEM_CLASS_HEAD		 0x02
	#macro ITEM_CLASS_BODY	     0x04
	#macro ITEM_CLASS_ACCESSORY  0x08
	#macro ITEM_CLASS_USE        0x10
	#macro ITEM_CLASS_PLOT	     0x20
	#macro ITEM_CLASS_2HAND      0x40
	#macro ITEM_CLASS_MIX        0x80
	#macro ITEM_CLASS_MEDICINE	 0x100
	#macro ITEM_CLASS_UNTHROWABLE 0x200
	#macro ITEM_CLASS_UNDROPPABLE 0x400
	#macro ITEM_CLASS_UNSELLABLE  0x800
	#macro ITEM_CLASS_SPELL  0x1000
#endregion


#region ITEM TYPE
	#macro ITEM_TYPE_NULL       0x0
	#macro ITEM_TYPE_POTION     0x1
	#macro ITEM_TYPE_SWORD      0x2
	#macro ITEM_TYPE_KATANA     0x4
	#macro ITEM_TYPE_KNIFE      0x8
	#macro ITEM_TYPE_SPEAR      0x10
	#macro ITEM_TYPE_WHIP       0x20
	#macro ITEM_TYPE_BOW        0x40
	#macro ITEM_TYPE_HAMMER     0x80
	#macro ITEM_TYPE_ROD        0x100
	#macro ITEM_TYPE_HARP       0x200
	#macro ITEM_TYPE_AXE        0x400
	#macro ITEM_TYPE_TOOL       0x800
	#macro ITEM_TYPE_CLAW       0x1000
	#macro ITEM_TYPE_SHIELD     0x2000
	#macro ITEM_TYPE_STAFF      0x4000
	#macro ITEM_TYPE_ARMOR      0x8000
	#macro ITEM_TYPE_ROBE       0x10000
	#macro ITEM_TYPE_BELL       0x20000
	#macro ITEM_TYPE_GLOVE      0x40000
	#macro ITEM_TYPE_HELMET     0x80000
	#macro ITEM_TYPE_ARROW      0x100000
	#macro ITEM_TYPE_THROW      0x200000
	#macro ITEM_TYPE_BOOK       0x400000
	#macro ITEM_TYPE_NUNCHAKU   0x800000
	#macro ITEM_TYPE_BOOMERANG  0x1000000
	#macro ITEM_TYPE_RING       0x2000000
	#macro ITEM_TYPE_CROSSBOW   0x4000000	
	#macro ITEM_TYPE_BOLT       0x8000000	
	#macro ITEM_TYPE_SCYTHE     0x10000000	
	#macro ITEM_TYPE_PICKAXE    0x20000000		
	#macro ITEM_TYPE_SPELL      0x40000000		
#endregion	

#region SEXES
	#macro SEX_NULL       0x0
	#macro SEX_FEMALE     0x1
	#macro SEX_MALE       0x2
	#macro SEX_UNDEFINED  0x4
	#macro SEX_ANY		  0xFFFFFFFF
#endregion



#macro JOB_NULL   0
#macro JOB_VIKING 0x1
#macro JOB_ANY	  0xFFFFFFFF

	#macro c_frost   0xEDEDD4
	#macro c_ruby    0x272DA5
	#macro c_gold    0x62A5CC
	#macro c_emerald 0x5C8465
	#macro c_azure   0xAD6E4C
	#macro c_iron    0x5F6367
	#macro c_rust    0x2C4963
	#macro c_grass   0x8AB597
	
	#region ELEMENTS
		#macro ELE_NULL	  0x0
		#macro ELE_FIRE	  0x1
		#macro ELE_ICE	  0x2
		#macro ELE_BOLT	  0x4
		#macro ELE_WIND	  0x10
		#macro ELE_WATER  0x20
		#macro ELE_EARTH  0x40
		#macro ELE_HOLY	  0x80
		#macro ELE_DARK	  0x100
		#macro ELE_POISON 0x200
		#macro ELE_ATOMIC 0x400
	#endregion

	#region STATUS_EFFECTS
		#macro STATUS_NULL      0x00
		#macro STATUS_POISON    0x01
		#macro STATUS_MINI	    0x02
		#macro STATUS_MUTE	    0x04
		#macro STATUS_BLIND	    0x80
		#macro STATUS_BERSERK   0x100
		#macro STATUS_FLOAT     0x200
		#macro STATUS_REGEN     0x400
		#macro STATUS_KO        0x800
		#macro STATUS_CURSED    0x1000
		#macro STATUS_STOP	    0x2000
		#macro STATUS_SLOW	    0x4000
		#macro STATUS_HASTE	    0x8000
		#macro STATUS_CONFUSED  0x10000
		#macro STATUS_INVISIBLE 0x20000
		#macro STATUS_JUMPING   0x40000
		#macro STATUS_SLEEP     0x80000
		#macro STATUS_RERAISE   0x100000
		#macro STATUS_REFLECT   0x200000
		#macro STATUS_SAFE      0x400000
		#macro STATUS_SHELL     0x800000
		#macro STATUS_DEFENDING     0x1000000
		#macro STATUS_MAGICSWORD    0x2000000
	#endregion

	#region PLAYER STATES
		#macro ST_NULL			   0x0
		#macro ST_STANDING		   0x1
		#macro ST_WALKING		   0x2
		#macro ST_WAITING		   0x4
		#macro ST_CHECK_LOS		   0x8
		#macro ST_INTERACTING      0x10
		#macro ST_QUEUED		   0x20
		#macro ST_SWIMMING	       0x40
		#macro ST_THROWING		   0x80
		#macro ST_USING_ITEM	   0x100
		#macro ST_HIGH_JUMP		   0x200
		#macro ST_FALLING		   0x400
		#macro ST_WALL_JUMPING	   0x800
		#macro ST_HURT			   0x2000
		#macro ST_DEAD			   0x4000
		#macro ST_ATTACKING		   0x8000
		#macro ST_INVINCIBLE	   0x10000
		#macro ST_PUSHING          0x20000
		#macro ST_LIFTING          0x40000	
		#macro ST_MAGIC_PLUME	   0x80000		
		#macro ST_MAGIC_SHOT	   0x100000		
		#macro ST_THROW_BOMB	   0x200000		
		#macro ST_TALKING   	   0x400000		
		#macro ST_SHOPING   	   0x800000		
		#macro ST_CANT_MOVE   	   0x1000000		
	#endregion


#region	ITEM ICONS
	#macro ICO_TOWN	  chr(123)
	#macro ICO_DUNGEON	  chr(124)
	
	#macro ICO_HEART	  chr(63 + 31)
	#macro ICO_NONE       chr(000)
	#macro ICO_POTION	  chr(127)
	#macro ICO_SWORD	  chr(128)
	#macro ICO_KATANA	  chr(131)
	#macro ICO_KNIFE	  chr(132)
	#macro ICO_SPEAR	  chr(133)
	#macro ICO_WHIP		  chr(134)
	#macro ICO_BOW		  chr(136)
	#macro ICO_HAMMER	  chr(137)
	#macro ICO_ROD		  chr(139)
	#macro ICO_HARP		  chr(140)
	#macro ICO_AXE		  chr(141)
	#macro ICO_TOOL		  chr(142)
	#macro ICO_CLAW		  chr(143)
	#macro ICO_SHIELD	  chr(144)
	#macro ICO_STAFF	  chr(145)
	#macro ICO_ARMOR	  chr(146)
	#macro ICO_ROBE		  chr(147)
	#macro ICO_TICKET	  chr(148)
	#macro ICO_BELL		  chr(149)
	#macro ICO_GLOVE	  chr(154)
	#macro ICO_HELMET	  chr(155)
	#macro ICO_ARROW	  chr(156)
	#macro ICO_THROW	  chr(157)
	#macro ICO_BOOK		  chr(158)
	#macro ICO_NUNCHAKU	  chr(159)
	#macro ICO_SPECIAL	  chr(160)	
	#macro ICO_BOOMERANG  chr(161)
	#macro ICO_RING		  chr(181)	
	#macro ICO_CROSSBOW	  chr(173)
	#macro ICO_BOLT	      chr(174)
	#macro ICO_SCYTHE	  chr(171)
	#macro ICO_PICKAXE	  chr(182)
	#macro ICO_MEDICINE	  chr(172)
	
	#macro ICO_ARROW_UP	  chr(31 + 131)
	#macro ICO_ARROW_DN	  chr(31 + 133)	
	#macro ICO_ARROW_LF	  chr(31 + 132)
	#macro ICO_ARROW_RT	  chr(31 + 166)	
	
	#macro ICO_LEFT_EQ	  chr(31 + 144)
	#macro ICO_RIGHT_EQ	  chr(31 + 145)	
	#macro ICO_HEAD_EQ	  chr(31 + 146)
	#macro ICO_BODY_EQ	  chr(31 + 147)		
	#macro ICO_ACC_EQ	  chr(31 + 150)		
#endregion

#region SPELLS 
	#macro SPELL_FIRE 1
	#macro SPELL_ICE  2
	#macro SPELL_BOLT 3
#endregion

#region ITEMS
	#macro ITEM_EMPTY 0
	#macro ITEM_WOOD_SWORD 1
	#macro ITEM_IRON_SWORD 2
	#macro ITEM_FIRE_SWORD 3
	#macro ITEM_ICE_SWORD 4
	#macro ITEM_BOLT_SWORD 5
	#macro ITEM_LEATHER_SHIELD 6
	#macro ITEM_WOODEN_SHIELD 7
	#macro ITEM_IRON_SHIELD 8
	#macro ITEM_FIRE_SHIELD 9
	#macro ITEM_ICE_SHIELD 10
	#macro ITEM_BOLT_SHIELD 11
	#macro ITEM_LEATHER_HELMET 12
	#macro ITEM_WOODEN_HELMET 13
	#macro ITEM_IRON_HELMET 14
	#macro ITEM_LEATHER_ARMOR 15
	#macro ITEM_WOODEN_ARMOR 16
	#macro ITEM_IRON_ARMOR 17
	#macro ITEM_POWER_SPECIAL 18
	#macro ITEM_EMERALD_SPECIAL 19
	#macro ITEM_GLASSES_SPECIAL 20
	#macro ITEM_PLOTEST_ 21
	#macro ITEM_ASHGEM_ 22
	#macro ITEM_NODROP_ 23
	#macro ITEM_NOSELL_ 24
	#macro ITEM_POTION_ 25
	#macro ITEM_MEAT_ 26
	#macro ITEM_BREAD_ 27
	#macro ITEM_FIRE1_SPELL 28
	#macro ITEM_ICE1_SPELL 29
	#macro ITEM_BOLT1_SPELL 30
	#macro ITEM_MANA_ 31
	#macro ITEM_STEROID_ 32
	#macro ITEM_OPIUM_ 33
	#macro ITEM_SOUL_ 34
	#macro ITEM_EYEDROP_ 35
	#macro ITEM_METH_ 36
	#macro ITEM_CLOVER_ 37
	#macro ITEM_VITAMIN_ 38
	#macro ITEM_PIXIE_ 39
	#macro ITEM_WEED_ 40

	#macro ITEM_BRONZE_SPEAR 41
	#macro ITEM_BRONZE_AXE 42
	#macro ITEM_BRONZE_KATANA 43
	#macro ITEM_BRONZE_STAFF 44
	#macro ITEM_BRONZE_BOW 45
	#macro ITEM_BRONZE_CLAW 46
	#macro ITEM_BRONZE_WHIP 47
	#macro ITEM_BRONZE_CROSSBOW  48
	#macro ITEM_BRONZE_HAMMER 49
	#macro ITEM_BRONZE_ROD 50
	#macro ITEM_BRONZE_SCYTHE 51

	#macro MAX_ITEM_COUNT 51

#endregion



#macro SECTORS_X (CAMERA_WIDTH  div TILE_SIZE)
#macro SECTORS_Y (CAMERA_HEIGHT div TILE_SIZE)




enum TILE {
	NULL,
	OCEAN,
	SWAMP,
	COAST,
	DESERT,
	GRASS,
	SNOW,
	FOREST,
	SNOWFOREST,
	MOUNTAIN,
	SNOWMOUNTAIN,
	ICE,
	LAVA,
	JUNGLE,
	WATER,
	ROCKYGROUND,
	HIGHREGOLITH,
	REGOLITH,
	LOWREGOLITH,
	ROCKMOUNTAIN,
	BEDROCK,
	COLDDESERT,
	COLDDESERTMOUNTAIN,
	GAS,
	GAS2,
	GAS3,
	GAS4,
	GAS5,
	GAS6,
	TOWN,
	DUNGEON
}//end enum


#macro TILE_COLOR [0xBC4A9B,0x249FDE,0x477D85,0xDBA463,0xF4D29C,0x59C135,0xE3E6FF,0x23674E,0xCDF7E2,0x8E5252,0xFBE6DE,0xFFFFFF,0xDF3E23,0x12904C,0x285CC4,0xBB7547,0xF5FFE8,0xDFE0E8,0xA3A7C2,0x703E2F,0x5C2B27,0x783F31,0xA17376,0xBD7748,0x535E8A,0x485939,0x4D233E,0x4F4744,0xB5CDEB, c_black, c_purple]


#macro TILE_NAME  ["NULL", "OCEAN", "SWAMP", "COAST", "DESERT", "GRASS", "SNOW", "FOREST", "SNOWFOREST", "MOUNTAIN", "SNOWMOUNTAIN", "ICE", "LAVA", "JUNGLE", "WATER", "ROCK", "HIGHREGOLITH","REGOLITH","LOW REGOLITH","ROCKY MOUNTAIN", "BEDROCK", "COLD DESERT", "COLD DESERT MT.", "GAS" , "GAS2", "GAS3", "GAS4", "GAS5", "GAS6"]

#macro PLANET_TYPE_NAME ["LAVA","ROCKY","DESERT","HEAVY ATHMOS","WATER","BALMY FLOODED","BALMY","GRASSY","FOREST","JUNGLE","DRY","SNOWY","SWAMP","COLD DESERT","TUNDRA","GAS","BALMYCLOUDY","MOON"]




#macro PT_LAVAWORLD				   0
#macro PT_ROCK_COVERED			   1
#macro PT_HOT_DESERT			   2
#macro PT_THICK_ATHMOSPHERE_HOT    3
#macro PT_ALL_WATER				   4
#macro PT_EARTHLIKE_MOSTLY_WATER   5
#macro PT_EARTHLIKE				   6
#macro PT_EARTHLIKE_NO_FOREST	   7
#macro PT_EARTHLIKE_MOSTLY_FOREST  8
#macro PT_EARTHLIKE_JUNGLE		   9
#macro PT_EARTHLIKE_DESERT		   10
#macro PT_EARTHLIKE_SNOW		   11
#macro PT_EARTHLIKE_SWAMP          12
#macro PT_COLD_DESERT			   13
#macro PT_TUNDRA_PLANET			   14
#macro PT_GAS_PLANET			   15
#macro PT_THICK_ATHMOSPHERE_TEMPERATE 16
#macro PT_EARTHLIKE_MOON           17								   

