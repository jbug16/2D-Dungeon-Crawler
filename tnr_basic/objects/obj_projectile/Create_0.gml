target = noone;
hitRate = 100;
wallCollide = false;
speed = 2;
direction = 0
parent = undefined;
timer = 0;
damage = 0;
attackType = ATTACK_TYPE_NULL;	
spellData = undefined;
thrownItemData = undefined;


function ApplyDamage() {		    
	//IF ATTACK LANDS	
	if target = parent then exit;
	
	target.ChangeState(ST_HURT);
	
	var dmg = 0;
	
	if attackType == ATTACK_TYPE_MAGIC then {
		dmg = obj_stats.CalculateMagicalAttackDamage(parent.stats, target.stats, spellData);		
	}//end if
	
	if attackType == ATTACK_TYPE_THROW then {
		dmg = floor((thrownItemData.att * 2) * random_range(1,1.5));
	}//end if
		
	//show  damage
	damId       = instance_create_depth(middle_x(target), target.bbox_top + 2, target.depth - 1, obj_damage);
	damId.value = dmg;
					
	target.stats.hp -= dmg;
}//end if
	