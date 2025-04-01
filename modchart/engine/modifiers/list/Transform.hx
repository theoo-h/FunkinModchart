package modchart.engine.modifiers.list;

import modchart.backend.util.Constants.ArrowData;
import modchart.backend.util.Constants.RenderParams;

class Transform extends Modifier {
	override public function render(curPos:Vector3, params:RenderParams) {
		var receptorName = Std.string(params.lane);
		var player = params.player;

		curPos.x += getPercent('x', player) + getPercent('x' + receptorName, player) + getPercent('xoffset', player)
			+ getPercent('xoffset' + receptorName, player);
		curPos.y += getPercent('y', player) + getPercent('y' + receptorName, player) + getPercent('yoffset', player)
			+ getPercent('yoffset' + receptorName, player);
		curPos.z += getPercent('z', player) + getPercent('z' + receptorName, player) + getPercent('zoffset', player)
			+ getPercent('zoffset' + receptorName, player);

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
