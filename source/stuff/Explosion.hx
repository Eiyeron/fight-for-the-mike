package stuff;

import flixel.effects.particles.FlxParticle;

class Explosion extends FlxParticle
{
    public function new()
    {
        super();
        loadGraphic(AssetPaths.explosion__png, true, 12, 12);
        animation.add("boom", [0,1,2,3,4], Std.int(60/5), false);
        exists = false;
    }

    public override function onEmit()
    {
        animation.play("boom", true, false);
        lifespan = .5;
        velocityRange.start.set(0.5, 0.5);
        velocityRange.end.set(0,0);

    }

}