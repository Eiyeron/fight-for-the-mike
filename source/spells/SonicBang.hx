package spells;

import fighter.Fighter;

class SonicBang extends Spell
{
    public function new()
    {
        isAttack = true;
        range = 80;
        cooldown = 2;
    }

    private override function effect(target:Fighter)
    {
        SoundHelper.playSFX(AssetPaths.boom__ogg, AssetPaths.boom__mp3);

        target.hit(5);
    }
}