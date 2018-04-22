package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

import fighter.Fighter;
import fighter.Singer;
import fighter.Drummer;
import fighter.Guitarist;

import controllers.PlayerController;
import controllers.AIController;


class PlayState extends FlxState
{
    var playerSinger:Fighter;
    var playerDrummer:Fighter;
    var playerGuitarist:Fighter;
    var playerTeam:FlxGroup;

    var aiSinger:Fighter;
    var aiDrummer:Fighter;
    var aiGuitarist:Fighter;
    var aiTeam:FlxGroup;

    var playerController:PlayerController;
    var aiController:AIController;

    var cameraTarget:FlxObject;

    var background:FlxSprite;
    var walls:FlxGroup;

    var bgMusic:FlxSound;

    var itsOn:Bool = false;
    var itsDone:Bool = false;

	override public function create():Void
	{

        bgMusic = new FlxSound();
        bgMusic.loadStream(AssetPaths.unnamed__ogg, true, true);
        if(!bgMusic.exists)
        {
            bgMusic.loadStream(AssetPaths.unnamed__mp3, true, true);
        }
        if(!bgMusic.exists)
        {
            FlxG.log.error("Couldn't load a stream");
        }
        bgMusic.play();

        background = new FlxSprite(0,0,AssetPaths.Ring__png);
        add(background);
        walls = new FlxGroup();
        walls.add(new FlxObject(0,0,32,240));
        walls.add(new FlxObject(320-32,0,32,240));
        walls.add(new FlxObject(0,0,320,40));
        walls.add(new FlxObject(0,240-8,320,32));
        //corners
        walls.add(new FlxObject(32, 40, 16, 16));
        walls.add(new FlxObject(32, 218, 16, 16));
        walls.add(new FlxObject(272, 40, 16, 16));
        walls.add(new FlxObject(272, 218, 16, 16));
        walls.forEachOfType(FlxObject, function(object)
        {
            object.immovable = true;
            object.solid = true;
        });
        add(walls);

        playerTeam = new FlxGroup();
        aiTeam = new FlxGroup();

        cameraTarget = new FlxObject(FlxG.width / 2, FlxG.height / 2);
        add(cameraTarget);
        FlxG.camera.follow(cameraTarget, FlxCameraFollowStyle.TOPDOWN);

        playerSinger = new Singer(FlxG.width/2, FlxG.height*3/4, AssetPaths.singer__png);
        playerDrummer = new Drummer(FlxG.width/4, FlxG.height*3/4, AssetPaths.drummer__png);
        playerGuitarist = new Guitarist(FlxG.width*3/4, FlxG.height*3/4, AssetPaths.guitarist__png);

        aiSinger = new Singer(FlxG.width/2, FlxG.height/4, AssetPaths.singer_b__png);
        aiDrummer = new Drummer(FlxG.width/4, FlxG.height/4, AssetPaths.drummer_b__png);
        aiGuitarist = new Guitarist(FlxG.width*3/4, FlxG.height/4, AssetPaths.guitarist_b__png);


        playerTeam.add(playerSinger);
        playerTeam.add(playerDrummer);
        playerTeam.add(playerGuitarist);
        aiTeam.add(aiSinger);
        aiTeam.add(aiDrummer);
        aiTeam.add(aiGuitarist);

        playerSinger.indicator.setPosition(12, 108);
        playerDrummer.indicator.setPosition(12, 124);
        playerGuitarist.indicator.setPosition(12, 140);
        aiSinger.indicator.setPosition(298, 108);
        aiDrummer.indicator.setPosition(298, 124);
        aiGuitarist.indicator.setPosition(298, 140);

        aiTeam.forEachOfType(Fighter, function(f)
        {
            add(f.shadow);
            add(f.lifebar);
            add(f.indicator);
        });
        playerTeam.forEachOfType(Fighter, function(f)
        {
            add(f.shadow);
            add(f.lifebar);
            add(f.indicator);
        });
        aiTeam.forEachOfType(Fighter, function(f)
        {
            add(f.explosions);
        });
        playerTeam.forEachOfType(Fighter, function(f)
        {
            add(f.explosions);
        });


        add(playerTeam);
        add(aiTeam);

        playerController = new PlayerController(playerTeam);
        aiController = new AIController(aiTeam);
        aiController.fightAgainst(playerTeam);
        playerController.fightAgainst(aiTeam);


        var counter = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
        counter.loadGraphic(AssetPaths.start_timer__png, true, 26, 39);
        counter.offset.set(counter.width/2, counter.height/2);

        SoundHelper.playSFX(AssetPaths.start_timer_three__ogg, AssetPaths.start_timer_three__mp3);
        FlxTween.tween(counter.scale,{x:0, y:0}, 1,
        {
            onComplete: function(_)
            {
                counter.scale.set(1,1);
                counter.animation.frameIndex = 1;
                SoundHelper.playSFX(AssetPaths.start_timer_two__ogg, AssetPaths.start_timer_two__mp3);
            }
        }).then(FlxTween.tween(counter.scale,{x:0, y:0}, 1,
        {
            onComplete: function(_)
            {
                counter.scale.set(1,1);
                counter.animation.frameIndex = 2;
                SoundHelper.playSFX(AssetPaths.start_timer_one__ogg, AssetPaths.start_timer_one__mp3);
            }
        })).then(FlxTween.tween(counter.scale,{x:0, y:0}, 1.5,
        {
            onComplete: function(_)
            {
                counter.kill();
                itsOn = true;
                SoundHelper.playSFX(AssetPaths.start__ogg, AssetPaths.start__mp3);
            }
        }));

        super.add(counter);

        super.create();
	}

