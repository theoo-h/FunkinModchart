package modchart.engine.modifiers.list;

import modchart.backend.util.Constants.ArrowData;
import modchart.backend.util.Constants.RenderParams;

class Bounce extends Modifier {
	override public function render(curPos:Vector3, params:RenderParams) {
		var player = params.player;
		var speed = getPercent('bounceSpeed', player);
		var offset = getPercent('bounceOffset', player);

		var bounce = Math.abs(sin((params.curBeat + offset) * (1 + speed) * Math.PI)) * ARROW_SIZE;

		curPos.x += bounce * getPercent('bounceX', player);
		curPos.y += bounce * (getPercent('bounce', player) + getPercent('bounceY', player));
		curPos.z += bounce * getPercent('bounceZ', player);

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
