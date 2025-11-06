if instance_exists(parent) then {
	parent.ChangeState(ST_STANDING);
	
	if parent.stats.class == ACTOR_CLASS_PLAYER then {
		parent.MoveMonsters();
	}//end if
}//end if

if instance_exists(target) then {
	ApplyDamage();
}//end if

if attackType == ATTACK_TYPE_MAGIC {
	// Safety check
	if !is_undefined(spellData) {
		seqID = layer_sequence_create("lay_instances", x, y , spellData.hitSequence);
	}//end if
}//end if
