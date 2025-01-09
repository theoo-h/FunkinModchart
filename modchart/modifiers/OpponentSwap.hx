package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;

class OpponentSwap extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		var field = params.field;
		var distX = WIDTH / getPlayerCount();
		curPos.x -= distX * ModchartUtil.sign((field + 1) * 2 - 3) * getPercent('opponentSwap', field);
		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return getPercent('opponentSwap', params.field) != 0;
}
