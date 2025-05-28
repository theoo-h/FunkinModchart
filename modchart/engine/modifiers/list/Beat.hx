package modchart.engine.modifiers.list;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import modchart.backend.core.ArrowData;
import modchart.backend.core.ModifierParameters;

class Beat extends Modifier {
	public function new(pf) {
		super(pf);
	}

	static var fAccelTime = 0.2;
	static var fTotalTime = 0.5;

	@:dox(hide)
	@:noCompletion private inline function beatMath(params:ModifierParameters, offset:Float, speed:Float, mult:Float):Float {
		var curBeat = speed * (params.curBeat + offset) + fAccelTime;

		if (curBeat < 0)
			return 0;

		curBeat = (curBeat % 1 + 1) % 1;

		if (curBeat >= fTotalTime)
			return 0;

		var fAmount = 0.0;
		if (curBeat < fAccelTime) {
			var v = curBeat / fAccelTime;
			fAmount = v * v;
		} else {
			var v = (fTotalTime - curBeat) / (fTotalTime - fAccelTime);
			fAmount = 1 - (1 - v) * (1 - v);
		}

		if (Math.floor(curBeat) % 2 != 0)
			fAmount = -fAmount;

		var fShift = 20 * fAmount * sin((params.distance * 0.01 * mult) + (Math.PI * .5));
		return fShift;
	}

	@:dox(hide)
	@:noCompletion private inline function computeBeat(curPos:Vector3, params:ModifierParameters, axis:String, realAxis:String) {
		final receptorName = Std.string(params.lane);
		final player = params.player;

		final amount = getPercent('beat' + axis, player) + getPercent('beat' + axis + receptorName, player);

		if (amount == 0)
			return curPos;

		final offset = getPercent('beat' + axis + 'Offset', player);
		final speed = getPercent('beat' + axis + 'Speed', player);
		final mult = getPercent('beat' + axis + 'Mult', player);

		var shift = beatMath(params, offset, 1 + speed, 1 + mult);

		switch (realAxis) {
			case 'x':
				curPos.x += shift;
			case 'y':
				curPos.y += shift;
			case 'z':
				curPos.z += shift;
		}

		return curPos;
	}

	override public function render(curPos:Vector3, params:ModifierParameters) {
		computeBeat(curPos, params, '', 'x');
		computeBeat(curPos, params, 'x', 'x');
		computeBeat(curPos, params, 'y', 'y');
		computeBeat(curPos, params, 'z', 'z');

		return curPos;
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
