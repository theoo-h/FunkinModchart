package modchart.standalone.adapters.imaginative;

import flixel.FlxCamera;
import flixel.FlxSprite;
import imaginative.backend.music.Conductor;
import imaginative.backend.scripting.types.GlobalScript;
import imaginative.backend.system.Settings;
import imaginative.objects.gameplay.arrows.ArrowField;
import imaginative.objects.gameplay.arrows.Note;
import imaginative.objects.gameplay.arrows.Strum;
import imaginative.objects.gameplay.arrows.Sustain;
import imaginative.states.PlayState;

class Imaginative implements IAdapter {
	/**
	 * I normally use 4.3.6 and since this is supposed to work on older haxe versions I should probably do this. --@rodney528
	 */
	inline function checkIfNull<T>(val:Null<T>, def:T):Void
		return val == null ? def : val;

	// like this so scripts can fuck with it
	public var getConductor:Void->Conductor;
	public var getCameras:Void->Array<FlxCamera>;
	// work around for imaginative being tag based instead of numeric
	public var arrowFields:Array<ArrowField> = [];

	var startingFieldPositions:Array<Array<Float>> = [];

	function refreshStartingPositions(?player:Int) {
		if (player == null) {
			startingFieldPositions.clear();
			for (field in arrowFields) {
				var positions:Array<Float> = [];
				for (strum in field)
					positions.push([strum.x, strum.y]);
				startingFieldPositions.push(positions);
			}
		} else {
			var positions:Array<Float> = [];
			for (strum in arrowFields[player])
				positions.push([strum.x, strum.y]);
			startingFieldPositions[player] = positions;
		}
	}

	public function new() {}

	public function onModchartingInitialization() {
		if (PlayState.instance == null) {
			getConductor = () -> return Conductor.mainDirect;
			if (ArrowField.enemy != null)
				arrowFields.push(ArrowField.enemy);
			if (ArrowField.player != null)
				arrowFields.push(ArrowField.player);
			getCameras = () -> return arrowFields.length != 0 ? arrowFields[arrowFields.length - 1].cameras : [FlxG.camera];

			// global script
			GlobalScript.set('setModchartCameras', (cameras:Array<FlxCamera>) -> getCameras = () -> return checkIfNull(cameras, [FlxG.camera]));
			GlobalScript.call('onModchartInit', [this]);
			GlobalScript.set('refreshDefaultFieldPoses', refreshStartingPositions);
		} else {
			getConductor = () -> return Conductor.song;
			var game:PlayState = PlayState.instance;
			getCameras = () -> return [game.camHUD];
			arrowFields = [
				for (tag => field in game.arrowFieldMapping)
					if (PlayState.chartData.fieldSettings.order.contains(tag)) field
			];

			// global script
			GlobalScript.set('setModchartCameras', (cameras:Array<FlxCamera>) -> getCameras = () -> return checkIfNull(cameras, [FlxG.camera]));
			GlobalScript.call('onModchartInit', [this]);
			GlobalScript.set('refreshDefaultFieldPoses', refreshStartingPositions);

			// song scripts
			game.scripts.set('setModchartCameras', (cameras:Array<FlxCamera>) -> getCameras = () -> return checkIfNull(cameras, [FlxG.camera]));
			game.scripts.call('onModchartInit', [this]);
			game.scripts.set('refreshDefaultFieldPoses', refreshStartingPositions);
		}
		refreshStartingPositions();
	}

	public function getSongPosition()
		return getConductor().time;

	public function getStaticCrochet()
		return 60 / getConductor().startBpm * 1000;

	public function getCurrentBeat():Float
		return getConductor().curBeatFloat;

	// gonna be a little inaccurate due to strumlines having their own individual scrollspeed vars
	public function getCurrentScrollSpeed():Float
		return Settings.setupP1.enablePersonalScrollSpeed ? Settings.setupP1.personalScrollSpeed : PlayState.chartData.speed;

	public function getDefaultReceptorX(lane:Int, player:Int)
		return startingFieldPositions[player][lane][0];

	public function getDefaultReceptorY(lane:Int, player:Int)
		return startingFieldPositions[player][lane][1];

	public function getBeatFromStep(step:Float):Float
		return step * getConductor().stepsPerBeat;

	public function getTimeFromArrow(arrow:FlxSprite) {
		if (arrow is Note)
			return cast(arrow, Note).time;
		if (arrow is Sustain) {
			var sustain:Sustain = cast arrow;
			return sustain.setHead.time + sustain.time;
		}
		return 0;
	}

	public function isTapNote(sprite:FlxSprite)
		return sprite is Note || sprite is Sustain;

	public function isHoldEnd(sprite:FlxSprite) {
		if (sprite is Sustain)
			return cast(sprite, Sustain).isEnd;
		return false;
	}

	public function arrowHit(sprite:FlxSprite) {
		if (sprite is Note)
			return cast(sprite, Note).wasHit;
		if (sprite is Sustain)
			return cast(sprite, Sustain).wasHit;
		return false;
	}

	public function getHoldParentTime(sprite:FlxSprite) {
		if (sprite is Note)
			return cast(sprite, Note).time;
		if (sprite is Sustain)
			return cast(sprite, Sustain).setHead.time;
		return 0;
	}

	public function getLaneFromArrow(sprite:FlxSprite) {
		if (sprite is Strum)
			return cast(sprite, Strum).id;
		if (sprite is Note)
			return cast(sprite, Note).id;
		if (sprite is Sustain)
			return cast(sprite, Sustain).id;
		return 0;
	}

	public function getPlayerFromArrow(sprite:FlxSprite) {
		if (sprite is Strum) {
			var arrowField:ArrowField = cast(sprite, Strum).setField;
			if (arrowFields.contains(arrowField))
				return arrowFields.indexOf(arrowField);
		}
		if (sprite is Note) {
			var arrowField:ArrowField = cast(sprite, Note).setField;
			if (arrowFields.contains(arrowField))
				return arrowFields.indexOf(arrowField);
		}
		if (sprite is Sustain) {
			var arrowField:ArrowField = cast(sprite, Sustain).setField;
			if (arrowFields.contains(arrowField))
				return arrowFields.indexOf(arrowField);
		}
		return 0;
	}

	public function getKeyCount(?player:Int)
		return arrowFields[player].strumCount;

	public function getPlayerCount()
		return arrowFields.length;

	public function getArrowCamera()
		return getCameras();

	public function getHoldSubdivisions()
		return Settings.setup.qualityLevel > 0.7 ? 8 : 4;

	public function getDownscroll()
		return Settings.setupP1.downscroll;

	public function getArrowItems() {
		var items:Array<Array<Array<FlxSprite>>> = [];

		for (i => field in arrowFields) {
			var strums:Array<Strum> = field.strums.members.copy();
			var notes:Array<Note> = [];
			field.notes.forEachAlive((note:Note) -> {
				notes.push(note);
			});
			var sustains:Array<Sustain> = [];
			field.sustains.forEachAlive((sustain:Sustain) -> {
				sustains.push(sustain);
			});

			items.push([
				strums,
				notes,
				sustains,
				field.members.copy().filter(sprite -> return !(sprite == strums || sprite == notes || sprite == sustains))
			]);
		}

		return items;
	}
}
