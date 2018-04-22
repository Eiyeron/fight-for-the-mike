package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import flixel.text.FlxText;


class MenuState extends FlxState
{
    override public function create()
    {
        var logo = new FlxSprite(FlxG.width/2 - 24, 72,AssetPaths.logo__png);
        logo.offset.set(logo.width/2, logo.height/2);
        add(new FlxSprite(0,0, AssetPaths.Ring__png));
        add(logo);

        var current = new FlxText(FlxG.width*3/4 + 10, logo.y, -1,  "Current Genre!");
        current.offset.set(current.width/2, current.height/2);
        current.angle = 45;
        add(current);
        currentTrendFlx = new FlxText(FlxG.width*3/4 - 10, logo.y + 10, -1,  Global.currentTrend);
        currentTrendFlx.offset.set(currentTrendFlx.width/2, currentTrendFlx.height/2);
        currentTrendFlx.angle = 45;
        add(currentTrendFlx);



        var start = new FlxButton(FlxG.width / 2, FlxG.height/2 - 10, "Start!", function()
        {
            FlxG.switchState(new PlayState());
        });
        start.loadGraphic(AssetPaths.button_back__png, true, 64, 25);
        start.label.color = FlxColor.fromRGB(179,185, 209);
        start.x -= start.width/2;
        add(start);

        var help = new FlxButton(FlxG.width / 2, FlxG.height/2 + 22, "Help", function()
        {
            FlxG.switchState(new HelpState());
        });
        help.loadGraphic(AssetPaths.button_back__png, true, 64, 25);
        help.label.color = FlxColor.fromRGB(179,185, 209);
        help.x -= start.width/2;
        add(help);

        var fightFor = new FlxText(FlxG.width/4, FlxG.height/2 + 86, -1, "Fight to make this genre to the top!");
        fightFor.x = (FlxG.width - fightFor.width) / 2;
        add(fightFor);
        var nextTrend = new FlxText(FlxG.width/4, FlxG.height/2 + 96, -1, Global.playerTrend);
        nextTrend.x = FlxG.width/2 - nextTrend.width/2;
        add(nextTrend);

        var anotherGenre = new FlxButton(FlxG.width / 2, FlxG.height/2 + 54, "Another Genre!", function()
        {
            Global.playerTrend = TrendGenerator.generate();
            nextTrend.text = Global.playerTrend;
            nextTrend.x = FlxG.width/2 - nextTrend.width/2;
        });
        anotherGenre.loadGraphic(AssetPaths.button_back__png, true, 64, 25);
        anotherGenre.label.color = FlxColor.fromRGB(179,185, 209);
        anotherGenre.labelOffsets[0].y = 0;
        anotherGenre.labelOffsets[1].y = 0;
        anotherGenre.x -= anotherGenre.width/2;
        add(anotherGenre);

        super.create();
    }

    public var currentTrendFlx:FlxText;

}