package fighter;

import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.util.FlxTimer;


import spells.Spell;
import stuff.Explosion;
import stuff.Indicator;


class Fighter extends FlxSprite
{
    static var nextID:Int = 0;
    public function new(X:Float, Y:Float, ?SimpleGraphic:FlxGraphicAsset)
    {
        super (X, Y);

        shadow = new FlxSprite();
        shadow.loadGraphic(AssetPaths.shadow__png);
        shadow.alpha = 0.5;

        this.loadGraphic(SimpleGraphic, true, 12, 16);
        this.animation.add("stand_b", [0], 1, false);
        this.animation.add("stand_t", [1], 1, false);
        this.animation.add("stand_l", [2], 1, false);
        this.animation.add("stand_r", [3], 1, false);

        this.animation.add("walk_b", [4,5,6,7], 10, false);
        this.animation.add("walk_t", [8,9,10,11], 10, false);
        this.animation.add("walk_l", [12,13,14,15], 10, false);
        this.animation.add("walk_r", [16,17,18,19], 10, false);

        this.animation.add("attack_b", [20], 1, false);
        this.animation.add("attack_t", [21], 1, false);
        this.animation.add("attack_l", [22], 1, false);
        this.animation.add("attack_r", [23], 1, false);

        // width = 6;
        // height = 6;
        // offset.set(3, 9);

        this.ID = nextID;
        nextID++;
        meleeCooldown = new FlxTimer();
        spellCooldown = new FlxTimer();
        spells = [];
        lifebar = new FlxBar(0, 0, FlxBarFillDirection.HORIZONTAL_INSIDE_OUT, 32, 8, this, "life", 0, 30, true);
        indicator = new Indicator();
        indicator.animation.frameIndex = 1;

        lifebar.trackParent(-12, -16);
        avoidTimer = new FlxTimer();

        explosions = new FlxTypedEmitter<Explosion>(0, 0, 10);
        explosions.focusOn(this);
        for( i in 0...10)
            explosions.add(new Explosion());

    }

    function anim(anim:String, angle:Float)
    {
        if (angle >= -45 && angle <= 45)
            anim += "_b";
        else if (angle >= 45 && angle <= 135)
            anim += "_l";
        else if (angle >= 135 || angle <= -135)
            anim += "_t";
        else if (angle >= -135 && angle <= -45)
            anim += "_r";
        animation.play(anim);
    }

    public function moveTo(point:FlxPoint, useOverride:Bool = false)
    {
        if(moveOveridden && !useOverride)
        {
            return;
        }
        var start = this.getPosition().add( _halfSize.x,  _halfSize.y);
        path.start([start, point]);
        var directionPoint = FlxPoint.get();
        directionPoint.copyFrom(point).subtractPoint(start);

        var direction:FlxVector = directionPoint.toVector();
        anim("walk", direction.angleBetween(FlxPoint.get()));
    }

    public function hit(damage:Float)
    {
        life = Math.max(life - damage, 0);
        if (life == 0)
        {
            kill();
            explosions.start(true, 3, 10);
            active = false;
            visible = false;
            lifebar.kill();
            shadow.kill();
            indicator.animation.frameIndex = 2;
        }
        else
        {
            explosions.start(true, 2, 2);
        }

    }

    public function castSpellToTarget(spell:Spell, target:Fighter)
    {
        if (spells.indexOf(spell) == -1 || ! canSpell)
        {
            return;
        }

        if (path.active)
        {
            path.active = false;
        }

        canSpell = false;
        spell.launchToTarget(target);
        var directionPoint = FlxPoint.get();
        directionPoint.copyFrom(target.getPosition()).subtractPoint(getPosition());
        var direction:FlxVector = directionPoint.toVector();
        anim("attack", direction.angleBetween(FlxPoint.get()));


        spellCooldown.start(spell.cooldown, function(_)
        {
            canSpell = true;
        }, 1);
    }

    public function castSpellToPoint(spell:Spell, point:FlxPoint, potentialTargets:FlxGroup)
    {
        if (spells.indexOf(spell) == -1 || !canSpell)
        {
            return;
        }

        if (path.active)
        {
            path.active = false;
        }

        canSpell = false;
        spell.launchToPoint(point, potentialTargets);
        var directionPoint = FlxPoint.get();
        directionPoint.copyFrom(point).subtractPoint(getPosition());
        var direction:FlxVector = directionPoint.toVector();
        anim("attack", direction.angleBetween(FlxPoint.get()));


        spellCooldown.start(spell.cooldown, function(_)
        {
            canSpell = true;
        }, 1);
    }


    public function melee(other:Fighter)
    {
        canMelee = false;
        other.hit(3);

        var directionPoint = FlxPoint.get();
        directionPoint.copyFrom(other.getPosition()).subtractPoint(getPosition());
        var direction:FlxVector = directionPoint.toVector();
        anim("attack", direction.angleBetween(FlxPoint.get()));

        meleeCooldown.start(1, function(_)
        {
            canMelee = true;
        }, 1);
    }

    public override function update(elapsed:Float)
    {
        if (!alive)
        {
            return;
        }
        super.update(elapsed);
        shadow.x = x+2;
        shadow.y = y+13;
        explosions.setPosition(x, y);
    }

    public var life:Float = 30;
    public var lifebar(default, null):FlxBar;
    public var indicator(default, null):Indicator;

    public var canMelee(default, null):Bool = true;
    private var meleeCooldown:FlxTimer;
    public var canSpell(default, null):Bool = true;
    private var spellCooldown:FlxTimer;

    public var spells(default, null):Array<Spell>;
    private var baseAttack:Float;
    private var baseDefense:Float;

    private var baseAcceleration:Float;
    private var baseSpeed:Float;
    private var moveTarget:FlxPoint;

    public var avoiding:Bool = false;
    public var avoidDirection:FlxVector;
    public var avoidTimer:FlxTimer;

    public var explosions:FlxTypedEmitter<Explosion>;

    public var shadow:FlxSprite;

    public var moveOveridden:Bool = false;

}