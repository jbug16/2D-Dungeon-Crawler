/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
UpdateAnimations();

// Set attack type to magic instead of melee
attackType = ATTACK_TYPE_MAGIC;

stats.lvl = 1;
stats.att = 10;

// Set up spell data for the enemy's ranged attack
enemySpellData = {
    name: "Enemy Shot",
    spellPower: 5,
    targetType: 0,
    mpCost: 0,
    hitPercent: 100,
    element: ELE_NULL,
    statusEffect: STATUS_NULL,
    description: "Enemy ranged attack",
    travelSequence: seq_fire,
    hitSequence: seq_fire_hit,
	
	// Directions
	directionMode: DIR_EIGHT_WAY,
	passThrough: false
};

// Custom attack function for ranged enemies

minAttack = 2; // Closest the enemy can shoot
maxAttack = 3; // Farthest the enemy can shoot

function RangedAttack() {
    if !instance_exists(stats.target) return false;
    
    var myMiddleX = middle_x(id);
    var myMiddleY = middle_y(id);
    var targetMiddleX = middle_x(stats.target);
    var targetMiddleY = middle_y(stats.target);
    
    // Check distance
    var dist = point_distance(myMiddleX, myMiddleY, targetMiddleX, targetMiddleY);
    var minRange = TILE_SIZE * minAttack;
    var maxRange = TILE_SIZE * maxAttack;
    
    // Check if in ranged attack range and has line of sight
    if dist >= minRange && dist <= maxRange && LineOfSight(myMiddleX, myMiddleY, targetMiddleX, targetMiddleY) {
        // Queue ranged attack
        obj_stats.attackQueue.Enqueue({
            source: id,
            target: stats.target,
            attackType: ATTACK_TYPE_MAGIC,
            attackSpellData: enemySpellData,
            attackWaitTime: 45
        });
        ChangeState(ST_QUEUED);
        
        // Face the target
        faceDirection = point_direction(x, y, stats.target.x, stats.target.y);
        
		// Don't move this turn
        destX = x;
        destY = y;
		
        return true;
    }
    
    return false;
}