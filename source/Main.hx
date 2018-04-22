package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
        #if js
        untyped {
            document.oncontextmenu = document.body.oncontextmenu = function() {return false;}
        }
        #end

		super();
		addChild(new FlxGame(320, 240, MenuState));
        FlxG.autoPause = false;
	}
}
