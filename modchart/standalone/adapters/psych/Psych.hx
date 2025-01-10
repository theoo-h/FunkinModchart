package modchart.standalone.adapters.psych;

#if (FM_ENGINE_VERSION == "1.0" || FM_ENGINE_VERSION == "0.7")
import backend.ClientPrefs;
import backend.Conductor;
import objects.Note;
import objects.StrumNote as Strum;
import states.PlayState;
#else
import ClientPrefs;
import Conductor;
import Note;
import PlayState;
import StrumNote as Strum;
#end
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import modchart.Manager;
import modchart.standalone.IAdapter;

class Psych implements IAdapter {
	private var __fCrochet:Float = 0;

	private var __receptorXs:Array<Array<Float>>;
	private var __receptorYs:Array<Array<Float>>;

	public function new() {
		try {
			setupLuaFunctions();
		} catch (e) {
			trace('[ From FunkinModchart Adapter ] Failed while adding lua functions: $e');
		}
	}

	public function onModchartingInitialization() {
		__fCrochet = Conductor.crochet;

		__receptorXs = [];
		__receptorYs = [];

		@:privateAccess
		PlayState.instance.strumLineNotes.forEachAlive(strumNote -> {
			if (__receptorXs[strumNote.player] == null)
				__receptorXs[strumNote.player] = [];
			if (__receptorYs[strumNote.player] == null)
				__receptorYs[strumNote.player] = [];

			__receptorXs[strumNote.player][strumNote.noteData] = strumNote.x;
			__receptorYs[strumNote.player][strumNote.noteData] = getDownscroll() ? FlxG.height - strumNote.y - Manager.ARROW_SIZE : strumNote.y;
		});
	}

	private function setupLuaFunctions() {
		#if LUA_ALLOWED
		// todo
		#end
	}

	public function isTapNote(sprite:FlxSprite) {
		return sprite is Note;
	}

	// Song related
	public function getSongPosition():Float {
		return Conductor.songPosition;
	}

	public function getCurrentBeat():Float {
		@:privateAccess
		return PlayState.instance.curDecBeat;
	}

	public function getStaticCrochet():Float {
		return __fCrochet + 8;
	}

	public function arrowHit(arrow:FlxSprite) {
		if (arrow is Note)
			return cast(arrow, Note).wasGoodHit;
		return false;
	}

	public function isHoldEnd(arrow:FlxSprite) {
		if (arrow is Note) {
			final castedNote = cast(arrow, Note);

			if (castedNote.nextNote != null)
				return !castedNote.nextNote.isSustainNote;
		}
		return false;
	}

	public function getLaneFromArrow(arrow:FlxSprite) {
		if (arrow is Note)
			return cast(arrow, Note).noteData;
		else if (arrow is Strum) @:privateAccess
			return cast(arrow, Strum).noteData;

		return 0;
	}

	public function getPlayerFromArrow(arrow:FlxSprite) {
		if (arrow is Note)
			return cast(arrow, Note).mustPress ? 1 : 0;
		else if (arrow is Strum) @:privateAccess
			return cast(arrow, Strum).player;

		return 0;
	}

	public function getKeyCount(?player:Int = 0):Int {
		return 4;
	}

	public function getPlayerCount():Int {
		return 2;
	}

	public function getTimeFromArrow(arrow:FlxSprite) {
		if (arrow is Note)
			return cast(arrow, Note).strumTime;

		return 0;
	}

	public function getHoldSubdivisions():Int {
		return 4;
	}

	// psych adjust the strum pos at the begin of playstate
	public function getDownscroll():Bool {
		return ClientPrefs.data.downScroll;
	}

	public function getDefaultReceptorX(lane:Int, player:Int):Float {
		return __receptorXs[player][lane];
	}

	public function getDefaultReceptorY(lane:Int, player:Int):Float {
		return __receptorYs[player][lane];
	}

	public function getArrowCamera():Array<FlxCamera>
		return [PlayState.instance.camHUD];

	public function getCurrentScrollSpeed():Float {
		return PlayState.instance.songSpeed;
	}

	// 0 receptors
	// 1 tap arrows
	// 2 hold arrows
	public function getArrowItems() {
		var pspr:Array<Array<Array<FlxSprite>>> = [[[], [], []], [[], [], []]];

		@:privateAccess
		PlayState.instance.strumLineNotes.forEachAlive(strumNote -> {
			if (pspr[strumNote.player] == null)
				pspr[strumNote.player] = [];

			pspr[strumNote.player][0].push(strumNote);
		});
		PlayState.instance.notes.forEachAlive(strumNote -> {
			final player = Adapter.instance.getPlayerFromArrow(strumNote);
			if (pspr[player] == null)
				pspr[player] = [];

			pspr[player][strumNote.isSustainNote ? 2 : 1].push(strumNote);
		});

		return pspr;
	}
}
