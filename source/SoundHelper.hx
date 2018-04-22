package;

import flixel.FlxG;

class SoundHelper
{
    public static function playSFX(ogg:Dynamic, mp3:Dynamic)
    {
        if (!FlxG.sound.play(ogg).playing)
        {
            if (!FlxG.sound.play(mp3).playing)
            {
                FlxG.log.error("COuldn't play " + ogg);
            }
        }
    }


}