package modchart.modifiers;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;

class Accelerate extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		var field = params.field;
		final scale = 720 * (1 + (getPercent('accelerateScale', field)));

		var off = params.hDiff * 1.5 / ((params.hDiff + (scale) / 1.2) / scale);
		curPos.y += ModchartUtil.clamp(getPercent('accelerate', field) * (off - params.hDiff), -600, 600);

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return getPercent('accelerate', params.field) != 0;
}
