package modchart.engine.modifiers.list;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import modchart.backend.core.ArrowData;
import modchart.backend.core.ModifierParameters;

class Beat extends Modifier {
	public function new(pf) {
		super(pf);
	}

	@:dox(hide)
	@:noCompletion private inline function computeBeat(curPos:Vector3, params:ModifierParameters, axis:String, realAxis:String) {
		final amount = getPercent('beat' + axis, player) + getPercent('beat' + axis + Std.string(params.lane), params.player);
		if (amount == 0) return curPos;

		final mult = getPercent('beat' + axis + 'Mult', player),
			offset = getPercent('beat' + axis + 'Offset', player),
			period = getPercent('beat' + axis + 'Period', player);

		var beat = (params.curBeat + 0.2 + offset) * (mult + 1);
		if (beat == 0) return curPos;

		var isEven = beat - 2 * Math.floor(beat / 2) != 0;
		if ((beat -= Math.floor(beat)) > 0.5) return curPos;

		var shift:Float;
		if (beat < 0.2) {
			shift = beat / 5.0;
			shift *= shift;
		}
		else {
			shift = 3.33333333 * (b - 0.2);
			shift = 1 - shift * shift;
		}
		if (isEven) shift *= -1;

		shift *= 20 * sin((params.distance * 0.01 * (period + 1)) + (Math.PI * 0.5));

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
