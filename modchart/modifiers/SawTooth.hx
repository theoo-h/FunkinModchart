package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

class SawTooth extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		var field = params.field;
		final period = 1 + getPercent("sawtoothPeriod", field);
		curPos.x += (getPercent('sawtooth',
			field) * ARROW_SIZE) * ((0.5 / period * params.hDiff) / ARROW_SIZE - Math.floor((0.5 / period * params.hDiff) / ARROW_SIZE));

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return getPercent('sawtooth', params.field) != 0;
}
