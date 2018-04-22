package controllers;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;

import fighter.*;
import spells.Spell;

class AIController
{
    public function new(fighters:FlxGroup)
    {
        distanceToEnemy = new Map<Fighter, Map<Fighter, Float>>();
        this.fighters = fighters;
        fighters.forEach(function(basic:flixel.FlxBasic)
        {
            var fighter = cast(basic, Fighter);
            distanceToEnemy[fighter] = new Map<Fighter, Float>();
        });
        rand = new FlxRandom();
    }


    public function fightAgainst(team:FlxGroup)
    {
        enemies = team;
    }

    public function update(elapsed:Float)
    {
        fighters.forEachAlive(function(basic)
        {
            var fighter = cast(basic, Fighter);
            updateDistances(fighter);

            if (Std.is(fighter, Singer))
            {
                updateSinger(cast fighter);
            }
            if (Std.is(fighter, Drummer))
            {
                updateDrummer(cast fighter);
            }
            if (Std.is(fighter, Guitarist))
            {
                updateGuitarist(cast fighter);
            }
        });
    }

    function closestEnemy(fighter:Fighter):Fighter
    {
        var closestEnemy:Fighter = null;
        var closestDistance:Float = Math.POSITIVE_INFINITY;
        enemies.forEachAlive(function(basic)
        {
            var enemy = cast(basic, Fighter);
            var currentDistance = distanceToEnemy[fighter][enemy];
            if( currentDistance < closestDistance)
            {
                closestEnemy = enemy;
                closestDistance = currentDistance;

            }
        });
        return closestEnemy;
    }

    function avoidEnemy(fighter:Fighter)
    {
        if (fighter.avoiding)
        {
            if (fighter.avoidDirection != null)
            {
            fighter.moveTo(fighter.getPosition().addPoint(fighter.avoidDirection.scale(10)));
            }
        }
        else
        {
            fighter.avoiding = true;
            changeDirection(fighter);
            fighter.avoidTimer.start(rand.float(.8, 1.9), function(_)
            {
                changeDirection(fighter);
            }, 0);
        }
    }

    function updateSinger(singer:Singer)
    {
        var closest = closestEnemy(singer);
        if(closest == null)
        {
            singer.avoiding = false;
            singer.avoidTimer.cancel();
            singer.path.active = false;
            singer.velocity.set(0,0);
            return;
        }
        var distance:Float = closest.getPosition().distanceTo(singer.getPosition());

        function singerMove()
        {

            if ( distance < 10)
            {
                avoidEnemy(singer);
            }

            else if (singer.canSpell)
            {
                singer.avoiding = false;
                singer.avoidTimer.cancel();
                if (distance > singer.sonicBang.range)
                {
                    singer.moveTo(closest.getPosition());
                }
                else
                {
                    singer.velocity.set(0,0);
                    singer.path.active = false;
                }
            }
            else
            {
                if (distance < 50 || singer.fleeing)
                {
                    avoidEnemy(singer);
                }
                else if(!singer.moveOveridden)
                {
                    singer.avoiding = false;
                    singer.avoidTimer.cancel();
                    singer.velocity.set(0,0);
                    singer.path.active = false;
                }

            }

        }

        if (singer.canMelee)
        {
            if ( closest.getPosition().distanceTo(singer.getPosition()) < 8)
            {
                singer.melee(closest);
                singer.velocity.set(0,0);
                singer.path.active = false;
            }
            else if(singer.getPosition().distanceTo(closest.getPosition()) < singer.sonicBang.range && singer.canSpell)
            {
                singer.castSpellToTarget(singer.sonicBang, closest);
                singer.velocity.set(0,0);
                singer.path.active = false;
            }
            else
            {
                singerMove();
            }
        }
    }

    function updateDrummer(drummer:Drummer)
    {
        var closest = closestEnemy(drummer);
        if(closest == null)
        {
            drummer.avoiding = false;
            drummer.avoidTimer.cancel();
            drummer.path.active = false;
            drummer.velocity.set(0,0);
            return;
        }
        if (drummer.canSpell)
        {
            drummer.avoiding = false;
            drummer.avoidTimer.cancel();
            if ( closest.getPosition().distanceTo(drummer.getPosition()) < drummer.drumDrill.range)
            {
                drummer.avoiding = false;
                drummer.avoidTimer.cancel();
                drummer.path.active = false;
                drummer.velocity.set(0,0);
                drummer.castSpellToTarget(drummer.drumDrill, closest);
            }
            else
            {
                drummer.moveTo(closest.getPosition());
            }

        }
        else
        {
            if ( closest.getPosition().distanceTo(drummer.getPosition()) < 20)
            {
                avoidEnemy(drummer);
                // drummer.moveTo(drummer.getPosition().subtractPoint(closest.getPosition().subtractPoint(drummer.getPosition())));
            }
            else if (closest.getPosition().distanceTo(drummer.getPosition()) > drummer.drumDrill.range + drummer.drumDrill.aoeRange)
            {
                drummer.avoiding = false;
                drummer.avoidTimer.cancel();
                drummer.moveTo(closest.getPosition());
            }
            else
            {
                drummer.avoiding = false;
                drummer.avoidTimer.cancel();
                drummer.path.active = false;
                drummer.velocity.set(0,0);
            }
        }
    }

    function updateGuitarist(guitarist:Guitarist)
    {
        var closest = closestEnemy(guitarist);
        if(closest == null)
        {
            guitarist.avoiding = false;
            guitarist.avoidTimer.cancel();
            guitarist.path.active = false;
            guitarist.velocity.set(0,0);
            return;
        }
        if(guitarist.canMelee)
        {
            guitarist.avoiding = false;
            if ( closest.getPosition().distanceTo(guitarist.getPosition()) <= 10)
            {
                guitarist.melee(closest);
                avoidEnemy(closest);
                guitarist.path.active = false;
                guitarist.velocity.set(0,0);
            }
            else
            {
                guitarist.moveTo(closest.getPosition());
            }
        }
        else
        {
            avoidEnemy(guitarist);
        }
    }

    function updateDistances(fighter:Fighter)
    {
        for (basic in enemies)
        {
            var enemy = cast(basic, Fighter);
            distanceToEnemy[fighter][enemy] = fighter.getPosition().distanceTo(enemy.getPosition());
        }
    }

    public function changeDirection(fighter:Fighter)
    {
        var angle:Float = rand.float(0, 360);
        fighter.avoidDirection = FlxVector.get(1,0).rotateByDegrees(angle);
    }

    private var fighters:FlxGroup;
    private var enemies:FlxGroup;

    private var rand:FlxRandom;
    private var distanceToEnemy : Map<Fighter, Map<Fighter, Float>>;
}