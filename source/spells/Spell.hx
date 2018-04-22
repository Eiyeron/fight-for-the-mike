package spells;

import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

import fighter.Fighter;

class Spell
{
    public var isAttack(default, null):Bool;
    public var range:Float;
    public var cooldown:Float;
    public var aoe(default, null):Bool = false;
    public var aoeRange:Float;


    private function effect(target:Fighter)
    {
    }


    public function launchToTarget(target:Fighter)
    {
        effect(target);
    }

    public function launchToPoint(point:FlxPoint, potentialTargets:FlxGroup)
    {
        potentialTargets.forEachOfType(Fighter, function(fighter)
        {
            if (!fighter.alive)
            {
                return;
            }
            if (fighter.getPosition().distanceTo(point) <= range)
            {
                effect(fighter);
            }
        });
    }

}