package modchart.engine.modifiers.list;

import modchart.backend.util.Constants.ArrowData;
import modchart.backend.util.Constants.RenderParams;

class SawTooth extends Modifier {
	override public function render(curPos:Vector3, params:RenderParams) {
		var player = params.player;
		final period = 1 + getPercent("sawtoothPeriod", player);
		curPos.x += (getPercent('sawtooth',
			player) * ARROW_SIZE) * ((0.5 / period * params.distance) / ARROW_SIZE - Math.floor((0.5 / period * params.distance) / ARROW_SIZE));

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
