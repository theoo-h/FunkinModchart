package modchart.engine.modifiers.list;

import modchart.backend.util.Constants.ArrowData;
import modchart.backend.util.Constants.RenderParams;
import modchart.backend.util.ModchartUtil;

class OpponentSwap extends Modifier {
	override public function render(curPos:Vector3, params:RenderParams) {
		final player = params.player;
		final perc = getPercent('opponentSwap', player);

		if (perc == 0)
			return curPos;

		var distX = WIDTH * .5;
		curPos.x -= distX * ModchartUtil.sign((player + 1) * 2 - 3) * perc;
		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
