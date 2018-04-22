package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;

import fighter.*;

class HelpState extends FlxState
{
    override public function create()
    {
        var background = new FlxSprite(0,0, AssetPaths.Ring__png);
        add(background);
        var back = new FlxButton(16, FlxG.height*3/4, "Back!", function()
        {
            if(!switching)
            {
                switching = true;
                FlxTween.color(background, 0.5, FlxColor.GRAY, FlxColor.WHITE,
                {
                    onComplete: function(_)
                    {
                       FlxG.switchState(new MenuState());
                    }
                });
            }
        });
        back.loadGraphic(AssetPaths.button_back__png, true, 64, 25);
        back.label.color = FlxColor.fromRGB(179,185, 209);
        FlxTween.color(background, 0.5, FlxColor.WHITE, FlxColor.GRAY,
        {
            onComplete: function(_)
            {
                add(back);
                add(new FlxText(16, 16, -1, "Beat the other team (the ones in red pants) and fight to\nbecome the new #1 band with your brand new music genre!"));

                add(new FlxText(16, 48, -1, "[Controls]\nLeft click : Select a character\nRight click : move your character\n\nYour characters automatically attack.\nYou can let them fight or try to place them in a better way."));

                singer = new Singer(16, 120, AssetPaths.singer__png);
                singer.active = false;
                add(singer);
                add(new FlxText(32, 120, -1, "Uses their voice to make sonic bangs!"));

                drummer = new Drummer(16, 136, AssetPaths.drummer__png);
                drummer.active = false;
                add(drummer);
                add(new FlxText(32, 136, -1, "Invokes the power of the drums!!"));

                guitarist = new Guitarist(16, 152, AssetPaths.guitarist__png);
                guitarist.active = false;
                add(guitarist);
                add(new FlxText(32, 152, -1, "Hacks and Slash like an Axe!"));
            }
        });


        super.create();
    }

    public var currentTrendFlx:FlxText;
    private var switching:Bool;

    var singer:Fighter;
    var drummer:Fighter;
    var guitarist:Fighter;

    public override function update(elapsed:Float)
    {
        if (FlxG.mouse.justMoved && singer != null && drummer != null && guitarist != null)
        {
            var pos = FlxG.mouse.getWorldPosition();
            if (singer.overlapsPoint(pos))
            {
                singer.animation.frameIndex = 20;
            }
            else
            {
                singer.animation.frameIndex = 0;
            }
            if (drummer.overlapsPoint(pos))
            {
                drummer.animation.frameIndex = 20;
            }
            else
            {
                drummer.animation.frameIndex = 0;
            }
            if (guitarist.overlapsPoint(pos))
            {
                guitarist.animation.frameIndex = 20;
            }
            else
            {
                guitarist.animation.frameIndex = 0;
            }
        }

        super.update(elapsed);

    }

}