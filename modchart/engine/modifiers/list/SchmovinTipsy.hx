package modchart.engine.modifiers.list;

import modchart.backend.util.Constants.ArrowData;
import modchart.backend.util.Constants.RenderParams;

class SchmovinTipsy extends Modifier {
	override public function render(curPos:Vector3, params:RenderParams) {
		curPos.y += sin(params.curBeat / 4 * Math.PI + params.lane) * ARROW_SIZEDIV2 * getPercent('schmovinTipsy', params.player);
		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
