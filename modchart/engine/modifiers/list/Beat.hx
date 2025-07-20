package modchart.engine.modifiers.list;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import modchart.backend.core.ArrowData;
import modchart.backend.core.ModifierParameters;

class Beat extends Modifier {
	public function new(pf) {
		super(pf);
	}

	static var accelTime = 0.2;
	static var totalTime = 0.5;

	@:dox(hide)
	@:noCompletion private inline function computeBeat(curPos:Vector3, params:ModifierParameters, axis:String, realAxis:String) {
		final amount = getPercent('beat' + axis, params.player) + getPercent('beat' + axis + params.lane, params.player);
		if (amount == 0) return curPos;

		final mult = getPercent('beat' + axis + 'Mult', params.player),
			offset = getPercent('beat' + axis + 'Offset', params.player),
			period = getPercent('beat' + axis + 'Period', params.player);

		var beat = (params.curBeat + accelTime + offset) * (mult + 1);
		if (beat < 0) return curPos;

		var isEven = beat - 2 * Math.floor(beat * 0.5) >= 1;
		if ((beat -= Math.floor(beat)) > totalTime) return curPos;

		var shift:Float;
		if (beat < accelTime) {
			shift = beat * (1 / accelTime);
			shift *= shift;
		}
		else {
			shift = 1 - (beat - totalTime) / (accelTime - totalTime);
			shift = 1 - shift * shift;
		}
		if (isEven) shift *= -1;

		shift *= 20 * sin((params.distance * 0.01 * (period + 1)) + (Math.PI * 0.5)) * amount;

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
