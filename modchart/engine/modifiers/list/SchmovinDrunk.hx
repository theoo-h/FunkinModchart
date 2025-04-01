package modchart.engine.modifiers.list;

import modchart.backend.util.Constants.ArrowData;
import modchart.backend.util.Constants.RenderParams;

class SchmovinDrunk extends Modifier {
	final thtdiv = 1 / 222;

	override public function render(curPos:Vector3, params:RenderParams) {
		var phaseShift = params.lane * 0.5 + (params.distance * thtdiv) * Math.PI;
		curPos.x += sin(params.curBeat * .25 * Math.PI + phaseShift) * ARROW_SIZEDIV2 * getPercent('schmovinDrunk', params.player);

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
