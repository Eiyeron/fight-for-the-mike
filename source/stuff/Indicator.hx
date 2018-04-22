package stuff;

import flixel.FlxSprite;

class Indicator extends FlxSprite
{

    public function new ()
    {
        super();
        loadGraphic(AssetPaths.Indicators__png, true, 10, 10);
        animation.frameIndex = 0;
    }

}