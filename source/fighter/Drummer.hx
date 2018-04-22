package fighter;

import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxPath;

import spells.Spell;
import spells.DrumDrill;

class Drummer extends Fighter
{
    public function new(X:Float, Y:Float, ?SimpleGraphic:FlxGraphicAsset)
    {
        super(X, Y, SimpleGraphic);

        baseAcceleration = 30;
        baseSpeed = 70;

        life = 40;

        spells.push(drumDrill);

        path = new FlxPath();
        path.setProperties(baseSpeed, FlxPath.FORWARD, false);
    }


    public override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    public var drumDrill(default, null):Spell = new DrumDrill();

}