    override public function switchTo(nextState:FlxState):Bool
	{
        bgMusic.fadeOut(0.2, 0, function(_)
        {
            bgMusic.stop();
        });
		return true;
	}

	override public function destroy():Void
	{
        bgMusic.stop();
        super.destroy();
	}


    public function checkEndOfRound(numFighters:Int, replaceGenreIfWin:Bool)
    {
            if (numFighters == 0 && !itsDone)
            {
                FlxG.log.add("Done!");
                itsDone = true;
                var timer = new FlxTimer();
                timer.start(2, function(_)
                {
                    Global.currentTrend = Global.playerTrend;
                    Global.playerTrend = TrendGenerator.generate();
                    FlxG.switchState(new MenuState());
                });
            }
    }

	override public function update(elapsed:Float):Void
	{
        if (itsOn)
        {
            playerController.update(elapsed);
            aiController.update(elapsed);
            aiTeam.forEachAlive(function(f)
            {
                var f = cast(f, Fighter);
                f.immovable = false;
            });
            playerTeam.forEachAlive(function(f)
            {
                var f = cast(f, Fighter);
                f.immovable = false;
            });
            FlxG.collide(playerTeam, walls, function(basic,_)
            {
                playerController.changeDirection(cast basic);
            });
            FlxG.collide(aiTeam, walls, function(basic,_)
            {
                aiController.changeDirection(cast basic);
            });

            // var targetPosition = FlxPoint.get(0,0);
            // cameraTarget.setPosition(0,0);
            var numFighters:Int = 0;
            aiTeam.forEachAlive(function(f)
            {
                numFighters++;
                // var f = cast(f, Fighter);
                // targetPosition.addPoint(f.getPosition());
            });
            checkEndOfRound(numFighters, false);

            numFighters = 0;
            playerTeam.forEachAlive(function(f)
            {
                numFighters++;
                // var f = cast(f, Fighter);
                // targetPosition.addPoint(f.getPosition());
            });
            checkEndOfRound(numFighters, true);


            // if (numFighters > 0)
            // {
            //     targetPosition.x /= numFighters;
            //     targetPosition.y /= numFighters;
            //     cameraTarget.setPosition(targetPosition.x, targetPosition.y);
            // }

            super.update(elapsed);

            // Push back
            aiTeam.forEachAlive(function(f)
            {
                var f = cast(f, Fighter);
                f.immovable = false;
            });
            playerTeam.forEachAlive(function(f)
            {
                var f = cast(f, Fighter);
                f.immovable = false;
            });
            FlxG.collide(playerTeam, walls, function(basic,_)
            {
                playerController.changeDirection(cast basic);
            });
            FlxG.collide(aiTeam, walls, function(basic,_)
            {
                aiController.changeDirection(cast basic);
            });

        }
        else
        {
            super.update(elapsed);
        }


	}
}
