package fighter;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.util.FlxTimer;

import spells.Spell;
import spells.SonicBang;

class Singer extends Fighter
{
    public function new(X:Float, Y:Float, ?SimpleGraphic:FlxGraphicAsset)
    {
        super(X, Y, SimpleGraphic);

        baseAcceleration = 30;
        baseSpeed = 90;

        spells.push(sonicBang);

        path = new FlxPath();
        path.setProperties(baseSpeed, FlxPath.FORWARD, false);
    }

    public override function hit(damage:Float)
    {
        var previousLife:Float = life;
        super.hit(damage);
        if (previousLife > 10 && damage <= 10)
        {
            fleeing = true;
            var timer = new FlxTimer();
            timer.start(1, function(_)
            {
                fleeing = false;
            }, 1);
        }
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    public var sonicBang(default, null):Spell = new SonicBang();
    public var fleeing(default, null):Bool = false;

}