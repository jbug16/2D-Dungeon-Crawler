/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

UpdateAnimations();

// Set attack type to magic instead of melee
attackType = ATTACK_TYPE_MAGIC;

// Set up spell data for the enemy's ranged attack
enemySpellData = {
    name: "Enemy Shot",
    mpCost: 0,
    pow: 10,
    element: ELE_NULL,
    travelSequence: seq_null,
    hitSequence: seq_null
};

// Custom attack function for ranged enemies
function RangedAttack() {
    if !instance_exists(stats.target) return false;
    
    var myMiddleX = middle_x(id);
    var myMiddleY = middle_y(id);
    var targetMiddleX = middle_x(stats.target);
    var targetMiddleY = middle_y(stats.target);
    
    // Check distance (e.g., 3-6 tiles away)
    var dist = point_distance(myMiddleX, myMiddleY, targetMiddleX, targetMiddleY);
    var minRange = TILE_SIZE * 3;
    var maxRange = TILE_SIZE * 6;
    
    // Check if in ranged attack range and has line of sight
    if dist >= minRange && dist <= maxRange && LineOfSight(myMiddleX, myMiddleY, targetMiddleX, targetMiddleY) {
        // Queue ranged attack
        var atkData = new AttackData();
        atkData.source = id;
        atkData.target = stats.target;
        atkData.attackType = ATTACK_TYPE_MAGIC;
        atkData.attackSpellData = enemySpellData;
        
        obj_stats.attackQueue.Enqueue(atkData);
        ChangeState(ST_QUEUED);
        
        // Face the target
        faceDirection = point_direction(x, y, stats.target.x, stats.target.y);
        
        return true;
    }
    
    return false;
}