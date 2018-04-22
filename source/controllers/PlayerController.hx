package controllers;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

import fighter.*;

class PlayerController extends AIController
{
    public function new(fighters:FlxGroup)
    {
        super(fighters);
    }


    function updateSelected(elapsed:Float)
    {

        if (FlxG.mouse.justPressedRight && selectedFighter != null)
        {
            selectedFighter.moveTo(FlxG.mouse.getWorldPosition(), true);
        }
    }

    public override function update(elapsed:Float)
    {

        if (FlxG.mouse.justPressed)
        {
            if(selectedFighter !=null)
            {
                selectedFighter.color = FlxColor.WHITE;
                selectedFighter.moveOveridden = false;
                selectedFighter = null;
            }
            var pos = FlxG.mouse.getWorldPosition();
            fighters.forEach(function(basic)
            {
                var fighter = cast(basic, Fighter);
                if (fighter.getPosition().distanceTo(pos) < 20)
                {

                    selectedFighter = fighter;
                    selectedFighter.color = FlxColor.RED;
                    selectedFighter.moveOveridden = true;

                }
            });
        }

        for (basic in fighters)
        {
            var fighter = cast(basic, Fighter);
            if (selectedFighter != null && fighter.ID == selectedFighter.ID)
            {
                updateSelected(elapsed);
            }

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
        }
    }

    public override function changeDirection(fighter:Fighter)
    {
        if (selectedFighter != null && fighter.ID == selectedFighter.ID)
        {
            return;
        }
        super.changeDirection(fighter);
    }


    private var selectedFighter:Fighter;
}