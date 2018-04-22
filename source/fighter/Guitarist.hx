package fighter;

import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxPath;

import spells.Spell;
import spells.SonicBang;

class Guitarist extends Fighter
{
    public function new(X:Float, Y:Float, ?SimpleGraphic:FlxGraphicAsset)
    {
        super(X, Y, SimpleGraphic);

        baseAcceleration = 50;
        baseSpeed = 120;

        path = new FlxPath();
        path.setProperties(baseSpeed, FlxPath.FORWARD, false);
    }

    public override function melee(other:Fighter)
    {
        canMelee = false;
        other.hit(2);
        SoundHelper.playSFX(AssetPaths.guitar__ogg, AssetPaths.guitar__mp3);

        meleeCooldown.start(.3, function(_)
        {
            canMelee = true;
        }, 1);
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}