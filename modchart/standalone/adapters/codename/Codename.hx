package modchart.standalone.adapters.codename;

import flixel.FlxCamera;
import flixel.FlxSprite;
import funkin.game.Strum;
import funkin.game.Note;
import funkin.game.PlayState;
import funkin.options.Options;
import funkin.backend.system.Conductor;
import modchart.standalone.IAdapter;

class Codename implements IAdapter
{
    private var __fCrochet:Float = 0;

    public function new() {}

    public function onModchartingInitialization()
    {
        __fCrochet = Conductor.crochet;

        for (strumLine in PlayState.instance.strumLines.members)
		{
			strumLine.forEach(strum -> {
				strum.extra.set('field', strumLine.ID);
				// i guess ???
				strum.extra.set('lane', strumLine.members.indexOf(strum));
			});
		}
    }

    public function isTapNote(sprite:FlxSprite)
    {
        return sprite is Note;
    }
    // Song related
    public function getSongPosition():Float
    {
        return Conductor.songPosition;
    }
    public function getCurrentBeat():Float
    {
        return Conductor.curBeatFloat;
    }
    public function getStaticCrochet():Float
    {
        return __fCrochet;
    }

    public function arrowHit(arrow:FlxSprite)
    {
        if (arrow is Note)
        {
            final note:Note = cast arrow;
            return note.wasGoodHit;
        }
        return false;
    }

    public function isHoldEnd(arrow:FlxSprite)
    {
        if (arrow is Note)
        {
            final note:Note = cast arrow;
            return note.nextSustain == null;
        }
        return false;
    }

    public function getLaneFromArrow(arrow:FlxSprite)
	{
		if (arrow is Note)
        {
            final note:Note = cast arrow;
            return note.strumID;
        }
		else if (arrow is Strum)
        {
            final strum:Strum = cast arrow;
            return strum.extra.get('lane');
        }

		return 0;
	}
	public function getPlayerFromArrow(arrow:FlxSprite)
	{
        if (arrow is Note)
        {
            final note:Note = cast arrow;
            return note.strumLine.ID;
        }
		else if (arrow is Strum)
        {
            final strum:Strum = cast arrow;
            return strum.extra.get('field');
        }

		return 0;
	}

    // im so fucking sorry for those conditionals
	public function getKeyCount(?player:Int = 0):Int
	{
        return PlayState.instance != null && PlayState.instance.strumLines != null && PlayState.instance.strumLines.members != null && PlayState.instance.strumLines.members[player] != null && PlayState.instance.strumLines.members[player].members != null
        ? PlayState.instance.strumLines.members[player].members.length
        : 4;
	}
	public function getPlayerCount():Int
	{
        return PlayState.instance != null && PlayState.instance.strumLines != null
            ? PlayState.instance.strumLines.length
            : 2;
	}

	public function getTimeFromArrow(arrow:FlxSprite)
	{
        if (arrow is Note)
        {
            final note:Note = cast arrow;
            return note.strumTime;
        }

		return 0;
	}

	public function getHoldSubdivisions():Int
	{
        final val = Options.hold_subs;
		return val < 1 ? 1 : Options.hold_subs;
	}
    public function getDownscroll():Bool
	{
		return Options.downscroll;
	}
	public function getDefaultReceptorX(lane:Int, field:Int):Float
	{
        @:privateAccess
		return PlayState.instance.strumLines.members[field].startingPos.x + ((Manager.ARROW_SIZE) * lane);
	}
	public function getDefaultReceptorY(lane:Int, field:Int):Float
	{
        @:privateAccess
		return PlayState.instance.strumLines.members[field].startingPos.y;
	}

    public function getArrowCamera():Array<FlxCamera>
        return [PlayState.instance.camHUD];

    public function getCurrentScrollSpeed():Float
    {
        return PlayState.instance.scrollSpeed;
    }

    // 0 receptors
    // 1 tap arrows
    // 2 hold arrows
    public function getArrowItems()
    {
        var pspr:Array<Array<Array<FlxSprite>>> = [];

        var strumLineMembers = PlayState.instance.strumLines.members;

        for (i in 0...strumLineMembers.length)
        {
            final sl = strumLineMembers[i];

            // this is somehow more optimized than how i used to do it (thanks neeo for the code!!)
            pspr[i] = [];
            pspr[i][0] = cast sl.members.copy();
            pspr[i][1] = [];
            pspr[i][2] = [];

            var st = 0;
            var nt = 0;
            sl.notes.forEachAlive((spr) -> {spr.isSustainNote ? st++ : nt++;});

            pspr[i][1].resize(nt);
            pspr[i][2].resize(st);

            var si = 0;
            var ni = 0;
            sl.notes.forEachAlive((spr) -> pspr[i][spr.isSustainNote ? 2 : 1][spr.isSustainNote ? si++ : ni++] = spr);
        }

        return pspr;
    }
}