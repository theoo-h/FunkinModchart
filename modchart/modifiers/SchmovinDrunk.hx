package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

final thtdiv = 1 / 222;

class SchmovinDrunk extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		var phaseShift = params.receptor * 0.5 + (params.hDiff * thtdiv) * Math.PI;
		curPos.x += sin(params.fBeat * .25 * Math.PI + phaseShift) * ARROW_SIZEDIV2 * getPercent('schmovinDrunk', params.field);

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
