package spells;

import fighter.Fighter;

class DrumDrill extends Spell
{
    public function new()
    {
        isAttack = true;
        aoe = true;
        range = 20;
        aoeRange = 20;
        cooldown = 5;
    }

    private override function effect(target:Fighter)
    {
        SoundHelper.playSFX(AssetPaths.drill_drum__ogg, AssetPaths.drill_drum__mp3);
        target.hit(10);
    }
}