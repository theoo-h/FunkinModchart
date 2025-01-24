package modchart.modifiers;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;

class Boost extends Modifier {
	public function new(pf) {
		super(pf);

		setPercent('waveMult', 1, -1);
	}

	static final DIV38 = 1 / 38;

	override public function render(curPos:Vector3D, params:RenderParams) {
		var field = params.field;
		var lane = Std.string(params.receptor);

		final boost = (getPercent('boost', params.field) + getPercent('boost' + lane, params.field));
		final brake = (getPercent('brake', params.field) + getPercent('brake' + lane, params.field));
		final wave = (getPercent('wave', params.field) + getPercent('wave' + lane, params.field));

		if (boost != 0) {
			// Accelerate / Boost
			final scale = HEIGHT * (1 + (getPercent('boostScale', field)));
			final off = params.hDiff * 1.5 / ((params.hDiff + (scale) / 1.2) / scale);
			curPos.y += ModchartUtil.clamp(boost * (off - params.hDiff), -600, 600);
		}
		if (brake != 0) {
			// Decelerate / Brake
			final scale2 = HEIGHT * (1 + getPercent('brakeScale', field));

			var off2 = params.hDiff * 1.5 / ((params.hDiff + (scale2) / 1.2) / scale2);
			curPos.y += ModchartUtil.clamp(-brake * (off2 - params.hDiff), -600, 600);
		}
		if (wave != 0) {
			curPos.y += (-wave * 100) * sin(params.hDiff * DIV38 * getPercent('waveMult', field) * 0.2);
		}

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
