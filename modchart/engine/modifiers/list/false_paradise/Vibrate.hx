package modchart.engine.modifiers.list.false_paradise;

import modchart.backend.util.Constants.ArrowData;
import modchart.backend.util.Constants.RenderParams;

class Vibrate extends Modifier {
	override public function render(curPos:Vector3, params:RenderParams) {
		var vib = getPercent('vibrate', params.player);
		curPos.x += (Math.random() - 0.5) * vib * 20;
		curPos.y += (Math.random() - 0.5) * vib * 20;

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return getPercent('vibrate', params.player) != 0;
}
